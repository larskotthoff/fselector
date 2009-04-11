\name{correlation.body}
\alias{correlation.body}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
correlation.body(formula, data, type = c("pearson", "spearman"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula}{ ~~Describe \code{formula} here~~ }
  \item{data}{ ~~Describe \code{data} here~~ }
  \item{type}{ ~~Describe \code{type} here~~ }
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
function (formula, data, type = c("pearson", "spearman")) 
{
    type = match.arg(type)
    new_data = get.data.frame.from.formula(formula, data)
    lapply(new_data, function(vec) {
        if (is.factor(vec)) 
            stop("All data must be continous.")
    })
    class_data = new_data[[1]]
    new_data = new_data[-1]
    class_data_complete = complete.cases(class_data)
    results = abs(sapply(new_data, function(attr_data) {
        complete = complete.cases(attr_data) & class_data_complete
        if (!any(complete)) return(NA)
        vec1 = class_data[complete]
        vec2 = attr_data[complete]
        if (sd(vec1) == 0 || sd(vec2) == 0) return(NA)
        return(cor(vec1, vec2, method = type))
    }))
    attr_names = dimnames(new_data)[[2]]
    return(data.frame(attr_importance = results, row.names = attr_names))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
