### RANDOM FOREST
# classification and regression
# continous and discrete data
# NA disallowed
random.forest.importance <- function(formula, data, importance_type = 1) {
	#library(randomForest)
	#set.seed(4543)
	new_data = get.data.frame.from.formula(formula, data)
	forest = randomForest(formula, data,
		ntree = 1000, keep.forest = FALSE, importance = TRUE)
		
	res = as.data.frame(importance(forest, importance_type))
	colnames(res)[1] = "attr_importance"
	return(res)
}
