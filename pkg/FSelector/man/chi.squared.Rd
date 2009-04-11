\name{chi.squared}
\alias{chi.squared}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
chi.squared(formula, data)
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
    new_data = get.data.frame.from.formula(formula, data)
    new_data = discretize.all(formula, new_data)
    class_data = new_data[[1]]
    new_data = new_data[-1]
    results = sapply(new_data, function(w) {
        cont = table(class_data, w)
        row_sums = apply(cont, 1, sum)
        col_sums = apply(cont, 2, sum)
        all_sum = sum(col_sums)
        expected_matrix = t(as.matrix(col_sums) \%*\% t(as.matrix(row_sums)))/all_sum
        return(sum((cont - expected_matrix)^2/expected_matrix))
    })
    attr_names = dimnames(new_data)[[2]]
    return(data.frame(attr_importance = results, row.names = attr_names))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
