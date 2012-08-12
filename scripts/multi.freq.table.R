## @knitr multifreqtable
multi.freq.table = function(data, sep="", dropzero=TRUE,
                            clean=TRUE, basic=FALSE, NAto0=TRUE) {
  # Takes boolean multiple-response data and tabulates it according
  #   to the possible combinations of each variable.
  #
  # === EXAMPLES ===
  #
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
  #      http://stackoverflow.com/q/11622660/1270695
  
  if(!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  
  CASES = nrow(data)
  RESPS = sum(data, na.rm=TRUE)
  
  if(isTRUE(NAto0)) {
    data[is.na(data)] = 0
    VALID = CASES
    VRESP = RESPS
  } else if(!isTRUE(NAto0)) {
    data = data[complete.cases(data), ]
    VALID = CASES - (CASES - nrow(data))
    VRESP = sum(data)
  }
  
  if(isTRUE(basic)) {
    counts = data.frame(Freq = colSums(data),
                        Pct.of.Resp = (colSums(data)/sum(data))*100,
                        Pct.of.Cases = (colSums(data)/nrow(data))*100)
  } else if (!isTRUE(basic)) {
    counts = data.frame(table(data))
    Z = counts[, c(intersect(names(data), names(counts)))]
    Z = rowSums(sapply(Z, as.numeric)-1)
    if(Z[1] == 0) { Z[1] = 1 }
    N = ncol(counts)
    counts$Combn = apply(counts[-N] == 1, 1, 
                         function(x) paste(names(counts[-N])[x],
                                           collapse=sep))
    counts$Pct.of.Resp = (Z*counts$Freq/sum(data))*100
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
  message("Total cases:     ", CASES, "\n",
  "Valid cases:     ", VALID, "\n",
  "Total responses: ", RESPS, "\n",
  "Valid responses: ", VRESP)
  counts
}
