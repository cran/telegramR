// [[Rcpp::depends(Rcpp)]]
#include <Rcpp.h>
#include <openssl/evp.h>
#include <cstring>
#include <cstdint>
#include <string>

using namespace Rcpp;

// ─────────────────────────────────────────────────────
// INTERNAL HELPERS
// ─────────────────────────────────────────────────────

static inline uint8_t hex_nibble(char c) {
  if (c >= '0' && c <= '9') return (uint8_t)(c - '0');
  if (c >= 'a' && c <= 'f') return (uint8_t)(c - 'a' + 10);
  if (c >= 'A' && c <= 'F') return (uint8_t)(c - 'A' + 10);
  return 0;
}

static const EVP_CIPHER* aes_ecb_cipher(int key_len) {
  switch (key_len) {
    case 16: return EVP_aes_128_ecb();
    case 24: return EVP_aes_192_ecb();
    case 32: return EVP_aes_256_ecb();
    default: return nullptr;
  }
}

// ─────────────────────────────────────────────────────
// 1. AES-IGE ENCRYPT
//
// IGE mode (matches R/aes.R encrypt_ige):
//   iv1 = iv[0..15], iv2 = iv[16..31]
//   For each 16-byte plaintext block P:
//     C = AES_ECB_encrypt(P XOR iv1) XOR iv2
//     iv1 = C,  iv2 = P
// ─────────────────────────────────────────────────────
// [[Rcpp::export]]
RawVector aes_ige_encrypt(RawVector key_raw, RawVector iv_raw, RawVector data_raw) {
  int key_len  = key_raw.size();
  int data_len = data_raw.size();

  if (!aes_ecb_cipher(key_len))
    stop("aes_ige_encrypt: key must be 16, 24, or 32 bytes");
  if (iv_raw.size() != 32)
    stop("aes_ige_encrypt: iv must be exactly 32 bytes");
  if (data_len % 16 != 0)
    stop("aes_ige_encrypt: data length must be a multiple of 16");

  const uint8_t* key = (const uint8_t*) RAW(key_raw);
  const uint8_t* iv  = (const uint8_t*) RAW(iv_raw);
  const uint8_t* src = (const uint8_t*) RAW(data_raw);

  EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
  if (!ctx) stop("EVP_CIPHER_CTX_new failed");
  EVP_EncryptInit_ex(ctx, aes_ecb_cipher(key_len), NULL, key, NULL);
  EVP_CIPHER_CTX_set_padding(ctx, 0);

  RawVector out(data_len);
  uint8_t* dst = (uint8_t*) RAW(out);

  uint8_t iv1[16], iv2[16], tmp[16];
  memcpy(iv1, iv,      16);
  memcpy(iv2, iv + 16, 16);

  int blocks = data_len / 16;
  for (int b = 0; b < blocks; ++b) {
    const uint8_t* P = src + b * 16;
    uint8_t*       C = dst + b * 16;

    for (int i = 0; i < 16; ++i) tmp[i] = P[i] ^ iv1[i];  // tmp = P XOR iv1

    int outl = 0;
    EVP_EncryptUpdate(ctx, C, &outl, tmp, 16);              // C = AES(tmp)

    for (int i = 0; i < 16; ++i) C[i] ^= iv2[i];           // C = C XOR iv2

    memcpy(iv1, C, 16);   // iv1 = C
    memcpy(iv2, P, 16);   // iv2 = P
  }

  EVP_CIPHER_CTX_free(ctx);
  return out;
}

