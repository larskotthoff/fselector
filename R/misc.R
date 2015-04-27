as.simple.formula <- function(attributes, class) {
	return(as.formula(paste(class, paste(attributes, sep = "", collapse = " + "), sep = " ~ ")))
}

get.data.frame.from.formula <- function(formula, data) {
	d = model.frame(formula, data, na.action = NULL)
	
  toCoerce <- which( sapply(d, class) %in% c("logical", "character") )
  
  if( length(toCoerce) > 0 ){
    for(i in toCoerce ) {
  		#if(is.factor(d[[i]]) || is.logical(d[[i]]) || is.character(d[[i]]))
  	  #if( is.logical(d[[i]]) || is.character(d[[i]]))
  			d[[i]] = factor(d[[i]])
  	}
  }
	return(d)
}

entropyHelper <- function(x) {
    return(entropy(table(x, useNA="always")))
}



# sparseMatrix support
# 27.04.2015
# Marcin Kosinski - m.p.kosinski@@gmail.com

get.sparseMatrix.from.formula <- function(formula, data){
  as.character(formula)[2] 
  data[, ]
}