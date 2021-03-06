\name{parse_rprof}
\alias{parse_rprof}
\title{Parse Rprof output.}
\usage{parse_rprof(path, interval=0.02)}

\description{
  Parse Rprof output.
}

\details{
  Parses the output of \code{\link{Rprof}} into an
  alternative format described in \code{\link{profr}}. This
  produces a flat data frame, which is somewhat easier to
  summarise and visualise.
}
\keyword{debugging}
\value{\code{\link{data.frame}} of class \code{profr}}
\seealso{\code{\link{profr}} for profiling and parsing}
\arguments{
  \item{path}{path to \code{\link{Rprof}} output}
  \item{interval}{real-time interval between samples (in seconds)}
}
\examples{nesting_ex <- system.file("samples", "nesting.rprof", package="profr")
nesting <- parse_rprof(nesting_ex)

reshape_ex <- system.file("samples", "reshape.rprof", package="profr")
diamonds <- parse_rprof(reshape_ex)
p <- profr(parse_rprof(reshape_ex))}