// ─────────────────────────────────────────────────────
// 2. AES-IGE DECRYPT
//
// IGE mode (matches R/aes.R decrypt_ige):
//   iv1 = iv[0..15], iv2 = iv[16..31]
//   For each 16-byte ciphertext block C:
//     P = AES_ECB_decrypt(C XOR iv2) XOR iv1
//     iv1 = C,  iv2 = P
// ─────────────────────────────────────────────────────
// [[Rcpp::export]]
RawVector aes_ige_decrypt(RawVector key_raw, RawVector iv_raw, RawVector data_raw) {
  int key_len  = key_raw.size();
  int data_len = data_raw.size();

  if (!aes_ecb_cipher(key_len))
    stop("aes_ige_decrypt: key must be 16, 24, or 32 bytes");
  if (iv_raw.size() != 32)
    stop("aes_ige_decrypt: iv must be exactly 32 bytes");
  if (data_len % 16 != 0)
    stop("aes_ige_decrypt: data length must be a multiple of 16");

  const uint8_t* key = (const uint8_t*) RAW(key_raw);
  const uint8_t* iv  = (const uint8_t*) RAW(iv_raw);
  const uint8_t* src = (const uint8_t*) RAW(data_raw);

  EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
  if (!ctx) stop("EVP_CIPHER_CTX_new failed");
  EVP_DecryptInit_ex(ctx, aes_ecb_cipher(key_len), NULL, key, NULL);
  EVP_CIPHER_CTX_set_padding(ctx, 0);

  RawVector out(data_len);
  uint8_t* dst = (uint8_t*) RAW(out);

  uint8_t iv1[16], iv2[16], tmp[16];
  memcpy(iv1, iv,      16);
  memcpy(iv2, iv + 16, 16);

  int blocks = data_len / 16;
  for (int b = 0; b < blocks; ++b) {
    const uint8_t* C = src + b * 16;
    uint8_t*       P = dst + b * 16;

    for (int i = 0; i < 16; ++i) tmp[i] = C[i] ^ iv2[i];  // tmp = C XOR iv2

    int outl = 0;
    EVP_DecryptUpdate(ctx, P, &outl, tmp, 16);              // P = AES_dec(tmp)

    for (int i = 0; i < 16; ++i) P[i] ^= iv1[i];           // P = P XOR iv1

    memcpy(iv1, C, 16);   // iv1 = C
    memcpy(iv2, P, 16);   // iv2 = P
  }

  EVP_CIPHER_CTX_free(ctx);
  return out;
}

// ─────────────────────────────────────────────────────
// 3. PACK INT64  (little-endian, 8 bytes)
//
// Handles: double, integer, character (decimal string).
// The R wrapper coerces bigz to character before calling.
// Negatives are handled via two's-complement wrap in uint64_t.
// ─────────────────────────────────────────────────────
// [[Rcpp::export]]
RawVector pack_int64(SEXP x) {
  uint64_t val = 0;

  if (TYPEOF(x) == REALSXP) {
    double dv = REAL(x)[0];
    if (dv < 0.0) {
      uint64_t pos = (uint64_t)(-dv);
      val = ~pos + 1ULL;
    } else {
      val = (uint64_t) dv;
    }
  } else if (TYPEOF(x) == INTSXP) {
    int iv = INTEGER(x)[0];
    if (iv < 0) {
      uint64_t pos = (uint64_t)(-iv);
      val = ~pos + 1ULL;
    } else {
      val = (uint64_t) iv;
    }
  } else if (TYPEOF(x) == STRSXP) {
    const char* s = CHAR(STRING_ELT(x, 0));
    if (s[0] == '-') {
      uint64_t pos = strtoull(s + 1, nullptr, 10);
      val = ~pos + 1ULL;
    } else {
      val = strtoull(s, nullptr, 10);
    }
  } else {
    stop("pack_int64: unsupported type — pass numeric or character");
  }

  RawVector out(8);
  uint8_t* p = (uint8_t*) RAW(out);
  for (int i = 0; i < 8; ++i) {
    p[i] = (uint8_t)(val & 0xFF);
    val >>= 8;
  }
  return out;
}

// ─────────────────────────────────────────────────────
// 4. UNPACK INT64  (little-endian, 8 bytes → double)
//
// Returns double (same precision limitation as the R version).
// ─────────────────────────────────────────────────────
// [[Rcpp::export]]
double unpack_int64(RawVector raw_vector) {
  if (raw_vector.size() != 8)
    stop("unpack_int64: raw_vector must be exactly 8 bytes");
  const uint8_t* p = (const uint8_t*) RAW(raw_vector);
  uint64_t val = 0;
  for (int i = 7; i >= 0; --i) val = (val << 8) | p[i];
  return (double) val;
}

// ─────────────────────────────────────────────────────
// 5. XOR BYTES
//
// Exported as xor_bytes_cpp to avoid name collision with
// the existing R-level xor_bytes() wrapper in utils.R.
// Returns min(length(a), length(b)) bytes.
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "xor_bytes_cpp")]]
RawVector xor_bytes(RawVector a, RawVector b) {
  int len = std::min(a.size(), b.size());
  if (len == 0) return RawVector(0);
  RawVector out(len);
  const uint8_t* pa = (const uint8_t*) RAW(a);
  const uint8_t* pb = (const uint8_t*) RAW(b);
  uint8_t*       po = (uint8_t*)       RAW(out);
  for (int i = 0; i < len; ++i) po[i] = pa[i] ^ pb[i];
  return out;
}

