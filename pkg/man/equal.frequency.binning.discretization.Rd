\name{equal.frequency.binning.discretization}
\alias{equal.frequency.binning.discretization}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
equal.frequency.binning.discretization(data, bins)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{ ~~Describe \code{data} here~~ }
  \item{bins}{ ~~Describe \code{bins} here~~ }
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
function (data, bins) 
{
    bins = as.integer(bins)
    if (!is.numeric(data)) 
        stop("Data must be numeric")
    if (bins < 1) 
        stop("Number of bins too small")
    complete = complete.cases(data)
    ord = order(data)
    len = length(data[complete])
    blen = len/bins
    new_data = data
    p1 = p2 = 0
    for (i in 1:bins) {
        p1 = p2 + 1
        p2 = round(i * blen)
        new_data[ord[p1:min(p2, len)]] = i
    }
    return(factor(new_data))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
