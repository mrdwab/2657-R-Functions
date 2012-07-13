concat.split = function(data, split.col, mode=NULL, 
                        sep=",", drop.col=FALSE) {
  # Takes a column with multiple values, splits the values into 
  #   separate columns, and returns a new data.frame.
  # 'data' is the source data.frame; 'split.col' is the variable that 
  #   needs to be split; 'mode' can be either 'binary' or 'value' 
  #   (where 'binary' is default and it recodes values to 1 or NA);
  #   'sep' is the character separating each value (defaults to ','); 
  #   and 'drop.col' is logical (whether to remove the original 
  #   variable from the output or not.
  #
  # === EXAMPLES ===
  #
  #       dat = data.frame(V1 = c("1, 2, 4", "3, 4, 5", 
  #                               "1, 2, 5", "4", "1, 2, 3, 5"),
  #                        V2 = c("1;2;3;4", "1", "2;5", 
  #                               "3;2", "2;3;4"))
  #       dat2 = data.frame(V1 = c("Fred, John, Sue", "Jerry, Jill", 
  #                                "Sally, Ryan", "Susan, Amos, Ben"))
  #
  #       concat.split(dat, 1) 
  #       concat.split(dat, 2, sep=";")
  #       concat.split(dat, "V2", sep=";", mode="value")
  #       concat.split(dat, "V1", mode="binary")
  #       concat.split(dat2, 1)
  #       concat.split(dat2, "V1", drop.col=TRUE)
  #
  # See: http://stackoverflow.com/q/10100887/1270695

  if (is.numeric(split.col)) split.col = split.col
  else split.col = which(colnames(data) %in% split.col)
  
  a = as.character(data[ , split.col])
  b = strsplit(a, sep)
  
  if (suppressWarnings(is.na(try(max(as.numeric(unlist(b))))))) {
    what = "string"
    ncol = max(unlist(lapply(b, function(i) length(i))))
  } else if (!is.na(try(max(as.numeric(unlist(b)))))) {
    what = "numeric"
    ncol = max(as.numeric(unlist(b)))
  }
  
  m = matrix(nrow = nrow(data), ncol = ncol)
  v = vector("list", nrow(data))
  
  if (identical(what, "string")) {
    temp = as.data.frame(t(sapply(b, '[', 1:ncol)))
    names(temp) = paste(names(data[split.col]), "_", 1:ncol, sep="")
    temp = apply(temp, 2, function(x) gsub("^\\s+|\\s+$", "", x))
    temp1 = cbind(data, temp)
  } else if (identical(what, "numeric")) {
    for (i in 1:nrow(data)) {
      v[[i]] = as.numeric(strsplit(a, sep)[[i]])
    }
    
    temp = v
    
    for (i in 1:nrow(data)) {
      m[i, temp[[i]]] = temp[[i]]
    }
    
    m = data.frame(m)
    names(m) = paste(names(data[split.col]), "_", 1:ncol, sep="")
    
    if (is.null(mode) || identical(mode, "binary")) {
      temp1 = cbind(data, replace(m, m != "NA", 1))
    } else if (identical(mode, "value")) {
      temp1 = cbind(data, m)
    }
  } 
  
  if (isTRUE(drop.col)) temp1[-split.col]
  else temp1
  
}
