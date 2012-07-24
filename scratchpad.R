multi.freq.table = function(data, sep="", dropzero=FALSE,
                            clean=TRUE, basic=FALSE) {
  # Takes boolean multiple-response data and tabulates it according
  #   to the possible combinations of each variable.
  #
  # See: http://stackoverflow.com/q/11348391/1270695
  
  if(isTRUE(basic)) {
    counts = data.frame(Freq = colSums(data),
                        Pct.of.Resp = (colSums(data)/sum(data))*100,
                        Pct.of.Cases = (colSums(data)/nrow(data))*100)
  } else if (!isTRUE(basic)) {
    counts = data.frame(table(data))
    N = ncol(counts)
    counts$Combn = apply(counts[-N] == 1, 1, 
                         function(x) paste(names(counts[-N])[x],
                                           collapse=sep))
    counts$Pct.of.Resp = (counts$Freq/sum(data))*100
    counts$Pct.of.Cases = (counts$Freq/nrow(data))*100
    if (isTRUE(dropzero)) {
      counts = counts[counts$Freq != 0, ]
    } else if (!isTRUE(dropzero)) {
      counts = counts
    }
    if (isTRUE(clean)) {
      counts = data.frame(Combn = counts$Combn, Freq = counts$Freq, 
                          Pct.of.Resp = counts$Pct.of.Resp, 
                          Pct.of.Cases = counts$Pct.of.Cases)
    }
  }
  counts
}