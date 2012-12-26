



\part{Snippets and Tips}

# Snippets

## Load All Scripts and Data Files From Multiple Directories


```r
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
```


## Convert a List of Data Frames Into Individual Data Frames


```r
unlist.dfs <- function(data) {
  # Specify the quoted name of the source list.
  q = get(data)
  prefix = paste0(data, "_", 1:length(q))
  for (i in 1:length(q)) assign(prefix[i], q[[i]], envir=.GlobalEnv)
}
```


### Example

*Note that the list name must be quoted.*


```r
# Sample data
temp = list(A = data.frame(A = 1:2, B = 3:4), 
            B = data.frame(C = 5:6, D = 7:8))
temp
```

```
## $A
##   A B
## 1 1 3
## 2 2 4
## 
## $B
##   C D
## 1 5 7
## 2 6 8
```

```r
# Remove any files with similar names to output
rm(list=ls(pattern="temp_"))
# The following should not work
temp_1
```

```
## Error: object 'temp_1' not found
```

```r
# Split it up!
unlist.dfs("temp")
# List files with the desired pattern
ls(pattern="temp_")
```

```
## [1] "temp_1" "temp_2"
```

```r
# View the new files
temp_1
```

```
##   A B
## 1 1 3
## 2 2 4
```

```r
temp_2
```

```
##   C D
## 1 5 7
## 2 6 8
```


## Convert a Data Frame Into a List With Each Column Becoming a List Item


```r
dfcols.list <- function(data, vectorize = FALSE) {
  # Specify the unquoted name of the data.frame to convert
  if (isTRUE(vectorize)) {
    dat.list = sapply(1:ncol(data), function(x) data[x])
  } else if (!isTRUE(vectorize)) {
    dat.list = lapply(names(data), function(x) data[x])
  }
  dat.list
}
```


### Examples


```r
# Sample data
dat = data.frame(A = c(1:2), B = c(3:4), C = c(5:6))
dat
```

```
##   A B C
## 1 1 3 5
## 2 2 4 6
```

```r
# Split into a list, retaining data.frame structure
dfcols.list(dat)
```

```
## [[1]]
##   A
## 1 1
## 2 2
## 
## [[2]]
##   B
## 1 3
## 2 4
## 
## [[3]]
##   C
## 1 5
## 2 6
```

```r
# Split into a list, converting to vector
dfcols.list(dat, vectorize=TRUE)
```

```
## $A
## [1] 1 2
## 
## $B
## [1] 3 4
## 
## $C
## [1] 5 6
```


## Rename an Object in the Workplace


```r
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
```


### Basic Usage

If there is already an object with the same name in the workplace, the function will ask you if you want to replace the object or not. Otherwise, the basic usage is:


```r
# Rename "object_1" to "object_2"
mv(object_1, object_2)
```


## Scrape Data From a Poorly Formatted HTML Page

Reformats a web page using HTML Tidy and uses the XML package to parse the resulting file. Can optionally save the reformatted page.


```r
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
```


### Example


```r
# Set `saveTidy` to `TRUE` to save the resulting tidied file
URL <- "http://www.bcn.gob.ni/estadisticas/trimestrales_y_mensuales/siec/datos/4.IMAE.htm"
temp <- tidyHTML(URL, saveTidy = FALSE)
```


## "Rounding in Commerce"

R rounds to even---something that some people might not be accustomed to or comfortable with. For the more commonly known rounding rule, use this `round2` function.


```r
round2 <- function(x, n = 0) {
  posneg = sign(x)
  z = abs(x)*10^n
  z = z + 0.5
  z = trunc(z)
  z = z/10^n
  z*posneg
}
```


### Example


```r
x = c(1.85, 1.54, 1.65, 1.85, 1.84)
round(x, 1)
```

```
## [1] 1.8 1.5 1.6 1.8 1.8
```

```r
round2(x, 1)
```

```
## [1] 1.9 1.5 1.7 1.9 1.8
```

