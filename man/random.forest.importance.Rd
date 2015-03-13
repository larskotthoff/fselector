\name{random.forest.importance}
\alias{random.forest.importance}
\title{ RandomForest filter }
\description{
  The algorithm finds weights of attributes using RandomForest algorithm.
}
\usage{
random.forest.importance(formula, data, importance.type = 1)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
  \item{importance.type}{ either 1 or 2, specifying the type of importance measure (1=mean decrease in accuracy, 2=mean decrease in node impurity) }
}
\details{
  This is a wrapper for \code{\link[randomForest]{importance}.}
}
\value{
a data.frame containing the worth of attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{
  library(mlbench)
  data(HouseVotes84)
  
  weights <- random.forest.importance(Class~., HouseVotes84, importance.type = 1)
  print(weights)
  subset <- cutoff.k(weights, 5)
  f <- as.simple.formula(subset, "Class")
  print(f)
}
