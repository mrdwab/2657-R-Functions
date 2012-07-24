## @knitr multifreqtable
multi.freq.table = function(data, sep="", dropzero=FALSE, clean=TRUE) {
  # Takes boolean multiple-response data and tabulates it according
  #   to the possible combinations of each variable.
  #
  # === EXAMPLES ===
  #     set.seed(1)
  #     dat = data.frame(A = sample(c(0, 1), 20, replace=TRUE), 
  #                      B = sample(c(0, 1), 20, replace=TRUE), 
  #                      C = sample(c(0, 1), 20, replace=TRUE),
  #                      D = sample(c(0, 1), 20, replace=TRUE),
  #                      E = sample(c(0, 1), 20, replace=TRUE))
  #   multi.freq.table(dat)
  #   multi.freq.table(dat[1:3], sep="-", dropzero=TRUE)
  #
  # See: http://stackoverflow.com/q/11348391/1270695
  
  counts = data.frame(table(data))
  N = ncol(counts)
  counts$Combn = apply(counts[-N] == 1, 1, 
                       function(x) paste(names(counts[-N])[x],
                                         collapse=sep))
  if (isTRUE(dropzero)) {
    counts = counts[counts$Freq != 0, ]
  } else if (!isTRUE(dropzero)) {
    counts = counts
  }
  if (isTRUE(clean)) {
    counts = data.frame(Combn = counts$Combn, Freq = counts$Freq)
  } 
  counts
}