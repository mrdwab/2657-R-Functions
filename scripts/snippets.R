## USEFUL SNIPPETS

## @knitr scriptsanddata
load.scripts.and.data <- function(path, pattern = list(scripts = "*.R$",
                          data = "*.rda$|*.Rdata$"), ignore.case=TRUE) {
  # Reads all the data files and scripts from specified directories. In 
  #   general, should only need to specify the directories. Specify 
  #   directories without trailing slashes.
  #
  # === EXAMPLE ===
  #
  #    load.scripts.and.data(c("~/Dropbox/Public", 
  #                            "~/Dropbox/Public/R Functions"))
    
  file.sources = list.files(path, pattern=pattern$scripts, 
                            full.names=TRUE, ignore.case=ignore.case)
  data.sources = list.files(path, pattern=pattern$data,
                            full.names=TRUE, ignore.case=ignore.case)
  sapply(data.sources, load, .GlobalEnv)
  sapply(file.sources, source, .GlobalEnv)
}

## @knitr unlistdfs
unlist.dfs <- function(data) {
  # Specify the quoted name of the source list.
  q = get(data)
  prefix = paste0(data, "_", 1:length(q))
  for (i in 1:length(q)) assign(prefix[i], q[[i]], envir=.GlobalEnv)
}

## @knitr dfcolslist
dfcols.list <- function(data, vectorize = FALSE) {
  # Specify the unquoted name of the data.frame to convert
  if (isTRUE(vectorize)) {
    dat.list = sapply(1:ncol(data), function(x) data[x])
  } else if (!isTRUE(vectorize)) {
    dat.list = lapply(names(data), function(x) data[x])
  }
  dat.list
}

## @knitr rmmove
mv <- function (a, b) {
  # Source: https://stat.ethz.ch/pipermail/r-help/2008-March/156035.html
  anm = deparse(substitute(a))
  bnm = deparse(substitute(b))
  if (!exists(anm,where=1,inherits=FALSE))
    stop(paste(anm, "does not exist.\n"))
  if (exists(bnm,where=1,inherits=FALSE)) {
    ans = readline(paste("Overwrite ", bnm, "? (y/n) ", sep =  ""))
    if (ans != "y")
      return(invisible())
  }
  assign(bnm, a, pos = 1)
  rm(list = anm, pos = 1)
  invisible()
}

## @knitr tidyhtml
tidyHTML <- function(URL, saveTidy = TRUE) {
  require(XML)
  URL1 = gsub("/", "%2F", URL)
  URL1 = gsub(":", "%3A", URL1)
  URL1 = paste("http://services.w3.org/tidy/tidy?docAddr=", 
               URL1, "&indent=on", sep = "")
  Parsed = htmlParse(URL1)
  if (isTRUE(saveTidy)) saveXML(Parsed, file = basename(URL))
  Parsed
}

## @knitr round2
round2 <- function(x, n = 0) {
  posneg = sign(x)
  z = abs(x)*10^n
  z = z + 0.5
  z = trunc(z)
  z = z/10^n
  z*posneg
}

## @knitr CBIND
CBIND <- function(datalist) {
  if ("LinearizeNestedList" %in% ls(envir=.GlobalEnv) == FALSE) {
    require(devtools)
    suppressMessages(source_gist(4205477))
    message("LinearizeNestedList loaded from https://gist.github.com/4205477")
  }
  datalist <- LinearizeNestedList(datalist)
  nrows <- max(sapply(datalist, nrow))
  expandmyrows <- function(mydata, rowsneeded) {
    temp1 = names(mydata)
    rowsneeded = rowsneeded - nrow(mydata)
    temp2 = setNames(data.frame(
      matrix(rep(NA, length(temp1) * rowsneeded),
             ncol = length(temp1))), temp1)
    rbind(mydata, temp2)
  }
  do.call(cbind, lapply(datalist, expandmyrows, rowsneeded = nrows))
}

## @knitr randomnamesonline
randomNamesOnline <- function(number = 100, gender = "both", type = "rare") {
  gender <- tolower(gender); type <- tolower(type)
  gender <- switch(gender, both = "&g=1", male = "&g=2", female = "&g=3",
            stop('"gender" must be either "male", "female", or, "both"'))
  type <- switch(type, rare = "&st=3", average = "&st=2", common = "&st=1", 
          stop('"type" must be either "rare", "average", or "common"'))
  tempURL <- paste("http://random-name-generator.info/random/?n=", 
                   number, gender, type, sep = "", collapse = "")
  temp <- suppressWarnings(readLines(tempURL))
  temp <- gsub("\t|<li>|</ol>", "", temp[102:(102 + number - 1)])
  temp
}

## @knitr stringseedbasic

stringseed.basic <- function(inString, N, n, toFile = FALSE) {
  # Uses string input as the basis for generating seeds before sampling
  
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