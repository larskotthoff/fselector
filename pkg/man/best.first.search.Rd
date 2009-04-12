\name{best.first.search}
\alias{best.first.search}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
best.first.search(attributes, eval.fun, max.backtracks = 5)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{attributes}{ ~~Describe \code{attributes} here~~ }
  \item{eval.fun}{ ~~Describe \code{eval.fun} here~~ }
  \item{max.backtracks}{ ~~Describe \code{max.backtracks} here~~ }
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
function (attributes, eval.fun, max.backtracks = 5) 
{
    if (length(attributes) == 0) 
        stop("Attributes not specified")
    eval.fun = match.fun(eval.fun)
    attach_children <- function(states, best) {
        parent_state = states$attrs[best$idx, ]
        children = create.children(parent_state, "forward", omit.func = function(...) {
            length(find.subset(states$attrs, ...)) > 0
        })
        children_len = dim(children)[1]
        if (children_len > 0) {
            states$attrs = rbind(states$attrs, children)
            states$open = c(states$open, rep(TRUE, children_len))
            states$results = c(states$results, rep(NA, children_len))
        }
        return(states)
    }
    states = list(attrs = diag(length(attributes)), open = rep(TRUE, 
        length(attributes)), results = rep(NA, length(attributes)))
    colnames(states$attrs) = attributes
    best = list(result = -Inf, idx = NULL)
    repeat {
        rows_to_eval = states$open & is.na(states$results)
        if (any(rows_to_eval)) {
            states$results[rows_to_eval] = apply(states$attrs[rows_to_eval, 
                , drop = FALSE], 1, function(vec) {
                attrs = attributes[as.logical(vec)]
                return(eval.fun(attrs))
            })
        }
        new_best = find.best(states$results, states$open)
        if (is.null(new_best$result)) 
            break()
        states$open[new_best$idx] = FALSE
        if (new_best$result > best$result) {
            best = new_best
            states = attach_children(states, best)
        }
        else {
            if (max.backtracks > 0) {
                max.backtracks = max.backtracks - 1
            }
            else break
        }
    }
    return(attributes[as.logical(states$attrs[best$idx, ])])
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
