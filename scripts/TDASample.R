## @knitr tdasample

TDASample <- function(inString, N, n, toFile = FALSE) {
    if (is.factor(inString)) inString <- as.character(inString)    
    if (nchar(inString) <= 3) stop("inString must be > 3 characters")
    string1 <- "jnt3g127rbfeqixkos 586d90pyal4chzmvwu"
    string2 <- "2dyn0uxq ovalrpksieb3fhjw584cm9t7z16g"
    instring <- chartr(string1, string2, tolower(inString))
    t1 <- sd(c(suppressWarnings(sapply(strsplit(instring, ""),
                                       as.numeric))), na.rm = TRUE)
    t2 <- c(sapply(strsplit(instring, " "), nchar))
    t3 <- c(na.omit(sapply(strsplit(instring, ""), match, letters)))
    seed <- floor(sum(t1, sd(t2), mean(t2), prod(fivenum(t3)),
                      mean(t3), sd(t3), na.rm=TRUE))
    
    set.seed(seed)
    temp0 <- sample(N, n)
    temp1 <- list(SeedUsed = seed, FinalSample = temp0,
                  FinalSample_sorted = sort(temp0))
    
    rm(.Random.seed, envir=globalenv())
    
    if (isTRUE(toFile)) {
    cat(
        sprintf("\n\n            The sample was drawn on: %s.", Sys.time()), "\n",
        sprintf("                The seed input was: '%s'", inString), "\n",
        sprintf("The total number of households was: %d.", N), "\n",
        sprintf(" The desired number of samples was: %d.", n), "\n\n\n", 
        file = paste("Sample from", Sys.Date(), ".txt", collapse=""), append = TRUE)
    capture.output(temp1, file = paste("Sample from", Sys.Date(), ".txt", collapse=""),
                   append = TRUE)
    }
    message(
        sprintf("\n\n            The sample was drawn on: %s.", Sys.time()), "\n",
        sprintf("                The seed input was: '%s'", inString), "\n",
        sprintf("The total number of households was: %d.", N), "\n",
        sprintf(" The desired number of samples was: %d.", n), "\n\n\n")
    temp1
}