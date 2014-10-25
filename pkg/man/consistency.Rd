\name{consistency}
\alias{consistency}
\title{ Consistency-based filter }
\description{
  The algorithm finds attribute subset using consistency measure for continous and discrete data.  
}
\usage{
consistency(formula, data)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
}
\details{
  The alorithm makes use of \code{\link{best.first.search}} for searching the attribute subset space.
}
\seealso{ \code{\link{best.first.search}} }
\value{
a character vector containing chosen attributes
}
\author{ Piotr Romanski }
\examples{
\dontrun{
  library(mlbench)
  data(HouseVotes84)
  
  subset <- consistency(Class~., HouseVotes84)
  f <- as.simple.formula(subset, "Class")
  print(f)
}
}
