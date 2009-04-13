\name{relief}
\alias{relief}
\title{ RReliefF filter }
\description{
	The algorithm finds weights of continous and discrete attributes basing on a distance between instances.
}
\usage{
relief(formula, data, neighbours.count = 5, sample.size = 10)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
  \item{neighbours.count}{ number of neighbours to find for every sampled instance }
  \item{sample.size}{ number of instances to sample }
}
\details{
	The algorithm samples instances and finds their nearest hits and misses. Considering that result, it evaluates weights of attributes.
}
\references{
	\enumerate{
		\item{Igor Kononenko: Estimating Attributes: Analysis and Extensions of RELIEF. In: European Conference on Machine Learning, 171-182, 1994.}
		\item{Marko Robnik-Sikonja, Igor Kononenko: An adaptation of Relief for attribute estimation in regression. In: Fourteenth International Conference on Machine Learning, 296-304, 1997.}
	}
}
\value{
a data.frame containing ranks for attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{

}
