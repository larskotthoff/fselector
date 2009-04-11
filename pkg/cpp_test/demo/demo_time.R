library.dynam("demo_time", package="rcppbind")
demo_time <- function(a) .Call("demo_time", a)
a <- seq(c(ISOdate(2000,3,20)), by = "day", length.out = 5)
demo_time(a)
