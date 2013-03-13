\name{exhaustive.search}
\alias{exhaustive.search}
\title{ Exhaustive search }
\description{
  The algorithm for searching atrribute subset space.
}
\usage{
exhaustive.search(attributes, eval.fun)
}
\arguments{
  \item{attributes}{ a character vector of all attributes to search in }
  \item{eval.fun}{ a function taking as first parameter a character vector of all attributes and returning a numeric indicating how important a given subset is }
}
\details{
  The algorithm searches the whole attribute subset space in breadth-first order.
}
\value{
  A character vector of selected attributes.
}
\author{ Piotr Romanski }
\seealso{ \code{\link{forward.search}}, \code{\link{backward.search}}, \code{\link{best.first.search}}, \code{\link{hill.climbing.search}} }
\examples{
  library(rpart)
  data(iris)
  
  evaluator <- function(subset) {
    #k-fold cross validation
    k <- 5
    splits <- runif(nrow(iris))
    results = sapply(1:k, function(i) {
      test.idx <- (splits >= (i - 1) / k) & (splits < i / k)
      train.idx <- !test.idx
      test <- iris[test.idx, , drop=FALSE]
      train <- iris[train.idx, , drop=FALSE]
      tree <- rpart(as.simple.formula(subset, "Species"), train)
      error.rate = sum(test$Species != predict(tree, test, type="c")) / nrow(test)
      return(1 - error.rate)
    })
    print(subset)
    print(mean(results))
    return(mean(results))
  }
  
  subset <- exhaustive.search(names(iris)[-5], evaluator)
  f <- as.simple.formula(subset, "Species")
  print(f)

  
}
