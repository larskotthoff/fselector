\name{random.forest.importance}
\alias{random.forest.importance}
\title{ RandomForest filter }
\description{
  The algorithm finds weights of attributes using RandomForest algorithm.
}
\usage{
random.forest.importance(formula, data, importance_type = 1)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
  \item{importance_type}{ either 1 or 2, specifying the type of importance measure (1=mean decrease in accuracy, 2=mean decrease in node impurity) }
}
\details{
  This is a wrapper for \code{\link[randomForest]{importance}}
}
\value{
a data.frame containing ranks for attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{

}
