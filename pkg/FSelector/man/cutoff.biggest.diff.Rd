\name{cutoff.biggest.diff}
\alias{cutoff.biggest.diff}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
cutoff.biggest.diff(attrs)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{attrs}{ ~~Describe \code{attrs} here~~ }
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
function (attrs) 
{
    if (dim(attrs)[1] == 0) 
        return(character(0))
    else if (dim(attrs)[1] == 1) 
        return(dimnames(attrs)[[1]])
    perm = order(attrs[, 1], decreasing = TRUE)
    attrs = attrs[perm, , drop = FALSE]
    intervals = sapply(1:(dim(attrs)[1] - 1), function(idx) {
        attrs[idx, 1] - attrs[idx + 1, 1]
    })
    return(dimnames(attrs)[[1]][1:(which.max(intervals))])
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
