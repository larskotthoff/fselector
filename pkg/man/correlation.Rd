\name{correlation}
\alias{linear.correlation}
\alias{rank.correlation}
\title{ Correlation filter}
\description{
	The algorithm finds weights of continous attributes basing on their correlation with continous class attribute.
}
\usage{
linear.correlation(formula, data)
rank.correlation(formula, data)
}
\arguments{
  \item{formula}{ a symbolic description of a model }
  \item{data}{ data to process }
}
\details{
	\code{linear.correlation} uses Pearson's correlation
	
	\code{rank.correlation} uses Spearman's correlation
	
	Rows with \code{NA} values are not taken into consideration.
}
\value{
a data.frame containing ranks for attributes in the first column and their names as row names
}
\author{ Piotr Romanski }
\examples{

}
