\name{best.first.search}
\alias{best.first.search}
\title{ Best-first search }
\description{
  The algorithm for searching atrribute subset space.
}
\usage{
best.first.search(attributes, eval.fun, max.backtracks = 5)
}
\arguments{
  \item{attributes}{ a character vector of all attributes to search in }
  \item{eval.fun}{ a function taking as first parameter a character vector of all attributes and returning a numeric indicating how important a given subset is }
  \item{max.backtracks}{ an integer indicating a maximum allowed number of backtracks, default is 5 }
}
\details{
  The algorithm is similar to \code{\link{forward.search}} besides the fact that is chooses the best node from all already evaluated ones and evaluates it. The selection of the best node is repeated approximately \code{max.brackets} times in case no better node found.
}
\value{
  A character vector of selected attributes.
}
\author{ Piotr Romanski }
\seealso{ \code{\link{forward.search}}, \code{\link{backward.search}}, \code{\link{hill.climbing.search}}, \code{\link{exhaustive.search}} }
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
  
  subset <- best.first.search(names(iris)[-5], evaluator)
  f <- as.simple.formula(subset, "Species")
  print(f)

  
}
