\name{exhaustive.search}
\alias{exhaustive.search}
\title{ Exhaustive search }
\description{
  The algorithm for searching atrribute subset space.
}
\usage{
exhaustive.search(attributes, eval.fun)
}
\arguments{
  \item{attributes}{ a character vector of all attributes to search in }
  \item{eval.fun}{ a function taking as first parameter a character vector of all attributes and returning a numeric indicating how important a given subset is }
}
\details{
  The algorithm searches the whole attribute subset space in breadth-first order.
}
\value{
  A character vector of selected attributes.
}
\author{ Piotr Romanski }
\seealso{ \code{\link{forward.search}}, \code{\link{backward.search}}, \code{\link{best.first.search}}, \code{\link{hill.climbing.search}} }
\examples{

}
