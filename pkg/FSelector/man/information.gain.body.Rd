\name{information.gain.body}
\alias{information.gain.body}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
information.gain.body(formula, data, type = c("infogain", "infogainratio", "symuncert"))
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
function (formula, data, type = c("infogain", "infogainratio", 
    "symuncert")) 
{
    type = match.arg(type)
    new_data = get.data.frame.from.formula(formula, data)
    new_data = discretize.all(formula, new_data)
    attr_entropies = sapply(new_data, entropy)
    class_entropy = attr_entropies[1]
    attr_entropies = attr_entropies[-1]
    joint_entropies = sapply(new_data[-1], function(t) {
        joint.entropy(new_data[[1]], t)
    })
    results = class_entropy + attr_entropies - joint_entropies
    if (type == "infogainratio") {
        results = results/attr_entropies
    }
    else if (type == "symuncert") {
        results = 2 * results/(attr_entropies + class_entropy)
    }
    attr_names = dimnames(new_data)[[2]][-1]
    return(data.frame(attr_importance = results, row.names = attr_names))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
