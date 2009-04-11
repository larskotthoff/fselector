library.dynam("demo_date", package="rcppbind")
demo_date <- function(a) .Call("demo_date", a)
a <- 0; class(a) <- "Date"
a[1] <- Sys.Date();
a[2] <- Sys.Date() + 1;
a[3] <- Sys.Date() + 2;
demo_date(a)
