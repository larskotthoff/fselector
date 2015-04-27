discretize.all <- function(formula, data, equalBins) {
	#new_data = get.data.frame.from.formula(formula, data)
  
	# discretize.all is used only in information.gain.R, selector.chisquared.R,
  # selector.consistency.R and selector.oneR.R where in all those functions
  # the get.data.frame.from.formula is evaluated before discretize.all so this
  # line is unnecessary
  
  
	#dest_column_name = dimnames(new_data)[[2]][1] - this isn't used anywhere :|
	if(!is.factor(new_data[[1]])) {
		# new_data[[1]] = equal.frequency.binning.discretization(new_data[[1]], 5) added new param
		new_data[[1]] = equal.frequency.binning.discretization(new_data[[1]], bins = equalBins)
	}
	
	new_data = supervised.discretization(formula, data = new_data)

	# reorder attributes
	new_data = get.data.frame.from.formula(formula, new_data)
	return(new_data)
}

# unupervised - it is very similar to `cut` function....
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
supervised.discretization <- function(formula, data) {
	data = get.data.frame.from.formula(formula, data) # is it really necessary here...
	complete = complete.cases(data[[1]])
	all.complete = all(complete)
	if(!all.complete) {
		new_data = data[complete, , drop=FALSE]
		result = Discretize(formula, data = new_data, na.action = na.pass)
		return(result)
	} else {
		return(Discretize(formula, data = data, na.action = na.pass))
	}
	
}
