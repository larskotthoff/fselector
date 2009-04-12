# H(C)
entropy <- function(vec) {
	probs = table(vec)
	data_length = sum(probs)
	probs = probs / data_length
	return(sum(sapply(probs, function(t) {
			p = as.numeric(t)
			return(- p * log2(p))
		})))
}

# H(A,B)
joint.entropy <- function(a, b) {
	data_length = length(a)
	probs = as.vector(table(a, b))
	probs = probs / sum(probs)
	return(sum(sapply(probs, function(t) {
			p = as.numeric(t)
			return(
				if(p == 0) {
					0
				} else {
					- p * log2(p)
				}
			)
		})))

}