// ─────────────────────────────────────────────────────
// 6. BYTES → INT32  (little-endian, 1–4 bytes)
//
// Replaces the pure-R path in BinaryReader$bytes_to_int
// for length(bytes) <= 4:
//   sum(as.numeric(bytes) * 256^(seq_along(bytes) - 1))
//
// Returns:
//   signed=TRUE  → integer (INT32, two's-complement for n bytes)
//   signed=FALSE → double  (unsigned, may exceed R integer range)
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "bytes_to_int32_cpp")]]
SEXP bytes_to_int32(RawVector bytes, bool is_signed) {
  int n = bytes.size();
  if (n < 1 || n > 4)
    stop("bytes_to_int32_cpp: expected 1–4 bytes");
  const uint8_t* b = (const uint8_t*) RAW(bytes);

  uint32_t val = 0;
  for (int i = 0; i < n; ++i) val |= ((uint32_t)b[i] << (8 * i));

  if (!is_signed) {
    return wrap((double) val);
  }

  // Signed two's-complement for exactly n bytes
  if (n == 4) {
    return wrap((int)(int32_t) val);
  }
  // n < 4: check sign bit at position 8*n-1
  uint32_t sign_bit = 1u << (8 * n - 1);
  if (val & sign_bit) {
    // Sign-extend to 32 bits
    uint32_t extend = 0xFFFFFFFFu << (8 * n);
    return wrap((int)(int32_t)(val | extend));
  }
  return wrap((int) val);
}

// ─────────────────────────────────────────────────────
// 7. BYTES → HEX STRING  (big-endian, reversed byte order)
//
// Replaces:
//   paste(sprintf("%02x", as.integer(rev(bytes))), collapse = "")
//
// Used by BinaryReader$bytes_to_int (>4 bytes) and
// BinaryReader$read_large_int to build a hex string
// that R then passes to gmp::as.bigz(paste0("0x", ...)).
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "bytes_to_hex_be_cpp")]]
String bytes_to_hex_be(RawVector bytes) {
  static const char digits[] = "0123456789abcdef";
  int n = bytes.size();
  const uint8_t* b = (const uint8_t*) RAW(bytes);

  std::string hex;
  hex.reserve(n * 2);
  for (int i = n - 1; i >= 0; --i) {
    hex.push_back(digits[(b[i] >> 4) & 0xF]);
    hex.push_back(digits[ b[i]       & 0xF]);
  }
  return hex;
}

// ─────────────────────────────────────────────────────
// 8. SERIALIZE BYTES  (TL wire format)
//
// Replaces serialize_bytes() in tlobject.R:
//   r <- list(...)
//   r <- append(r, ...)
//   do.call(c, r)
//
// Short format (<254 bytes):  [len:1] [data] [pad to 4]
// Long  format (>=254 bytes): [0xFE:1][len:3 LE] [data] [pad to 4]
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "serialize_bytes_cpp")]]
RawVector serialize_bytes_cpp(RawVector data) {
  int data_len = data.size();
  int header_len, padding;

  if (data_len < 254) {
    header_len = 1;
    padding    = (data_len + 1) % 4;
    if (padding) padding = 4 - padding;
  } else {
    header_len = 4;
    padding    = data_len % 4;
    if (padding) padding = 4 - padding;
  }

  int total = header_len + data_len + padding;
  RawVector out(total);
  uint8_t* p = (uint8_t*) RAW(out);

  if (data_len < 254) {
    *p++ = (uint8_t) data_len;
  } else {
    *p++ = 0xFEu;
    *p++ = (uint8_t)( data_len        & 0xFF);
    *p++ = (uint8_t)((data_len >>  8) & 0xFF);
    *p++ = (uint8_t)((data_len >> 16) & 0xFF);
  }

  memcpy(p, RAW(data), data_len);
  p += data_len;
  memset(p, 0, padding);

  return out;
}

// ─────────────────────────────────────────────────────
// 9. PACK INT32  (little-endian, 4 bytes)
//
// Replaces the 4-iteration loop in packInt32() in
// mtprotoplainsender.R and mtprotostate.R.
// Handles negative values via two's-complement uint32_t cast.
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "pack_int32_cpp")]]
RawVector pack_int32(double value) {
  uint32_t v = (uint32_t)(int32_t)(int64_t) value;
  RawVector out(4);
  uint8_t* p = (uint8_t*) RAW(out);
  p[0] = (uint8_t)( v        & 0xFF);
  p[1] = (uint8_t)((v >>  8) & 0xFF);
  p[2] = (uint8_t)((v >> 16) & 0xFF);
  p[3] = (uint8_t)((v >> 24) & 0xFF);
  return out;
}

