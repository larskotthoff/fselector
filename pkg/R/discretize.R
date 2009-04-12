discretize.all <- function(formula, data) {
	new_data = get.data.frame.from.formula(formula, data)
	
	dest_column_name = dimnames(new_data)[[2]][1]
	if(!is.factor(new_data[[1]])) {
		# TODO: why 5?
		new_data[[dest_column_name]] = equal.frequency.binning.discretization(new_data[[dest_column_name]], 5)
	}
	
	new_data = supervised.discretization(formula, data = new_data)

	# reorder attributes
	new_data = get.data.frame.from.formula(formula, new_data)
	return(new_data)
}

# unupervised
# TODO: fix
equal.frequency.binning.discretization <- function(data, bins) {
	bins = as.integer(bins)
	if (!is.numeric(data)) 
		stop("Data must be numeric")
	if(bins < 1)
		stop("Number of bins too small")
	
	complete = complete.cases(data)
	ord = order(data)
	len = length(data[complete])
	blen = len / bins
	new_data = data

	p1 = p2 = 0

	for(i in 1:bins) {
		p1 = p2 + 1
		p2 = round(i * blen)
		new_data[ord[p1:min(p2, len)]] = i
	}

	return(factor(new_data))
}

# unupervised
equal.width.binning.discretization <- function(data, bins) {
	if (!is.numeric(data)) 
		stop("Data must be numeric")
	if(bins < 1)
		stop("Number of bins too small")
	return(cut(data, bins))
}

#MDL - Fayyad, Irani
# TODO: dont use weka
# FIXME: class attribute NA - error
supervised.discretization <- function(formula, data) {
	return(Discretize(formula, data = data, na.action = na.pass))
}
