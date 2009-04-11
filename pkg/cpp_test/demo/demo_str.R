library.dynam("demo_str", package="rcppbind")
demo_str <- function(a) .Call("demo_str", a)
a <- c("abc", "defg")
demo_str(a)
