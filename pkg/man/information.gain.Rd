\name{entropy.based}
\alias{information.gain}
\alias{gain.ratio}
\alias{symmetrical.uncertainty}
\title{ Entropy-based filters }
\description{
  The algorithms find weights of discrete attributes basing on their correlation with continous class attribute.
}
\usage{
information.gain(formula, data)
gain.ratio(formula, data)
symmetrical.uncertainty(formula, data)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
}
\details{
  \code{information.gain} is \deqn{H(Class) + H(Attribute) - H(Class, Attribute)}{H(Class) + H(Attribute) - H(Class, Attribute)}.
  
  \code{gain.ratio} is \deqn{\frac{H(Class) + H(Attribute) - H(Class, Attribute)}{H(Attribute)}}{(H(Class) + H(Attribute) - H(Class, Attribute)) / H(Attribute)}

  \code{symmetrical.uncertainty} is \deqn{2\frac{H(Class) + H(Attribute) - H(Class, Attribute)}{H(Attribute) + H(Class)}}{2 * (H(Class) + H(Attribute) - H(Class, Attribute)) / (H(Attribute) + H(Class))}
}
\value{
a data.frame containing the worth of attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{
  data(iris)

  weights <- information.gain(Species~., iris)
  print(weights)
  subset <- cutoff.k(weights, 2)
  f <- as.simple.formula(subset, "Species")
  print(f)

  weights <- gain.ratio(Species~., iris)
  print(weights)
  subset <- cutoff.k(weights, 2)
  f <- as.simple.formula(subset, "Species")
  print(f)

  weights <- symmetrical.uncertainty(Species~., iris)
  print(weights)
  subset <- cutoff.biggest.diff(weights)
  f <- as.simple.formula(subset, "Species")
  print(f)

}
