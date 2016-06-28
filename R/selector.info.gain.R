### INFORMATION GAIN BASED ALGORITHMS
# classification and regression
# continous and discrete data

information.gain <- function(formula, data, unit = "log") {
    information.gain.body(formula, data, type = "infogain", unit)
}

gain.ratio <- function(formula, data, unit = "log") {
    information.gain.body(formula, data, type = "gainratio", unit)
}

symmetrical.uncertainty <- function(formula, data, unit = "log") {
    information.gain.body(formula, data, type = "symuncert", unit)
}

information.gain.body <- function(formula, data, type = c("infogain", "gainratio", "symuncert"), unit) {
    type = match.arg(type)
    new_data = get.data.frame.from.formula(formula, data)
    new_data = discretize.all(formula, new_data)
    
    attr_entropies = sapply(new_data, entropyHelper, unit)
    class_entropy = attr_entropies[1]
    attr_entropies = attr_entropies[-1]
    joint_entropies = sapply(new_data[-1], function(t) {
            entropyHelper(data.frame(cbind(new_data[[1]], t)), unit)
        })
    results = class_entropy + attr_entropies - joint_entropies

    if(type == "gainratio") {
        results = ifelse(attr_entropies == 0, 0, results / attr_entropies)
    } else if(type == "symuncert") {
        results = 2 * results / (attr_entropies + class_entropy)
    }

    attr_names = dimnames(new_data)[[2]][-1]
    return(data.frame(attr_importance = results, row.names = attr_names))
}
