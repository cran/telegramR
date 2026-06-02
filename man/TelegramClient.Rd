% Generated manually
\name{TelegramClient}
\alias{TelegramClient}
\title{TelegramClient}
\description{
High-level Telegram MTProto client. Use \code{TelegramClient$new()} to create a session and connect.
}
\details{
This is an R6 class. Typical usage:
\preformatted{
client <- TelegramClient$new("my_session", api_id = 123, api_hash = "...")
client$connect()
}
}
\usage{TelegramClient}
\value{
An R6 object of class \code{TelegramClient}.
}
\examples{
\dontrun{
client <- TelegramClient$new("my_session", api_id = 123, api_hash = "...")
client$connect()
}
}
\seealso{\code{\link{TelegramBaseClient}}}
