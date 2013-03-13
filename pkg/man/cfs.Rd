\name{cfs}
\alias{cfs}
\title{ CFS filter }
\description{
  The algorithm finds attribute subset using correlation and entropy measures for continous and discrete data.
}
\usage{
cfs(formula, data)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }}
\details{
  The alorithm makes use of \code{\link{best.first.search}} for searching the attribute subset space.
}
\seealso{ \code{\link{best.first.search}} }
\value{
a character vector containing chosen attributes
}
\author{ Piotr Romanski }
\examples{
  data(iris)
  
  subset <- cfs(Species~., iris)
  f <- as.simple.formula(subset, "Species")
  print(f)
}