// ─────────────────────────────────────────────────────
// 10. HEX STRING → BYTES  (big-endian hex, pad/trim to length)
//
// Replaces the substring+strtoi chain in int_to_bytes()
// in utils.R.  The R caller still does the gmp bigz→hex
// conversion; this function handles the slow part:
//   as.raw(strtoi(substring(hex, seq(...), seq(...)), base=16))
//
// hex_str:      even- or odd-length lowercase hex string
// out_len:      desired output length in bytes
// little_endian: TRUE → reverse byte order in output
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "hex_to_bytes_cpp")]]
RawVector hex_to_bytes(String hex_str, int out_len, bool little_endian) {
  if (out_len < 0) stop("hex_to_bytes_cpp: out_len must be >= 0");
  const char* hex = hex_str.get_cstring();
  int n = (int) strlen(hex);
  int nbytes = (n + 1) / 2;   // bytes represented by hex string

  // Decode hex → bytes (big-endian, variable length)
  std::vector<uint8_t> bytes(nbytes, 0);
  for (int i = 0; i < nbytes; ++i) {
    // Index from left: first nibble of first byte
    int pos = n - 2 * (nbytes - i);  // position of high nibble in hex string
    if (pos < 0) {
      // Odd-length: first byte only has one nibble (low)
      bytes[i] = hex_nibble(hex[pos + 1]);
    } else {
      bytes[i] = (hex_nibble(hex[pos]) << 4) | hex_nibble(hex[pos + 1]);
    }
  }

  // Copy into output of exactly out_len bytes, with big-endian alignment
  RawVector out(out_len);
  uint8_t* p = (uint8_t*) RAW(out);
  if (nbytes >= out_len) {
    // Trim leading bytes
    memcpy(p, bytes.data() + (nbytes - out_len), out_len);
  } else {
    // Pad with leading zeros
    int pad = out_len - nbytes;
    memset(p, 0, pad);
    memcpy(p + pad, bytes.data(), nbytes);
  }

  if (little_endian) {
    for (int i = 0, j = out_len - 1; i < j; ++i, --j) {
      uint8_t tmp = p[i]; p[i] = p[j]; p[j] = tmp;
    }
  }
  return out;
}

// ─────────────────────────────────────────────────────
// 11. ENCODE WAVEFORM  (5-bit packing)
//
// Replaces encode_waveform() in utils.R.
// Each element of `waveform` is a 5-bit value (0–31).
// Bits are packed consecutively, LSB-first within each byte.
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "encode_waveform_cpp")]]
RawVector encode_waveform_cpp(RawVector waveform) {
  int n = waveform.size();
  if (n == 0) return RawVector(0);
  int bits_count  = n * 5;
  int bytes_count = (bits_count + 7) / 8;

  RawVector out(bytes_count);
  uint8_t* dst = (uint8_t*) RAW(out);
  memset(dst, 0, bytes_count);

  const uint8_t* src = (const uint8_t*) RAW(waveform);
  for (int i = 0; i < n; ++i) {
    int bit_pos  = i * 5;
    int byte_idx = bit_pos / 8;
    int bit_off  = bit_pos % 8;
    uint16_t val = (uint16_t)(src[i] & 0x1Fu) << bit_off;
    dst[byte_idx] |= (uint8_t)(val & 0xFFu);
    if (byte_idx + 1 < bytes_count)
      dst[byte_idx + 1] |= (uint8_t)(val >> 8);
  }
  return out;
}

// ─────────────────────────────────────────────────────
// 12. DECODE WAVEFORM  (5-bit unpacking)
//
// Inverse of encode_waveform_cpp.
// Replaces decode_waveform() in utils.R.
// ─────────────────────────────────────────────────────
// [[Rcpp::export(name = "decode_waveform_cpp")]]
RawVector decode_waveform_cpp(RawVector waveform) {
  int n = waveform.size();
  if (n == 0) return RawVector(0);
  int value_count = (n * 8) / 5;
  if (value_count == 0) return RawVector(0);

  const uint8_t* src = (const uint8_t*) RAW(waveform);
  RawVector out(value_count);
  uint8_t* dst = (uint8_t*) RAW(out);

  for (int i = 0; i < value_count; ++i) {
    int bit_pos  = i * 5;
    int byte_idx = bit_pos / 8;
    int bit_off  = bit_pos % 8;
    uint16_t val = (uint16_t) src[byte_idx];
    if (byte_idx + 1 < n)
      val |= (uint16_t) src[byte_idx + 1] << 8;
    dst[i] = (uint8_t)((val >> bit_off) & 0x1Fu);
  }
  return out;
}
