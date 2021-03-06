



\part{The Functions}

# Where to Get the Functions

The most current source code for the functions described in this document follow. It is recommended that you *do not* copy-and-paste the functions from this document since there may be errors resulting from poorly parsed quotation marks and so on; instead, load the functions directly from the 2657 R Functions page at github.

To load the functions, you can directly source them from the 2657 R Functions page at github: [https://github.com/mrdwab/2657-R-Functions](https://github.com/mrdwab/2657-R-Functions)

You should be able to load the functions using the following (replace `-----------` with the function name^[The "snippets" in Part III of this document can all be loaded from a single script, `snippets.R`.]):


```r
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/-----------.R"))))
```


\cleardoublepage

# concat.split


```r
concat.split = function(data, split.col, sep = ",", structure = "compact",
                        mode = NULL, drop.col = FALSE, fixed = FALSE) {
    # Takes a column with multiple values, splits the values into 
    #   separate columns, and returns a new data.frame.
    # --data-- is the source data.frame; --split.col-- is the variable that 
    #   needs to be split; --structure-- the type of output that should be
    #   returned, either a -compact- or -expanded- form, or a -list-
    #   (defaults to -compact-).  --mode-- can be either -binary- or -value-
    #   (where -binary- is default and it recodes values to 1 or NA); --sep--
    #   is the character separating each value (defaults to -,-). --drop.col-- 
    #   is logical (whether to remove the original variable from the output).
    #
    # === EXAMPLES ===
    #
    #     dat = data.frame(
    #         V1 = c("1, 2, 4", "3, 4, 5",  "1, 2, 5", "4", "1, 2, 3, 5"),
    #         V2 = c("1;2;3;4", "1", "2;5", "3;2", "2;3;4"))
    #     dat2 = data.frame(
    #         V1 = c("Fred, John, Sue", "Jerry, Jill", 
    #                "Sally, Ryan", "Susan, Amos, Ben"))
    #     
    #     concat.split(dat, 1) 
    #     concat.split(dat, 1, structure="expanded")
    #     concat.split(dat, 1, structure="expanded", mode = "value")
    #     concat.split(dat, 2, sep=";")
    #     concat.split(dat, "V2", sep=";", mode="value")
    #     concat.split(dat2, 1)
    #     concat.split(dat2, "V1", drop.col=TRUE)
    #     concat.split(dat2, "V1", structure="expanded", drop.col=TRUE)
    #
    # See: http://stackoverflow.com/q/10100887/1270695
    # See also: http://stackoverflow.com/a/13912721/1270695
    
    # Check to see if split.col is specified by name or position
    if (is.numeric(split.col)) split.col = split.col
    else split.col = which(colnames(data) %in% split.col)
    
    # Split the data
    a = as.character(data[ , split.col])
    b = strsplit(a, sep, fixed = fixed)
    
    temp <- switch(
        structure, 
        compact = {
            t1 <- read.table(text = a, sep = sep, fill = TRUE,
                             row.names = NULL, header = FALSE,
                             blank.lines.skip = FALSE, 
                             strip.white = TRUE)
            names(t1) <- paste(names(data[split.col]), 
                               seq(ncol(t1)), sep="_")
            if (!is.null(mode)) 
                warning("
                        'mode' supplied but ignored. 
                        'mode' setting only applicable 
                        when structure='expanded'.")
            if (isTRUE(drop.col)) cbind(data[-split.col], t1)
            else cbind(data, t1)
        },
        list = {
            varname = paste(names(data[split.col]), "list", sep="_")
            if (suppressWarnings(is.na(try(max(as.numeric(unlist(b))))))) {
                data[varname] = list(
                    lapply(lapply(b, as.character),
                           function(x) gsub("^\\s+|\\s+$", "", x)))
            } else if (!is.na(try(max(as.numeric(unlist(b)))))) {
                data[varname] = list(lapply(b, as.numeric))
            }
            if (!is.null(mode)) 
                warning("
                        'mode' supplied but ignored. 
                        'mode' setting only applicable 
                        when structure='expanded'.")
            if (isTRUE(drop.col)) data[-split.col]
            else data
        },
        expanded = {
            if (suppressWarnings(is.na(try(max(as.numeric(unlist(b))))))) {
                what = "string"
                ncol = max(unlist(lapply(b, function(i) length(i))))
            } else if (!is.na(try(max(as.numeric(unlist(b)))))) {
                what = "numeric"
                ncol = max(as.numeric(unlist(b)))
            }
            temp1 <- switch(
                what,
                string = {
                    temp = as.data.frame(t(sapply(b, '[', 1:ncol)))
                    names(temp) = paste(names(data[split.col]),
                                        1:ncol, sep="_")
                    temp = apply(
                        temp, 2, function(x) gsub("^\\s+|\\s+$", "", x))
                    temp1 = cbind(data, temp)
                },
                numeric = {
                    temp = lapply(b, as.numeric)
                    m = matrix(nrow = nrow(data), ncol = ncol)      
                    for (i in 1:nrow(data)) {
                        m[i, temp[[i]]] = temp[[i]]
                    }
                    
                    m = setNames(data.frame(m), 
                                 paste(names(data[split.col]), 1:ncol, sep="_"))
                    
                    if (is.null(mode)) mode = "binary"
                    temp1 <- switch(
                        mode,
                        binary = {cbind(data, replace(m, m != "NA", 1))},
                        value = {cbind(data, m)},
                        stop("'mode' must be 'binary' or 'value'"))
                })
            if (isTRUE(drop.col)) temp1[-split.col]
            else temp1
        },
        stop("'structure' must be either 'compact', 'expanded', or 'list'"))
    temp
}
```


\cleardoublepage

# df.sorter


```r
df.sorter <- function(data, var.order=names(data), 
                      col.sort=NULL, at.start=TRUE ) {
  # Sorts a data.frame by columns or rows or both. Can also subset the 
  #   data columns by using --var.order--. Can refer to variables either 
  #   by names or number. If referring to variable by number, and sorting
  #   both the order of variables and the sorting within variables, 
  #   refer to the variable numbers of the final data.frame.
  #
  # === EXAMPLES ===
  #
  #    library(foreign)
  #    temp = "http://www.ats.ucla.edu/stat/stata/modules/kidshtwt.dta"
  #    kidshtwt = read.dta(temp); rm(temp)
  #    df.sorter(kidshtwt, var.order = c("fam", "bir", "wt", "ht"))
  #    df.sorter(kidshtwt, var.order = c("fam", "bir", "wt", "ht"),
  #              col.sort = c("birth", "famid")) # USE FULL NAMES HERE
  #    df.sorter(kidshtwt, var.order = c(1:4),   # DROP THE WT COLUMNS
  #              col.sort = 3)                   # SORT BY HT1  

  if (is.numeric(var.order)) 
    var.order = colnames(data)[var.order]
  else var.order = var.order
  
  if (isTRUE(at.start)) {
    x = unlist(lapply(var.order, function(x) 
      sort(grep(paste("^", x, sep="", collapse=""), 
                names(data), value = TRUE))))
  } else if (!isTRUE(at.start)) {
    x = unlist(lapply(var.order, function(x) 
      sort(grep(x, names(data), value = TRUE))))
  }
  
  y = data[, x]
  
  if (is.null(col.sort)) {
    y
  } else if (is.numeric(col.sort)) {
    y[do.call(order, y[colnames(y)[col.sort]]), ]
  } else if (!is.numeric(col.sort)) {
    y[do.call(order, y[col.sort]), ]
  }
}
```


\cleardoublepage

# multi.freq.table


```r
multi.freq.table <- function(data, sep = "", boolean = TRUE, factors = NULL,
                             NAto0 = TRUE, basic = FALSE, dropzero=TRUE, 
                             clean=TRUE) {
  # Takes multiple-response data and tabulates it according
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
  
  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  
  if (isTRUE(boolean)) {
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
      counts$Weighted.Freq = Z*counts$Freq
      counts$Pct.of.Resp = (counts$Weighted.Freq/sum(data))*100
      counts$Pct.of.Cases = (counts$Freq/nrow(data))*100
      if (isTRUE(dropzero)) {
        counts = counts[counts$Freq != 0, ]
      } else if (!isTRUE(dropzero)) {
        counts = counts
      }
      if (isTRUE(clean)) {
        counts = data.frame(Combn = counts$Combn, Freq = counts$Freq, 
                            Weighted.Freq = counts$Weighted.Freq,
                            Pct.of.Resp = counts$Pct.of.Resp, 
                            Pct.of.Cases = counts$Pct.of.Cases)
      }
    }
    message("Total cases:     ", CASES, "\n",
            "Valid cases:     ", VALID, "\n",
            "Total responses: ", RESPS, "\n",
            "Valid responses: ", VRESP, "\n")
    counts
  } else if (!isTRUE(boolean)) {
    CASES = nrow(data)
    RESPS = length(data[!is.na(data)])
    if (!isTRUE(any(sapply(data, is.factor)))) {
      if (is.null(factors)) {
        stop("Input variables must be factors.
        Please provide factors using the 'factors' argument or
             convert your data to factor before using function.")
      } else {
        data[sapply(data, is.character)] = 
          lapply(data[sapply(data, is.character)], 
                 function(x) factor(x, levels=factors))
      }      
    }
    if (isTRUE(basic)) {
      ROWS = levels(unlist(data))
      OUT = table(unlist(data))
      PCT = (OUT/sum(OUT)) * 100
      OUT = data.frame(ROWS, OUT, PCT, row.names=NULL)
      OUT = data.frame(Item = OUT[, 1], Freq = OUT[, 3], 
                       Pct.of.Resp = OUT[, 5],
                       Pct.of.Cases = (OUT[, 3]/CASES)*100)
      message("Total cases:     ", CASES, "\n",
              "Total responses: ", RESPS, "\n")
      OUT
    } else if (!isTRUE(basic)) {
      Combos = apply(data, 1, function(x) paste0(sort(x), collapse = sep))
      Weight = as.numeric(rowSums(!is.na(data)))
      OUT = data.frame(table(Combos, Weight))
      OUT = OUT[OUT$Freq > 0, ]
      OUT$Weight = as.numeric(as.character(OUT$Weight))
      if(OUT$Weight[1] == 0) { OUT$Weight[1] = 1 }
      OUT$Weighted.Freq = OUT$Weight*OUT$Freq
      OUT$Pct.of.Resp = (OUT$Weighted.Freq/RESPS)*100
      OUT$Pct.of.Cases = (OUT[, 3]/CASES)*100
      message("Total cases:     ", CASES, "\n",
              "Total responses: ", RESPS, "\n")
      OUT[-2]
    } 
  }
}
```


\cleardoublepage

# RandomNames


```r
RandomNames <- function(N = 100, cat = NULL, gender = NULL, 
                        MFprob = NULL, dataset = NULL) {
  # Generates a "data.frame" of random names with the following columns:
  #   "Gender", "FirstName", and "Surname". All arguments have preset
  #   defaults, so the function can be run simply by typing RandomNames(),
  #   which will generate 100 random male and female names.
  #
  # === EXAMPLES ===
  #
  #     RandomNames()
  #     RandomNames(N = 20)
  #     RandomNames(cat = "common", MFprob = c(.2, .8))
  #
  # See: 
  #   - http://www.census.gov/genealogy/www/data/1990surnames/names_files.html
  #   - http://random-name-generator.info/
  
  if (is.null(dataset)) {
    if (!exists("CensusNames1990", where = 1)) {
      if (isTRUE(list.files(
        pattern = "^CensusNames.RData$") == "CensusNames.RData")) {
        load("CensusNames.RData")
      } else {
        ans = readline("
    CensusNames.RData dataset not found in working directory.
    CensusNames1990 object not found in workspace. \n
    Download and load the dataset now? (y/n) ")
        if (ans != "y")
          return(invisible())
        require(RCurl)
        baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
        temp = getBinaryURL(paste0(baseURL, "data/CensusNames.RData"))
        load(rawConnection(temp), envir=.GlobalEnv)
        message("CensusNames1990 data downloaded from \n",
                paste0(baseURL, "data/CensusNames.RData \n"), 
                "and added to your workspace\n\n")
        rm(temp, baseURL)
      }
    }
    dataset <- CensusNames1990
  }
  TEMP <- dataset
  possiblecats <- c("common", "rare", "average")
  if(all(cat %in% possiblecats) == FALSE) 
    stop('cat must be either "all", NULL,
         or a combination of "common", "average", or "rare"')
  possiblegenders <- c("male", "female", "both")
  if (all(gender %in% possiblegenders) == FALSE) {
    stop('gender must be either "both", NULL, "male", or "female"')
  }
  if (isTRUE(identical(gender, c("male", "female"))) || 
        isTRUE(identical(gender, c("female", "male")))) {
    gender <- "both"
  }
  if (is.null(cat) || cat == "all") {
    surnames <- TEMP[["surnames"]][["Name"]]
    malenames <- paste("M-", TEMP[["malenames"]][["Name"]], sep="")
    femalenames <- paste("F-", TEMP[["femalenames"]][["Name"]], sep="")
  } else {
    surnames <- suppressWarnings(
      with(TEMP[["surnames"]], 
           TEMP[["surnames"]][Category == cat, "Name"]))
    malenames <- paste("M-", suppressWarnings(
      with(TEMP[["malenames"]], 
           TEMP[["malenames"]][Category == cat, "Name"])), sep="")
    femalenames <- paste("F-", suppressWarnings(
      with(TEMP[["femalenames"]], 
           TEMP[["femalenames"]][Category == cat, "Name"])), sep="")
  }
  
  if (is.null(gender) || gender == "both") {
    if (is.null(MFprob)) MFprob <- c(.5, .5)
    firstnames <- sample(c(malenames, femalenames), N, replace = TRUE,
                         prob = c(rep(MFprob[1]/length(malenames), 
                                      length(malenames)),
                                  rep(MFprob[2]/length(femalenames), 
                                      length(femalenames))))
  } else if (gender == "female") {
    firstnames <- sample(femalenames, N, replace = TRUE)
  } else if (gender == "male") {
    firstnames <- sample(malenames, N, replace = TRUE)
  }
  
  Surnames <- sample(surnames, N, replace = TRUE)
  temp <- setNames(data.frame(do.call(rbind, strsplit(firstnames, "-"))),
                   c("Gender", "FirstName"))
  cbind(temp, Surnames)
}
```


\cleardoublepage

# row.extractor


```r
row.extractor = function(data, extract.by, what="all") {
  # Extracts rows with min, median, and max values, or by quantiles. Values 
  #   for --what-- can be "min", "median", "max", "all", or a vector 
  #   specifying the desired quantiles. Values for --extract.by-- can be 
  #   the variable name or number.
  #
  # === EXAMPLES ===
  #
  #    set.seed(1)
  #    dat = data.frame(V1 = 1:10, V2 = rnorm(10), V3 = rnorm(10), 
  #                     V4 = sample(1:20, 10, replace=T))
  #    dat2 = dat[-10,]
  #    row.extractor(dat, 4, "all")
  #    row.extractor(dat1, 4, "min")
  #    row.extractor(dat, "V4", "median")
  #    row.extractor(dat, 4, c(0, .5, 1))
  #    row.extractor(dat, "V4", c(0, .25, .5, .75, 1))
  #
  # "which.quantile" function by cbeleites:
  # http://stackoverflow.com/users/755257/cbeleites
  # See: http://stackoverflow.com/q/10256503/1270695
  
  if (is.numeric(extract.by)) {
    extract.by = extract.by
  } else if (is.numeric(extract.by) != 0) {
    extract.by = which(colnames(data) %in% "extract.by")
  } 
  
  if (is.character(what)) {
    which.median = function(data, extract.by) {
      a = data[, extract.by]
      if (length(a) %% 2 != 0) {
        which(a == median(a))
      } else if (length(a) %% 2 == 0) {
        b = sort(a)[c(length(a)/2, length(a)/2+1)]
        c(max(which(a == b[1])), min(which(a == b[2])))
      }
    }
    
    X1 = data[which(data[extract.by] == min(data[extract.by])), ] # min
    X2 = data[which(data[extract.by] == max(data[extract.by])), ] # max
    X3 = data[which.median(data, extract.by), ]                # median
    
    if (identical(what, "min")) {
      X1
    } else if (identical(what, "max")) {
      X2
    } else if (identical(what, "median")) {
      X3
    } else if (identical(what, "all")) {
      rbind(X1, X3, X2)
    }
  } else if (is.numeric(what)) {
    which.quantile <- function (data, extract.by, what, na.rm = FALSE) {
      
      x = data[ , extract.by]
      
      if (! na.rm & any (is.na (x)))
        return (rep (NA_integer_, length (what)))
      
      o <- order (x)
      n <- sum (! is.na (x))
      o <- o [seq_len (n)]
      
      nppm <- n * what - 0.5
      j <- floor(nppm)
      h <- ifelse((nppm == j) & ((j%%2L) == 0L), 0, 1)
      j <- j + h
      
      j [j == 0] <- 1
      o[j]
    }
    data[which.quantile(data, extract.by, what), ]           # quantile
  }
}
```


\cleardoublepage

# sample.size


```r
sample.size <- function(population, samp.size = NULL, c.lev = 95, 
                        c.int = NULL, what = "sample", distribution=50) {
  # Returns a data.frame of sample sizes or confidence intervals for 
  #   different conditions provided by the following arguments.
  #
  # --> populaton     Population size
  # --> samp.size     Sample size
  # --> c.lev         Confidence level
  # --> c.int         Confidence interval (+/-)
  # --> what          Whether sample size or confidence interval
  #                     is being calculated.
  # --> distribution  Response distribution
  # 
  # === EXAMPLES ===
  #
  #   sample.size(300)
  #   sample.size(300, 150, what="confidence")
  #   sample.size(c(300, 400, 500), c.lev=97)
  
  z = qnorm(.5+c.lev/200)
  
  if (identical(what, "sample")) {
    if (is.null(c.int)) {
      c.int = 5
      
      message("NOTE! Confidence interval set to 5.
      To override, set >> c.int << to desired value.\n")
      
    } else if (!is.null(c.int) == 1) {
      c.int = c.int
    }
    
    if (!is.null(samp.size)) {
      message("NOTE! >> samp.size << value provided but ignored.
      See output for actual sample size(s).\n")
    }
    
    ss = (z^2 * (distribution/100) * 
      (1-(distribution/100)))/((c.int/100)^2)
    samp.size = ss/(1 + ((ss-1)/population))    
    
  } else if (identical(what, "confidence")) {
    if (is.null(samp.size)) {
      stop("Missing >> samp.size << with no default value.")
    }
    if (!is.null(c.int)) {
      message("NOTE! >> c.int << value provided but ignored.
      See output for actual confidence interval value(s).\n")
    }
    
    ss = ((population*samp.size-samp.size)/(population-samp.size))
    c.int = round(sqrt((z^2 * (distribution/100) * 
      (1-(distribution/100)))/ss)*100, digits = 2)
    
  } else if (what %in% c("sample", "confidence") == 0) {
    stop(">> what << must be either -sample- or -confidence-")
  }
  
  RES = data.frame(population = population,
                   conf.level = c.lev,
                   conf.int = c.int,
                   distribution = distribution,
                   sample.size = round(samp.size, digits = 0))
  RES
}
```


\cleardoublepage

# stratified


```r
stratified <- function(df, group, size, seed = NULL, ...) {
  # Returns a stratified random subset of a data.frame.
  #
  # --> df      The source data.frame
  # --> group   Your grouping variable
  # --> size    The desired sample size. If -size- is a decimal, 
  #             a proportionate sample is drawn. If it is >= 1, 
  #             a sample will be taken of that specified size
  # --> seed    The seed that you want to use, if any
  # --> ...     Further arguments to the sample function
  #
  # === EXAMPLES ===
  #
  #   set.seed(1)
  #   dat = data.frame(A = 1:100, 
  #                    B = sample(c("AA", "BB", "CC", "DD", "EE"), 
  #                               100, replace=T),
  #                    C = rnorm(100), D = abs(round(rnorm(100), digits=1)),
  #                    E = sample(c("CA", "NY", "TX"), 100, replace=T))
  #     
  #   stratified(dat, 5, .1, 1)
  #   stratified(dat, group = "E", size = .1, seed = 1)
  #   stratified(dat, "B", 5)
  
  df.interaction <- interaction(df[group])
  df.table <- table(df.interaction)
  df.split <- split(df, df.interaction)
  
  if (length(size) > 1) {
    if (length(size) != length(df.split))
      stop("Number of groups is ", length(df.split),
           " but number of sizes supplied is ", length(size))
    if (is.null(names(size))) {
      n <- setNames(size, names(df.split))
      message(sQuote("size"), " vector entered as:\n\nsize = structure(c(", 
              paste(n, collapse = ", "), "),\n.Names = c(",
              paste(shQuote(names(n)), collapse = ", "), ")) \n\n")
    } else {
      ifelse(all(names(size) %in% names(df.split)), 
             n <- size[names(df.split)], 
             stop("Named vector supplied with names ", 
                  paste(names(size), collapse = ", "),
                  "\n but the names for the group levels are ", 
                  paste(names(df.split), collapse = ", ")))
    } 
  } else if (size < 1) {
    n <- round(df.table * size, digits = 0)
  } else if (size >= 1) {
    if (all(df.table >= size)) {
      n <- setNames(rep(size, length.out = length(df.split)),
                    names(df.split))
    } else {
      message(
        "Some groups\n---", 
        paste(names(df.table[df.table < size]), collapse = ", "),
        "---\ncontain fewer observations",
        " than desired number of samples.\n",
        "All observations have been returned from those groups.")
      n <- c(sapply(df.table[df.table >= size], function(x) x = size),
             df.table[df.table < size])
    }
  }
  
  seedme <- ifelse(is.null(seed), "No", "Yes")
  
  temp <- switch(
    seedme,
    No = { temp <- lapply(
      names(df.split), 
      function(x) df.split[[x]][sample(df.table[x], 
                                       n[x], ...), ]) },
    Yes = { temp <- lapply(
      names(df.split),
      function(x) { set.seed(seed)
                    df.split[[x]][sample(df.table[x], 
                                         n[x], ...), ] }) })
  
  rm(.Random.seed, envir=.GlobalEnv) # "resets" the seed
  do.call("rbind", temp)
}
```


\cleardoublepage

# stringseed.sampling


```r
stringseed.sampling <- function(seedbase, N, n, write.output = FALSE) {
  # Designed for batch sampling scenarios using alpha-numeric strings as a 
  #   --seedbase--. --N-- represents the "population", and --n--, the sample
  #   size needed. A vector is supplied for each argument (or, alternatively, 
  #   a data.frame with the required information). Optionally, the function 
  #   can write the output of the function to a file.
  #
  # === EXAMPLE ===
  #
  #   stringseed.sampling(seedbase = c("Village 1", "Village 2", "Village 3"),
  #                       N = c(150, 309, 297), n = c(15, 31, 30))
  #
  # See: http://stackoverflow.com/q/10910698/1270695
  
  require(digest)
  hexval = paste0("0x", sapply(seedbase, digest, "crc32"))
  seeds = type.convert(hexval) %% .Machine$integer.max
  seedbase = as.character(seedbase)
  
  temp <- data.frame(seedbase, N, n, seeds)
  if (length(seedbase) == 1) {
    set.seed(temp$seeds); sample.list <- sample(temp$N, temp$n)
  } else {
    sample.list <- setNames(
      apply(temp[-1], 1, function(x) 
        {set.seed(x[3]); sample(x[1], x[2])} ), temp[, 1])
  }
  
  temp <- list(
    input = data.frame(seedbase = seedbase, populations = N,
                       samplesizes = n, seeds = seeds),
    samples = sample.list)
  if(isTRUE(write.output)) {
    write.csv(temp[[1]], file=paste("Sample frame generated on",
                                    Sys.Date(), ".csv", collapse=""))
    capture.output(temp[[2]], file=paste("Samples generated on", 
                              Sys.Date(), ".txt", collapse=""))
  }
  rm(.Random.seed, envir=globalenv()) # "resets" the seed
  temp
}
```


\cleardoublepage

# table2df


```r
table2df <- function(mytable, as.multitable = FALSE, direction = "wide") {
  # Converts a table to a data.frame. If the table is an array of tables
  #   you can use >>as.multitable<< to create a list of data.frames.
  #   Direction can be "wide" or "long". If "long", result will be a 
  #   data.frame with the default column variables and a single column
  #   for the frequency.
  #
  # See: http://stackoverflow.com/a/6463137/1270695
  
  ## Check to see if as.multitable is being incorrectly used
  ##   but continue to process output with a warning
  if (isTRUE(as.multitable)) {
    multitablecheck <- ifelse(length(dim(mytable)) == 2, "NoMT", "MT")
    if (isTRUE(as.multitable) && multitablecheck == "NoMT")
      warning(">>as.multitable<< set to TRUE, but evaluates to FALSE.
              Defaulting to basic table to data.frame conversion methods.")
    switch(multitablecheck, NoMT = { as.multitable <- FALSE },
           MT = { as.multitable <- TRUE })
  }
  
  tablearray2list <- function(dataset) {
    # Converts an array of tables to a list of tables
    y <- ls()
    temp <- dim(dataset)[-c(1, 2)]
    temp1 <- capture.output(dataset)
    tempnames <- gsub(", , ", "", temp1[grep(", , ", temp1)])
    tempnames <- sapply(
      strsplit(tempnames, " = |, "), 
      function(x) paste(x[1:length(x) %% 2 == 0], collapse = "."))
    combinations <- expand.grid(lapply(temp, seq))
    tempsets <- apply(combinations, 1, function(x)
      paste(y, "[ , , ", paste(x, collapse = ", "), "]"))
    mylist <- lapply(tempsets, function(x) eval(parse(text = x)))
    names(mylist) <- tempnames
    mylist
  }
  
  directionwide <- function(mydata) {
    # Function to assign proper names to resulting data.frames
    ifelse(class(mydata) == "ftable", 
           mydata <- mydata, mydata <- ftable(mydata))
    dfrows <- expand.grid(rev(attr(mydata, "row.vars")))
    dfcols <- as.data.frame.matrix(mydata)
    names(dfcols) <- interaction(expand.grid(attr(mydata, "col.vars")))
    cbind(dfrows, dfcols)
  }
  
  directionlong <- function(mydata) {
    # Basic tables are easy to convert to data.frames
    mydata <- as.table(mydata)
    as.data.frame(mydata)
  }
  
  if (isTRUE(as.multitable)) {
    temp <- tablearray2list(mytable)
    switch(direction,
           wide = { lapply(temp, directionwide) },
           long = { lapply(temp, directionlong) },
           stop(">>direction<< must be either wide or long"))
  } else {
    switch(direction,
           wide = { directionwide(mytable) },
           long = { directionlong(mytable) },
           stop(">>direction<< must be either wide or long"))
  }
}
```


\cleardoublepage
