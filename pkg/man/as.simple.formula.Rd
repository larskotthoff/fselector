\name{as.simple.formula}
\alias{as.simple.formula}
\title{ Converting to formulas }
\description{
  Converts character vector of atrributes' names and destination attribute's name to a simple formula.
}
\usage{
as.simple.formula(attributes, class)
}
\arguments{
  \item{attributes}{ character vector of attributes' names }
  \item{class}{ name of destination attribute }
}
\value{
  A simple formula like "class ~ attr1 + attr2"
}
\author{ Piotr Romanski }
\examples{
data(iris)
result <- cfs(Species ~ ., iris)
f <- as.simple.formula(result, "Species")
}