### INFORMATION GAIN BASED ALGORITHMS
## classification and regression
## continous and discrete data
##
#' @name entropy.based
#' @title Entropy-based filters 
#' @description
#'   The algorithms find weights of discrete attributes basing on their correlation with continous class attribute.
#' 
#' @param formula a symbolic description of a model 
#' 
#' @param data data to process - a \code{data.frame} or a \code{dgCMatrix} object
#' 
#' @param equalBins For how many equal bins to discretize an explanatory variable when it's not of type
#' \code{factor, character} or \code{logical}, when evaluating an entropy.
#'   
#' 
#' @details
#'   \code{information.gain} is \deqn{H(Class) + H(Attribute) - H(Class, Attribute)}{H(Class) + H(Attribute) - H(Class, Attribute)}
#'   
#'   \code{gain.ratio} is \deqn{\frac{H(Class) + H(Attribute) - H(Class, Attribute)}{H(Attribute)}}{(H(Class) + H(Attribute) - H(Class, Attribute)) / H(Attribute)}
#'   
#'   \code{symmetrical.uncertainty} is \deqn{2\frac{H(Class) + H(Attribute) - H(Class, Attribute)}{H(Attribute) + H(Class)}}{2 * (H(Class) + H(Attribute) - H(Class, Attribute)) / (H(Attribute) + H(Class))}
#' 
#' @return A data.frame containing the worth of attributes in the first column and their names as row names
#'
#' @author
#' Piotr Romanski,  
#' 
#' Marcin Kosinski \link{sparseMatrix} format, \email{m.p.kosinski@@gmail.com}
#' @examples
#' 
#'   # regular data.frame example
#'   data(iris)
#'   
#'   weights <- information.gain(Species~., iris)
#'   print(weights)
#'   subset <- cutoff.k(weights, 2)
#'   f <- as.simple.formula(subset, "Species")
#'   print(f)
#'   
#'   weights <- gain.ratio(Species~., iris)
#'   print(weights)
#'   subset <- cutoff.k(weights, 2)
#'   f <- as.simple.formula(subset, "Species")
#'   print(f)
#'   
#'   weights <- symmetrical.uncertainty(Species~., iris)
#'   print(weights)
#'   subset <- cutoff.biggest.diff(weights)
#'   f <- as.simple.formula(subset, "Species")
#'   print(f)
#'   
#'   # sparseMatrix example
#'
#' @aliases  information.gain, gain.ratio, symmetrical.uncertainty
#' @family FSelector
#' @rdname information.gain
#' @export
information.gain <- function(formula, data, equalBins = 5) {
  if( class( data ) == "dgCMatrix" ){
    information.gain.body.sparse(formula, data, type = "infogain") # works faster when you are using sparseMatrix'es from Matrix package
  }else{
	  information.gain.body(formula, data, type = "infogain")
  }
}

#' @family FSelector
#' @rdname information.gain
#' @export
gain.ratio <- function(formula, data, equalBins = 5) {
  if( class( data ) == "dgCMatrix" ){
    information.gain.body.sparse(formula, data, type = "gainratio") # works faster when you are using sparseMatrix'es from Matrix package
  }else{
	  information.gain.body(formula, data, type = "gainratio")	
  }
}

#' @family FSelector
#' @rdname information.gain
#' @export
symmetrical.uncertainty <- function(formula, data, equalBins = 5) {
  if( class( data ) == "dgCMatrix" ){
    information.gain.body.sparse(formula, data, type = "symuncert") # works faster when you are using sparseMatrix'es from Matrix package
  }else{
	  information.gain.body(formula, data, type = "symuncert")	
  }
}

information.gain.body <- function(formula, data, type = c("infogain", "gainratio", "symuncert"), equalBins) {
	assert_that( is.data.frame( data ) )
  #type = match.arg(type)
	#new_data = get.data.frame.from.formula(formula, data)
	new_data = discretize.all(formula, data, equalBins) #new_data)
	
	attr_entropies = sapply(new_data, entropyHelper)
	class_entropy = attr_entropies[1]
	attr_entropies = attr_entropies[-1]
	joint_entropies = sapply(new_data[-1], function(t) {
			entropyHelper(data.frame(cbind(new_data[[1]], t)))
		})
	results = class_entropy + attr_entropies - joint_entropies

	if(type == "gainratio") {
		results = results / attr_entropies
	} else if(type == "symuncert") {
		results = 2 * results / (attr_entropies	+ class_entropy)
	}

	attr_names = dimnames(new_data)[[2]][-1]
	return(data.frame(attr_importance = results, row.names = attr_names))
}




information.gain.body.sparse <- function(formula, data, type = c("infogain", "gainratio", "symuncert")) {
  
}



  formula = Species~.
  data = iris
