\name{oneR}
\alias{oneR}
\title{ OneR algorithm }
\description{
  The algorithms find weights of discrete attributes basing on very simple association rules involving only one attribute in condition part.
}
\usage{
oneR(formula, data)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
}
\details{
  The algorithm uses OneR classifier to find out the attributes' weights. For each attribute it creates a simple rule based only on that attribute and then calculates its error rate.
}
\value{
a data.frame containing the worth of attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{
  library(mlbench)
  data(HouseVotes84)
  
  weights <- oneR(Class~., HouseVotes84)
  print(weights)
  subset <- cutoff.k(weights, 5)
  f <- as.simple.formula(subset, "Class")
  print(f)
}
