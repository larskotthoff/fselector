\name{cutoff}
\alias{cutoff.k}
\alias{cutoff.k.percent}
\alias{cutoff.biggest.diff}
\title{ Cutoffs }
\description{
  The algorithms select a subset from a ranked attributes.
}
\usage{
cutoff.k(attrs, k)
cutoff.k.percent(attrs, k)
cutoff.biggest.diff(attrs)
}
\arguments{
  \item{attrs}{ a data.frame containing ranks for attributes in the first column and their names as row names }
  \item{k}{ a positive integer in case of \code{cutoff.k} and a numeric between 0 and 1 in case of \code{cutoff.k.percent} }
}
\details{
  \code{cutoff.k} chooses k best attributes

  \code{cutoff.k.percent} chooses best k * 100\% of attributes

  \code{cutoff.biggest.diff} chooses a subset of attributes which are significantly better than other.
}
\value{
  A character vector containing selected attributes.
}
\author{ Piotr Romanski }
\examples{
  data(iris)

  weights <- information.gain(Species~., iris)
  print(weights)

  subset <- cutoff.k(weights, 1)
  f <- as.simple.formula(subset, "Species")
  print(f)

  subset <- cutoff.k.percent(weights, 0.75)
  f <- as.simple.formula(subset, "Species")
  print(f)

  subset <- cutoff.biggest.diff(weights)
  f <- as.simple.formula(subset, "Species")
  print(f)
  
}
