\name{normalize.min.max}
\alias{normalize.min.max}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
normalize.min.max(data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{ ~~Describe \code{data} here~~ }
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
function (data) 
{
    attr_count = dim(data)[2]
    if (attr_count == 0) 
        return(data)
    for (i in 1:attr_count) {
        if (!is.numeric(data[, i])) 
            next()
        if (!any(complete.cases(data[, i]))) 
            next()
        minimum = min(data[, i], na.rm = TRUE)
        maximum = max(data[, i], na.rm = TRUE)
        if (minimum == maximum) 
            data[, i] = data[, i]/minimum
        else data[, i] = (data[, i] - minimum)/(maximum - minimum)
    }
    return(data)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
