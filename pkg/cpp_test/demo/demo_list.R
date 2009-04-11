library.dynam("demo_list", package="rcppbind")
demo_list <- function(a) .Call("demo_list", a)
a <- list(1:3, letters)
demo_list(a)
