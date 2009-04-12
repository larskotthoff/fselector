\name{consistency}
\alias{consistency}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
consistency(formula, data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula}{ ~~Describe \code{formula} here~~ }
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
function (formula, data) 
{
    evaluator <- function(attrs) {
        attr_data = new_data[, attrs, drop = FALSE]
        hashvec = as.factor(apply(attr_data, 1, digest))
        result = aggregate(new_data[[1]], list(hash = hashvec), 
            function(classes) {
                return(max(as.vector(table(classes))))
            })
        result = sum(result[[2]])/length(hashvec)
        print(attrs)
        print(result)
        return(result)
    }
    new_data = get.data.frame.from.formula(formula, data)
    new_data = discretize.all(formula, new_data)
    column_names = names(new_data)
    result = best.first.search(column_names[-1], evaluator)
    return(result)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
