as.simple.formula <- function(attributes, class) {
	return(as.formula(paste(class, paste(attributes, sep = "", collapse = " + "), sep = " ~ ")))
}

get.data.frame.from.formula <- function(formula, data) {
	return(model.frame(formula, data, na.action = NULL))
}