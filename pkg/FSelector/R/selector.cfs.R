### CFS
# classification and regression
# continous and discrete data
cfs <- function(formula, data) {
	prepare_cor_matix <- function(formula, or_data) {
		cfs_cor <- function(a, b) {
			result = 0
			if(!is.factor(a) && !is.factor(b)) { # both continous
				complete = complete.cases(a) & complete.cases(b)
				if(!any(complete))
					return(0)
				vec1 = a[complete]
				vec2 = b[complete]
				if(sd(vec1) == 0 || sd(vec2) == 0)
					return(0)
				result = cor(vec1, vec2)
			} else if(is.factor(a) && is.factor(b)) { # both discrete
				tab = table(a, b)
				alevels = rownames(tab)
				blevels = colnames(tab)
				
				result = sum(sapply(alevels, function(avalue) {
						avec = as.numeric(a == avalue)
						complete_a = complete.cases(a)
						return(sum(sapply(blevels, function(bvalue) {
								bvec = as.numeric(b == bvalue)
								complete_b = complete.cases(b)
								complete = complete_a & complete_b
								avec_complete_data = avec[complete]
								bvec_complete_data = bvec[complete]
								if(sd(avec_complete_data, na.rm=TRUE) == 0 || sd(bvec_complete_data, na.rm=TRUE) == 0)
									return(0)
								return(tab[avalue, bvalue] / length(a) * cor(avec_complete_data, bvec_complete_data))
							})))
					}))
			} else { # continous and discrete
				cont = NULL;
				disc = NULL;
				if(is.factor(a)) {
					cont = b
					disc = a
				} else {
					cont = a
					disc = b
				}
				
				cont_complete = complete.cases(cont)
				disc_table = table(disc)
				disc_levels = names(disc_table)
				
				if(length(disc_levels) == 0) {
					result = 0
				} else {
					result = sum(sapply(disc_levels, function(lev) {
							disc_vec = as.numeric(disc == lev)
							disc_vec_complete = complete.cases(disc_vec)
							complete = cont_complete & disc_vec_complete
							disc_vec_complete_data = disc_vec[complete]
							cont_complete_data = cont[complete]
							if(sd(cont_complete_data) == 0)
								return(0)
							return(disc_table[lev] / length(disc) * cor(disc_vec_complete_data, cont_complete_data))
						}))
				}
			}
			return(result)
		}
	
		classification = is.factor(or_data[[1]])
		attr_count = dim(or_data)[2]
		attr_names = colnames(or_data)
		result = matrix(rep(0, attr_count ^ 2), nrow = attr_count, ncol = attr_count,
			dimnames = list(attr_names, attr_names))
		
		if(classification) { #discrete class
			#library(RWeka)
			new_data = supervised.discretization(formula, data = or_data)
			new_data = get.data.frame.from.formula(formula, or_data)
			
			entropies = sapply(new_data, entropy)
			
			for(i in 1:(attr_count - 1)) {
				xname = attr_names[i]
				for(j in (i+1):attr_count) {
					yname = attr_names[j]
					tmp_res = 2.0 * (entropies[xname] + entropies[yname] - joint.entropy(new_data[[xname]], new_data[[yname]])) / (entropies[xname] + entropies[yname])
					result[xname, yname] = tmp_res
					result[yname, xname] = tmp_res
				}
			}
		} else { #continous class
			for(i in 1:(attr_count - 1)) {
				xname = attr_names[i]
				for(j in (i+1):attr_count) {
					yname = attr_names[j]
					tmp_res = cfs_cor(or_data[[xname]], or_data[[yname]])
					result[xname, yname] = tmp_res
					result[yname, xname] = tmp_res
				}
			}
		}
		return(result)
	}

	evaluator <- function(cors, attrs) {
		ff_sum = 0
		ff_count = 0
		fc_sum = 0
		attr_count = length(attrs)
		
		if(attr_count <= 0)
			stop("Attributes not specified")
		
		for(i in 1:attr_count) {
			attr1 = attrs[i]
			
			# feature-class correlation
			fc_sum = fc_sum + cors[attr1, 1]
			
			# feature-feature correlation
			if(i == attr_count) {
				next()
			}
			for(j in (i+1):attr_count) {
				attr2 = attrs[j]
				ff_count = ff_count + 1
				ff_sum = ff_sum + cors[attr1, attr2]
			}
		}

		ff_cor = ff_sum / ff_count
		fc_cor = fc_sum / attr_count
		
		if(attr_count == 1)
			return(fc_cor)
		else
			return(attr_count * fc_cor / sqrt(attr_count + attr_count * (attr_count - 1) * ff_cor))
	}
	
	new_data = get.data.frame.from.formula(formula, data)
	
	# prepare correlation matrix
	correlations = prepare_cor_matix(formula, new_data)
	result = best.first.search(names(new_data)[-1], function(...) {
		evaluator(correlations, ...)
		})
		
	return(result)
}
