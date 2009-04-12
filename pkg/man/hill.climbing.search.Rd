\name{hill.climbing.search}
\alias{hill.climbing.search}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
hill.climbing.search(attributes, eval.fun)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{attributes}{ ~~Describe \code{attributes} here~~ }
  \item{eval.fun}{ ~~Describe \code{eval.fun} here~~ }
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
function (attributes, eval.fun) 
{
    if (length(attributes) == 0) 
        stop("Attributes not specified")
    eval.fun = match.fun(eval.fun)
    best = list(result = -Inf, attrs = rep(0, length(attributes)))
    while (sum(best$attrs) == 0) best$attrs = sample(c(0, 1), 
        length(attributes), replace = TRUE)
    best$result = eval.fun(attributes[as.logical(best$attrs)])
    evaluated_states = list(attrs = matrix(best$attrs, nrow = 1, 
        ncol = length(attributes), byrow = TRUE), results = best$result)
    eval_state <- function(state, evaluated_states) {
        idx = find.subset(evaluated_states$attrs, state)
        if (length(idx) == 0) {
            return(list(to_be_saved = TRUE, result = eval.fun(attributes[as.logical(state)])))
        }
        else if (length(idx) == 1) {
            return(list(to_be_saved = FALSE, result = evaluated_states$results[idx]))
        }
        else {
            stop("Internal error")
        }
    }
    repeat {
        children = create.children(best$attrs, direction = "both")
        if (is.null(children)) 
            break()
        children_evaluated = apply(children, 1, function(vec) {
            eval_state(vec, evaluated_states)
        })
        children_results = sapply(children_evaluated, function(x) x$result)
        children_to_be_saved = sapply(children_evaluated, function(x) x$to_be_saved)
        evaluated_states$attrs = rbind(evaluated_states$attrs, 
            children[children_to_be_saved, , drop = FALSE])
        evaluated_states$results = c(evaluated_states$results, 
            children_results[children_to_be_saved])
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
