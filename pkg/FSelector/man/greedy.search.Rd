\name{greedy.search}
\alias{greedy.search}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
greedy.search(attributes, eval.fun, forward = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{attributes}{ ~~Describe \code{attributes} here~~ }
  \item{eval.fun}{ ~~Describe \code{eval.fun} here~~ }
  \item{forward}{ ~~Describe \code{forward} here~~ }
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
function (attributes, eval.fun, forward = TRUE) 
{
    if (length(attributes) == 0) 
        stop("Attributes not specified")
    eval.fun = match.fun(eval.fun)
    best = list(result = -Inf, attrs = rep(as.numeric(!forward), 
        length(attributes)))
    if (!forward) {
        best$result = eval.fun(attributes[as.logical(best$attrs)])
    }
    forward_text = ifelse(forward, "forward", "backward")
    repeat {
        children = create.children(best$attrs, forward_text)
        if (is.null(children)) 
            break()
        children_results = apply(children, 1, function(vec) {
            eval.fun(attributes[as.logical(vec)])
        })
        local_best = find.best(children_results)
        if (local_best$result > best$result) {
            best$result = local_best$result
            best$attrs = children[local_best$idx, ]
        }
        else {
            break()
        }
    }
    return(attributes[as.logical(best$attrs)])
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
