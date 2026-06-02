% Generated manually
\name{TelegramBaseClient}
\alias{TelegramBaseClient}
\title{TelegramBaseClient}
\description{
Low-level Telegram MTProto client. Most users should use \code{TelegramClient}.
}
\details{
This is an R6 class providing lower-level transport and protocol operations.
}
\usage{TelegramBaseClient}
\value{
An R6 object of class \code{TelegramBaseClient}.
}
\examples{
\dontrun{
client <- TelegramClient$new("my_session", api_id = 123, api_hash = "abc")
client$connect()
}
}
\seealso{\code{\link{TelegramClient}}}
