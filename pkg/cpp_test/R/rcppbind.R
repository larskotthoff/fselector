rcppbind.path <- function()
{
  # show the directory for include header files
  path <- .find.package("rcppbind")
  paste(path, "/include", sep="")
}

rcppbind.demo <- function()
{
  prompt="Enter demo# to run [other key to exit]: "
  path  <- .find.package("rcppbind", verbose = F)
  pdemo <- file.path(path, "demo")
  psrc  <- file.path(path, "src")

  fdemo <- list.files(pdemo)
  while(TRUE) {
    for(i in seq(1,length(fdemo))) {
      cat(i, ': ', fdemo[i], '\n')
    }
    suppressWarnings(demoNum <- as.integer(readline(prompt=prompt)))

    if(is.na(demoNum)) {
      cat("Didn't get a number, exiting.\n")
        break
    } else {
      if(demoNum <= 0 || demoNum > length(fdemo)) {
        cat('Number out of range, try again...\n')
        next
      }

      fname <- file.path(pdemo, fdemo[demoNum])
      cname <- strsplit(fdemo[demoNum],"\\.")[[1]][1]
      cname <- paste(file.path(psrc, cname), ".cpp", sep="")

      # 1. show the "demoName".cpp source code
      cat("\n---- R source code ------\n\n")
      writeLines( paste(" ", readLines(fname)) )

      # 2. show the "demoName".R code and the result
      cat("\n---- C++ source code ----\n\n")
      writeLines( paste(" ", readLines(cname)) )

      # 3. source the demo file
      cat("\n---- Output results  ----\n\n")
      print(source(fname, echo=FALSE)$value)
      cat("\n\n")
    }
  }
}
