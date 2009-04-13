\name{greedy.search}
\alias{backward.search}
\alias{forward.search}
\title{ Greedy search }
\description{
  The algorithms for searching atrributes' subset space.
}
\usage{
backward.search(attributes, eval.fun)
forward.search(attributes, eval.fun)
}
\arguments{
  \item{attributes}{ a character vector of all attributes to search in }
  \item{eval.fun}{ a function taking as first parameter a character vector of all attributes and returning a numeric indicating how important a given subset is }
}
\details{
  These algorithms implement greedy search. At first, the algorithms expand starting node, evaluate its children and choose the best one which becomes a new starting node. This process goes only in one direction. \code{forward.search} starts from an empty and \code{backward.search} from a full set of attributes.
}
\value{
  A character vector of selected attributes.
}
\author{ Piotr Romanski }
\seealso{ \code{\link{best.first.search}}, \code{\link{hill.climbing.search}} }
\examples{

}
