\name{hill.climbing.search}
\alias{hill.climbing.search}
\title{ Hill climbing search }
\description{
  The algorithm for searching atrribute subset space.
}
\usage{
hill.climbing.search(attributes, eval.fun)
}
\arguments{
  \item{attributes}{ a character vector of all attributes to search in }
  \item{eval.fun}{ a function taking as first parameter a character vector of all attributes and returning a numeric indicating how important a given subset is }
}
\details{
  The algorithm starts with a random attribute set. Then it evaluates all its neighbours and chooses the best one. It might be susceptible to local maximum.
}
\value{
  A character vector of selected attributes.
}
\author{ Piotr Romanski }
\seealso{ \code{\link{forward.search}}, \code{\link{backward.search}}, \code{\link{best.first.search}}, \code{\link{exhaustive.search}} }
\examples{

}
