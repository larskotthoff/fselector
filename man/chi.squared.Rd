\name{chi.squared}
\alias{chi.squared}
\title{ Chi-squared filter }
\description{
  The algorithm finds weights of discrete attributes basing on a chi-squared test.
}
\usage{
chi.squared(formula, data)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ a symbolic description of a model }
}
\details{
  The result is equal to Cramer's V coefficient between source attributes and destination attribute.
}
\value{
a data.frame containing the worth of attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{
  library(mlbench)
  data(HouseVotes84)

  weights <- chi.squared(Class~., HouseVotes84)
  print(weights)
  subset <- cutoff.k(weights, 5)
  f <- as.simple.formula(subset, "Class")
  print(f)
}
