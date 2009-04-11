\name{create.children}
\alias{create.children}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
create.children(parent, direction = c("forward", "backward", "both"), omit.func = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{parent}{ ~~Describe \code{parent} here~~ }
  \item{direction}{ ~~Describe \code{direction} here~~ }
  \item{omit.func}{ ~~Describe \code{omit.func} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (parent, direction = c("forward", "backward", "both"), 
    omit.func = NULL) 
{
    direction = match.arg(direction)
    if (!is.null(omit.func)) {
        omit.func = match.fun(omit.func)
    }
    cols = length(parent)
    if (cols <= 0) 
        stop("Parent attribute set cannot be empty.")
    m1 = NULL
    m2 = NULL
    if (direction == "forward" || direction == "both") {
        rows = cols - sum(parent)
        if (rows > 0) {
            m1 = matrix(parent, ncol = cols, nrow = rows, byrow = TRUE)
            current_row = 1
            current_col = 1
            repeat {
                if (current_col > cols || current_row > rows) 
                  break()
                if (m1[current_row, current_col] == 0) {
                  m1[current_row, current_col] = 1
                  current_row = current_row + 1
                }
                current_col = current_col + 1
            }
        }
    }
    if (direction == "backward" || direction == "both") {
        rows = sum(parent)
        if (rows > 1) {
            m2 = matrix(parent, ncol = cols, nrow = rows, byrow = TRUE)
            current_row = 1
            current_col = 1
            repeat {
                if (current_col > cols || current_row > rows) 
                  break()
                if (m2[current_row, current_col] == 1) {
                  m2[current_row, current_col] = 0
                  current_row = current_row + 1
                }
                current_col = current_col + 1
            }
        }
    }
    m = rbind(m1, m2)
    if (!is.null(omit.func)) {
        rows_to_omit = apply(m, 1, omit.func)
        return(m[!rows_to_omit, , drop = FALSE])
    }
    else {
        return(m)
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
