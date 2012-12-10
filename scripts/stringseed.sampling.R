## @knitr stringseed

stringseed.sampling <- function(seedbase, N, n, write.output = FALSE) {
  require(digest)
  hexval = paste0("0x", sapply(seedbase, digest, "crc32"))
  seeds = type.convert(hexval) %% .Machine$integer.max
  seedbase = as.character(seedbase)
  
  temp <- data.frame(seedbase, N, n, seeds)
  if (length(seedbase) == 1) {
    set.seed(temp$seeds)
    sample.list <- sample(temp$N, temp$n)
  } else {
    sample.list <- setNames(
      apply(temp[-1], 1, 
            function(x) {set.seed(x[3]); sample(x[1], x[2])} ), 
      temp[, 1])
  }
  
  rm(.Random.seed, envir=globalenv()) # This is important!
  
  temp <- list(input = data.frame(seedbase = seedbase,
                                  populations = N,
                                  samplesizes = n,
                                  seeds = seeds), 
               samples = sample.list)
  if(isTRUE(write.output)) {
    write.csv(temp[[1]], 
              file=paste("Sample frame generated on", 
                         Sys.Date(), ".csv", collapse=""))
    capture.output(temp[[2]], 
                   file=paste("Samples generated on", 
                              Sys.Date(), ".txt", collapse=""))
  }
  temp
}