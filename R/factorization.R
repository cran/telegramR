#  @details
#  This class implements the Pollard's Rho-Brent Integer Factorization algorithm
#  to efficiently factorize large integers into their prime components.
#  @title Factorization
#  @description Telegram API type Factorization
#  @export
#  @noRd
#  @noRd
Factorization <- R6::R6Class(
  "Factorization",
  public = list(
    #  @description
    #  Factorizes the given large integer.
    # 
    #  @details
    #  Implementation based on Pollard's Rho-Brent Integer Factorization algorithm.
    # 
    #  @param pq An integer representing the product of two primes.
    #  @return A numeric vector containing the two factors `p` and `q`.
    factorize = function(pq) {
      pq <- gmp::as.bigz(pq)
      if (gmp::mod.bigz(pq, 2) == 0) {
        return(list(p = gmp::as.bigz(2), q = gmp::divq.bigz(pq, 2)))
      }

      y <- gmp::as.bigz(2)
      c <- gmp::as.bigz(1)
      m <- gmp::as.bigz(1)
      g <- gmp::as.bigz(1)
      r <- gmp::as.bigz(1)
      q <- gmp::as.bigz(1)
      x <- gmp::as.bigz(0)
      ys <- gmp::as.bigz(0)

      while (g == 1) {
        x <- y
        for (i in 1:as.numeric(r)) {
          y <- gmp::mod.bigz(y * y + c, pq)
        }
        k <- gmp::as.bigz(0)
        while (k < r && g == 1) {
          ys <- y
          for (i in 1:min(as.numeric(m), as.numeric(r - k))) {
            y <- gmp::mod.bigz(y * y + c, pq)
            q <- gmp::mod.bigz(q * abs(x - y), pq)
          }
          g <- gmp::gcd.bigz(q, pq)
          k <- k + m
        }
        r <- r * 2
      }

      if (g == pq) {
        while (TRUE) {
          ys <- gmp::mod.bigz(ys * ys + c, pq)
          g <- gmp::gcd.bigz(abs(x - ys), pq)
          if (g > 1) break
        }
      }

      p <- g
      q_val <- gmp::divq.bigz(pq, p)

      if (p < q_val) {
        list(p = p, q = q_val)
      } else {
        list(p = q_val, q = p)
      }
    },

    #  @description
    #  Calculates the Greatest Common Divisor (GCD).
    # 
    #  @param a An integer.
    #  @param b Another integer.
    #  @return The GCD of `a` and `b`.
    gcd = function(a, b) {
      return(gmp::gcd.bigz(gmp::as.bigz(a), gmp::as.bigz(b)))
    }
  )
)
