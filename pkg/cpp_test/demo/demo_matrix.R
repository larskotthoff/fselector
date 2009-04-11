library.dynam("demo_matrix", package="rcppbind")
demo_matrix <- function(a) .Call("demo_matrix", a)
d <- matrix(1:6,3,2)
demo_matrix(d)
