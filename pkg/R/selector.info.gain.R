### INFORMATION GAIN BASED ALGORITHMS
# classification and regression
# continous and discrete data

information.gain <- function(formula, data) {
	information.gain.body(formula, data, type = "infogain")
}

information.gain.ratio <- function(formula, data) {
	information.gain.body(formula, data, type = "infogainratio")	
}

symmetrical.uncertainty <- function(formula, data) {
	information.gain.body(formula, data, type = "symuncert")	
}

information.gain.body <- function(formula, data, type = c("infogain", "infogainratio", "symuncert")) {
	type = match.arg(type)
	new_data = get.data.frame.from.formula(formula, data)
	new_data = discretize.all(formula, new_data)
	
	attr_entropies = sapply(new_data, entropy)
	class_entropy = attr_entropies[1]
	attr_entropies = attr_entropies[-1]
	joint_entropies = sapply(new_data[-1], function(t) {
			joint.entropy(new_data[[1]], t)
		})
	results = class_entropy + attr_entropies - joint_entropies

	if(type == "infogainratio") {
		results = results / attr_entropies
	} else if(type == "symuncert") {
		results = 2 * results / (attr_entropies	+ class_entropy)
	}

	attr_names = dimnames(new_data)[[2]][-1]
	return(data.frame(attr_importance = results, row.names = attr_names))
}
