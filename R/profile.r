#' Profile the performance of a function call.
#'
#' This is a wrapper around \code{\link{Rprof}} that provides results in an
#' alternative data structure, a data.frame.  The columns of the data.frame
#' are: 
#'
#' \describe{
#'   \item{f}{name of function}
#'   \item{level}{level in call stack}
#'   \item{time}{total time (seconds) spent in function}
#'   \item{start}{time at which control entered function}
#'   \item{end}{time at which control exited function}
#'   \item{leaf}{\code{TRUE} if the function is a terminal node in the call tree, i.e. didn't call any other functions}
#'   \item{source}{guess at the package that the function came from}
#' }
#'
#' @param expr expression to profile
#' @param interval interval between samples (in seconds)
#' @param quiet should output be discarded?
#' @return \code{\link{data.frame}} of class \code{profr}
#' @keywords debugging
#' @export
#' @seealso \code{\link{parse_rprof}} to parse standalone \code{\link{Rprof}}
#'   file, \code{\link{plot.profr}} and \code{\link{ggplot.profr}} 
#'   to visualise the profiling data
#' @examples
#' \dontrun{
#' glm_ex <- profr({Sys.sleep(1); example(glm)}, 0.01)
#' head(glm_ex)
#' summary(glm_ex)
#' plot(glm_ex)
#' }
profr <- function(expr, interval = 0.02, quiet = TRUE) {
  #assert(is.positive.integer(reps), "Repetitions (reps) must be a positive integer");
  #assert(is.function(f), "f must be a function");
  
  tmp <- tempfile()
  on.exit(unlink(tmp))
  on.exit(unlink("Rprof.out"), add=T)
  
  if (quiet) {
    tc <- textConnection(NULL, "w")
    sink(tc)
    on.exit(sink(), add=TRUE)
    on.exit(close(tc), add=TRUE)
  }
  
  Rprof(tmp, append=TRUE, interval = interval)
  try(force(expr))
  Rprof(NULL)
  
  n <- 6 + sys.nframe()
  parsed <- parse_rprof(tmp, interval)
  parsed <- parsed[parsed$level > n, ]
  parsed$level <- parsed$level - n
  parsed
} 