```r
round(seq(0.5, 9.5, by=1))
```

```
##  [1]  0  2  2  4  4  6  6  8  8 10
```

```r
round2(seq(0.5, 9.5, by=1))
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```


### References

Original function: [http://www.webcitation.org/68djeLBtJ](http://www.webcitation.org/68djeLBtJ) -- see the comments section.    
See also: [http://stackoverflow.com/questions/12688717/round-up-from-5-in-r/](http://stackoverflow.com/questions/12688717/round-up-from-5-in-r/).

## `cbind` `data.frame`s When the Number of Rows are Not Equal

`cbind()` does not work when trying to combine `data.frame`s with differing numbers of rows. This function takes a `list` of `data.frame`s, identifies how many extra rows are required to make `cbind` work correctly, and does the combining for you.

The function also works with nested lists by first "flattening" them using the `LinearizeNestedList` by [Akhil S Bhel](https://sites.google.com/site/akhilsbehl/geekspace/articles/r/linearize_nested_lists_in_r). The first time you run the `CBIND()` function, it check your current environment to identify whether `LinearizeNestedList` is already available; if it is not, it will download and load the function from its [Gist page](https://gist.github.com/4205477). Subsequent calls to the function in the same session will not re-download the function. 


```r
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
```


### Examples


```r
# Example data
df1 <- data.frame(A = 1:5, B = letters[1:5])
df2 <- data.frame(C = 1:3, D = letters[1:3])
df3 <- data.frame(E = 1:8, F = letters[1:8], G = LETTERS[1:8])
# Try to use cbind directly
cbind(df1, df2, df3)
```

```
## Error: arguments imply differing number of rows: 5, 3, 8
```

```r
# Use our new function
CBIND(list(df1, df2, df3))
```

```
##   1.A  1.B 2.C  2.D 3.E 3.F 3.G
## 1   1    a   1    a   1   a   A
## 2   2    b   2    b   2   b   B
## 3   3    c   3    c   3   c   C
## 4   4    d  NA <NA>   4   d   D
## 5   5    e  NA <NA>   5   e   E
## 6  NA <NA>  NA <NA>   6   f   F
## 7  NA <NA>  NA <NA>   7   g   G
## 8  NA <NA>  NA <NA>   8   h   H
```

```r
test1 <- list(df1, df2, df3)
str(test1)
```

```
## List of 3
##  $ :'data.frame':	5 obs. of  2 variables:
##   ..$ A: int [1:5] 1 2 3 4 5
##   ..$ B: Factor w/ 5 levels "a","b","c","d",..: 1 2 3 4 5
##  $ :'data.frame':	3 obs. of  2 variables:
##   ..$ C: int [1:3] 1 2 3
##   ..$ D: Factor w/ 3 levels "a","b","c": 1 2 3
##  $ :'data.frame':	8 obs. of  3 variables:
##   ..$ E: int [1:8] 1 2 3 4 5 6 7 8
##   ..$ F: Factor w/ 8 levels "a","b","c","d",..: 1 2 3 4 5 6 7 8
##   ..$ G: Factor w/ 8 levels "A","B","C","D",..: 1 2 3 4 5 6 7 8
```

```r
CBIND(test1)
```

```
##   1.A  1.B 2.C  2.D 3.E 3.F 3.G
## 1   1    a   1    a   1   a   A
## 2   2    b   2    b   2   b   B
## 3   3    c   3    c   3   c   C
## 4   4    d  NA <NA>   4   d   D
## 5   5    e  NA <NA>   5   e   E
## 6  NA <NA>  NA <NA>   6   f   F
## 7  NA <NA>  NA <NA>   7   g   G
## 8  NA <NA>  NA <NA>   8   h   H
```

```r
test2 <- list(test1, df1)
str(test2)
```

```
## List of 2
##  $ :List of 3
##   ..$ :'data.frame':	5 obs. of  2 variables:
##   .. ..$ A: int [1:5] 1 2 3 4 5
##   .. ..$ B: Factor w/ 5 levels "a","b","c","d",..: 1 2 3 4 5
##   ..$ :'data.frame':	3 obs. of  2 variables:
##   .. ..$ C: int [1:3] 1 2 3
##   .. ..$ D: Factor w/ 3 levels "a","b","c": 1 2 3
##   ..$ :'data.frame':	8 obs. of  3 variables:
##   .. ..$ E: int [1:8] 1 2 3 4 5 6 7 8
##   .. ..$ F: Factor w/ 8 levels "a","b","c","d",..: 1 2 3 4 5 6 7 8
##   .. ..$ G: Factor w/ 8 levels "A","B","C","D",..: 1 2 3 4 5 6 7 8
##  $ :'data.frame':	5 obs. of  2 variables:
##   ..$ A: int [1:5] 1 2 3 4 5
##   ..$ B: Factor w/ 5 levels "a","b","c","d",..: 1 2 3 4 5
```

```r
CBIND(test2)
```

```
##   1/1.A 1/1.B 1/2.C 1/2.D 1/3.E 1/3.F 1/3.G 2.A  2.B
## 1     1     a     1     a     1     a     A   1    a
## 2     2     b     2     b     2     b     B   2    b
## 3     3     c     3     c     3     c     C   3    c
## 4     4     d    NA  <NA>     4     d     D   4    d
## 5     5     e    NA  <NA>     5     e     E   5    e
## 6    NA  <NA>    NA  <NA>     6     f     F  NA <NA>
## 7    NA  <NA>    NA  <NA>     7     g     G  NA <NA>
## 8    NA  <NA>    NA  <NA>     8     h     H  NA <NA>
```


## Generate Random Names With an Online Service

This function uses the random name generator from the [*Random Name Generator*](http://random-name-generator.info/) website^[See: [http://random-name-generator.info/](http://random-name-generator.info/)]. This is included here mostly for "fun", and to show how we can use form input parameters from some websites in our R scripts.

> **Note**: Since there is no concept of a *seed* at the website from which these names are drawn, you should expect to get different names each time the function is run. If you want more control, but similar functionality, use the `RandomNames()` function instead.

### Arguments

* `number`: How many names do you want?
* `gender`: Specify whether you want `"male"` names, `"female"` names, or `"both"`.
* `type`: Specify whether you want `"common"`, `"average"`, or `"rare"` names.


```r
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
```


### Examples


```r
randomNamesOnline(10)
```

```
##  [1] "Rod Casper"        "Elina Escobar"     "Rodrick Vickers"  
##  [4] "Alejandra Townes"  "Shad Barela"       "Jackson Thurston" 
##  [7] "Darline Greenwood" "Tera Griswold"     "Alonso Deleon"    
## [10] "Junko Ferraro"
```

```r
randomNamesOnline(10, gender = "both", type = "common")
```

```
##  [1] "Nancy Anderson"   "Jesse Hall"       "Kathleen Flores"  "Larry Reed"      
##  [5] "Thomas Rodriguez" "Roger Garcia"     "Linda Henderson"  "Nicole Ward"     
##  [9] "Martin Walker"    "Brandon Diaz"
```

```r
randomNamesOnline(10, "male", "average")
```

```
##  [1] "Alejandro Becker" "Charles Black"    "Eddie Lewis"      "Alfred Soto"     
##  [5] "Joseph Rodriguez" "Eugene Walton"    "Ignacio Jordan"   "Ray Payne"       
##  [9] "Orville Wong"     "Edgar Jimenez"
```


## Use strings to set seed when generating a random sample

The `stringseed.basic()` function is a more simplified (but less robust) seed generator and random sampling function, similar to the `stringseed.sampling()` function. Unlike `stringseed.sampling()`, this function does not require loading any extra packages for generating the seed, but uses basic methods such as letter substitutions and basic numeric transformations to create some "noise" before assigning a seed.

The function was originally written for students at the Tata-Dhan Academy (and named `TDASample()`)to help them draw samples during their fieldwork. See the Appendix for a more detailed concept note on how the function works and how it was expected to be used.


```r
stringseed.basic <- function(inString, N, n, toFile = FALSE) {
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
  
  temp1 <- list(
    Metadata = 
      noquote(c(sprintf("           The sample was drawn on: %s.", 
                        Sys.time()),
                sprintf("                The seed input was: '%s'", 
                        inString),
                sprintf("The total number of households was: %d.", N),
                sprintf(" The desired number of samples was: %d.", n))),
    SeedUsed = seed, 
    FinalSample = temp0,
    FinalSample_sorted = sort(temp0))
  
  rm(.Random.seed, envir=globalenv())
  
  if (isTRUE(toFile)) {
    capture.output(temp1, 
                   file = paste("Sample from", 
                                Sys.Date(), ".txt", 
                                collapse=""),
                   append = TRUE)
  }
  temp1
}
```


## Draw a stratified random sample from a `data.frame`

The `strata.sampling()` function is a wrapper around the `strata()` and `getdata()` functions from the "sampling" package that allows you to quickly draw a stratified random sample from a `data.frame` after specifying a single grouping variable. The sample sizes can be proportionate to the number of observations in each strata, a uniform size from all groups, or a vector specifying the number of samples to take from each group. 

A very similar function (but one which does not depend on other packages) is the `stratified()` function.


```r
strata.sampling <- function(data, group, size, method = NULL) {
  #  USE: 
  #   * Specify a data.frame and grouping variable.
  #   * Decide on your sample size. For a sample proportional to the 
  #     population, enter "size" as a decimal. For an equal number of 
  #     samples from each group, enter "size" as a whole number. For
  #     a specific number of samples from each group, enter the numbers
  #     required as a vector.
  
  require(sampling)
  if (is.null(method)) method <- "srswor"
  if (!method %in% c("srswor", "srswr")) 
    stop('method must be "srswor" or "srswr"')
  temp <- data[order(data[[group]]), ]
  ifelse(length(size) > 1,
         size <- size, 
         ifelse(size < 1,
                size <- round(table(temp[group]) * size),
                size <- rep(size, times=length(table(temp[group])))))
  strat = strata(temp, stratanames = names(temp[group]), 
                 size = size, method = method)
  getdata(temp, strat)
}
```


### Examples


```r
# Generate a couple of sample data.frames to play with
set.seed(1)
dat1 <- data.frame(ID = 1:100,
                   A = sample(c("AA", "BB", "CC", "DD", "EE"), 100, replace=T),
                   B = rnorm(100), C = abs(round(rnorm(100), digits=1)),
                   D = sample(c("CA", "NY", "TX"), 100, replace=T))

# Let's take a 10% sample from all -A- groups in dat1
strata.sampling(dat1, "A", .1)
```

```
##      ID       B   C  D  A ID_unit    Prob Stratum
## 88   88 -0.5283 1.2 NY AA      11 0.07692       1
## 11   11  2.4016 0.4 TX BB      17 0.08000       2
## 89   89 -0.6521 1.1 TX BB      37 0.08000       2
## 67   67 -0.3200 0.3 CA CC      53 0.10526       3
## 97   97  2.0872 0.5 NY CC      56 0.10526       3
## 37   37  1.0631 1.5 NY DD      66 0.11538       4
## 39   39  0.3700 0.4 CA DD      67 0.11538       4
## 100 100 -1.6406 1.0 NY DD      83 0.11538       4
## 6     6  1.9804 1.1 TX EE      85 0.11765       5
## 99   99 -1.2863 0.2 NY EE     100 0.11765       5
```

```r

# Let's take 5 samples from all -D- groups in dat1, 
#   specified by column number
strata.sampling(dat1, group = 5, size = 5)
```

```
##    ID  A        B   C  D ID_unit   Prob Stratum
## 39 39 DD  0.37002 0.4 CA       8 0.2174       1
## 46 46 DD  0.55849 1.0 CA      11 0.2174       1
## 53 53 CC -0.91092 1.6 CA      12 0.2174       1
## 58 58 CC  0.91017 0.5 CA      14 0.2174       1
## 87 87 DD -0.30098 0.6 CA      22 0.2174       1
## 4   4 EE -1.12936 0.9 NY      26 0.1190       2
## 12 12 AA -0.03924 0.2 NY      30 0.1190       2
## 31 31 CC -0.56867 1.2 NY      37 0.1190       2
## 40 40 CC  0.26710 0.9 NY      41 0.1190       2
## 61 61 EE -0.63574 0.2 NY      48 0.1190       2
## 11 11 BB  2.40162 0.4 TX      70 0.1429       3
## 21 21 EE  0.47551 2.3 TX      73 0.1429       3
## 27 27 AA -0.44329 0.8 TX      76 0.1429       3
## 51 51 CC -0.62037 0.4 TX      83 0.1429       3
## 80 80 EE -0.32427 0.3 TX      95 0.1429       3
```

```r

# Let's take a sample from all -A- groups in dat1 
#   where we specify the number wanted from each group
strata.sampling(dat1, "A", size = c(3, 5, 4, 5, 2))
```

```
##    ID        B   C  D  A ID_unit   Prob Stratum
## 27 27 -0.44329 0.8 TX AA       4 0.2308       1
## 47 47 -1.27659 1.4 TX AA       7 0.2308       1
## 56 56  1.76729 2.5 NY AA       9 0.2308       1
## 22 22 -0.70995 0.1 TX BB      20 0.2000       2
## 26 26  0.29145 0.0 TX BB      22 0.2000       2
## 57 57  0.71671 0.7 CA BB      26 0.2000       2
## 78 78 -0.03763 1.6 NY BB      33 0.2000       2
## 86 86 -1.53645 0.1 NY BB      36 0.2000       2
## 16 16  0.18879 2.2 CA CC      40 0.2105       3
## 40 40  0.26710 0.9 NY CC      44 0.2105       3
## 48 48 -0.57327 1.0 NY CC      47 0.2105       3
## 75 75 -0.10019 1.2 TX CC      54 0.2105       3
## 9   9  0.56972 1.4 TX DD      59 0.1923       4
## 23 23  0.61073 0.5 NY DD      64 0.1923       4
## 65 65 -0.20738 1.0 TX DD      74 0.1923       4
## 68 68 -0.27911 1.3 NY DD      75 0.1923       4
## 85 85  0.30656 0.1 NY DD      78 0.1923       4
## 18 18  1.46555 1.4 NY EE      87 0.1176       5
## 94 94 -0.46353 0.9 NY EE      99 0.1176       5
```



\newpage

# Tips

Many of the following tips are useful for reducing repetitious tasks. They might seem silly or unnecessary with the small examples provided, but they can be *huge* time-savers when dealing with larger objects or larger sets of data.

## Batch Convert Factor Variables to Character Variables

In the example data below, `author` and `title` are automatically converted to factor (unless you add the argument `stringsAsFactor = FALSE` when you are creating the data). What if you forgot and actually needed the variables to be in mode `as.character` instead?

Use `sapply` to identify which variables are currently factors and convert them to `as.character`.


```r
dat = data.frame(title = c("title1", "title2", "title3"),
                 author = c("author1", "author2", "author3"),
                 customerID = c(1, 2, 1))
str(dat)
```

```
## 'data.frame':	3 obs. of  3 variables:
##  $ title     : Factor w/ 3 levels "title1","title2",..: 1 2 3
##  $ author    : Factor w/ 3 levels "author1","author2",..: 1 2 3
##  $ customerID: num  1 2 1
```

```r
# Left of the equal sign identifies and extracts the factor variables;
#    right converts them from factor to character
dat[sapply(dat, is.factor)] = lapply(dat[sapply(dat, is.factor)], 
                                     as.character)
str(dat)
```

```
## 'data.frame':	3 obs. of  3 variables:
##  $ title     : chr  "title1" "title2" "title3"
##  $ author    : chr  "author1" "author2" "author3"
##  $ customerID: num  1 2 1
```


## Using Reduce to Merge Multiple Data Frames at Once

The `merge` function in R only merges two objects at a time. This is usually fine, but what if you had several `data.frames` that needed to be merged?

Consider the following data, where we want to take monthly tables and merge them into an annual table:


```r
set.seed(1)
JAN = data.frame(ID = sample(5, 3), JAN = sample(LETTERS, 3))
FEB = data.frame(ID = sample(5, 3), FEB = sample(LETTERS, 3))
MAR = data.frame(ID = sample(5, 3), MAR = sample(LETTERS, 3))
APR = data.frame(ID = sample(5, 3), APR = sample(LETTERS, 3))
```


If we wanted to merge these into a single `data.frame` using `merge`, we might end up creating several temporary objects and merging those, like this:


```r
temp_1 = merge(JAN, FEB, all=TRUE)
temp_2 = merge(temp_1, MAR, all=TRUE)
temp_3 = merge(temp_2, APR, all=TRUE)
```


Or, we might nest a whole bunch of `merge` commands together, something like this:


```r
merge(merge(merge(JAN, FEB, all=TRUE), 
            MAR, all=TRUE), 
      APR, all=TRUE)
```


However, that first option requires a lot of unnecessary typing and produces unnecessary objects that we then need to remember to remove, and the second option is not very reader-friendly---try doing a merge like that with, say, 12 `data.frames` if we had an entire year of data!

Use `Reduce` instead, simply specifying all the objects to be merged in a `list`:


```r
Reduce(function(x, y) merge(x, y, all=TRUE), 
       list(JAN, FEB, MAR, APR))
```

```
##   ID  JAN  FEB  MAR  APR
## 1  2    X    E    R    F
## 2  3 <NA>    F    X    D
## 3  4    V <NA>    M    Q
## 4  5    F    B <NA> <NA>
```


## How Much Memory Are the Objects in Your Workspace Using?

Sometimes you need to just check and see how much memory the objects in your workspace occupy.


```r
sort(sapply(ls(), function(x) {object.size(get(x))}))
```


## Convert a Table to a Data Frame

Creating tables are easy and fast, but sometimes, it is more convenient to have the output as a `data.frame`. Get the `data.frame` by nesting the command in `as.data.frame.matrix`.


```r
# A basic table
x <- with(airquality, table(cut(Temp, quantile(Temp)), Month))
str(x)
```

```
##  'table' int [1:4, 1:5] 24 5 1 0 3 15 7 5 0 2 ...
##  - attr(*, "dimnames")=List of 2
##   ..$      : chr [1:4] "(56,72]" "(72,79]" "(79,85]" "(85,97]"
##   ..$ Month: chr [1:5] "5" "6" "7" "8" ...
```

```r
x
```

```
##          Month
##            5  6  7  8  9
##   (56,72] 24  3  0  1 10
##   (72,79]  5 15  2  9 10
##   (79,85]  1  7 19  7  5
##   (85,97]  0  5 10 14  5
```

```r
# The same table as a data.frame
y <- as.data.frame.matrix(x)
str(y)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ 5: int  24 5 1 0
##  $ 6: int  3 15 7 5
##  $ 7: int  0 2 19 10
##  $ 8: int  1 9 7 14
##  $ 9: int  10 10 5 5
```

```r
y
```

```
##          5  6  7  8  9
## (56,72] 24  3  0  1 10
## (72,79]  5 15  2  9 10
## (79,85]  1  7 19  7  5
## (85,97]  0  5 10 14  5
```


 
