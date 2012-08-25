



\part{Snippets and Tips}

# Snippets

## Load All Scripts and Data Files From Multiple Directories


```r
load.scripts.and.data = function(path,
                                 pattern=list(scripts = "*.R$",
                                              data = "*.rda$|*.Rdata$"), 
                                 ignore.case=TRUE) {
  # Reads all the data files and scripts from specified directories.
  #     In general, should only need to specify the directories.
  #     Specify directories without trailing slashes.
  #
  # === EXAMPLE ===
  #
  #    load.scripts.and.data(c("~/Dropbox/Public", 
  #                            "~/Dropbox/Public/R Functions"))
    
  file.sources = list.files(path, pattern=pattern$scripts, 
                            full.names=TRUE, ignore.case=ignore.case)
  data.sources = list.files(path, pattern=pattern$data,
                            full.names=TRUE, ignore.case=ignore.case)
  sapply(data.sources,load,.GlobalEnv)
  sapply(file.sources,source,.GlobalEnv)
}
```


## Convert a List of Data Frames Into Individual Data Frames


```r
unlist.dfs = function(data) {
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
$A
  A B
1 1 3
2 2 4

$B
  C D
1 5 7
2 6 8

```

```r
# Remove any files with similar names to output
rm(list=ls(pattern="temp_"))
# The following should not work
temp_1
```

```
Error: object 'temp_1' not found
```

```r
# Split it up!
unlist.dfs("temp")
# List files with the desired pattern
ls(pattern="temp_")
```

```
[1] "temp_1" "temp_2"
```

```r
# View the new files
temp_1
```

```
  A B
1 1 3
2 2 4
```

```r
temp_2
```

```
  C D
1 5 7
2 6 8
```


## Convert a Data Frame Into a List With Each Column Becoming a List Item


```r
dfcols.list = function(data, vectorize=FALSE) {
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
  A B C
1 1 3 5
2 2 4 6
```

```r
# Split into a list, retaining data.frame structure
dfcols.list(dat)
```

```
[[1]]
  A
1 1
2 2

[[2]]
  B
1 3
2 4

[[3]]
  C
1 5
2 6

```

```r
# Split into a list, converting to vector
dfcols.list(dat, vectorize=TRUE)
```

```
$A
[1] 1 2

$B
[1] 3 4

$C
[1] 5 6

```


## Rename an Object in the Workplace


```r
mv <- function (a, b) {
  # Source: https://stat.ethz.ch/pipermail/r-help/2008-March/156035.html
  anm <- deparse(substitute(a))
  bnm <- deparse(substitute(b))
  if (!exists(anm,where=1,inherits=FALSE))
    stop(paste(anm, "does not exist.\n"))
  if (exists(bnm,where=1,inherits=FALSE)) {
    ans <- readline(paste("Overwrite ", bnm, "? (y/n) ", sep =  ""))
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
'data.frame':	3 obs. of  3 variables:
 $ title     : Factor w/ 3 levels "title1","title2",..: 1 2 3
 $ author    : Factor w/ 3 levels "author1","author2",..: 1 2 3
 $ customerID: num  1 2 1
```

```r
# Left of the equal sign identifies and extracts the factor variables;
#    right converts them from factor to character
dat[sapply(dat, is.factor)] = lapply(dat[sapply(dat, is.factor)], 
                                     as.character)
str(dat)
```

```
'data.frame':	3 obs. of  3 variables:
 $ title     : chr  "title1" "title2" "title3"
 $ author    : chr  "author1" "author2" "author3"
 $ customerID: num  1 2 1
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
  ID  JAN  FEB  MAR  APR
1  2    X    E    R    F
2  3 <NA>    F    X    D
3  4    V <NA>    M    Q
4  5    F    B <NA> <NA>
```


### How Much Memory Are the Objects in Your Workspace Using?

Sometimes you need to just check and see how much memory the objects in your workspace occupy.


```r
sort(sapply(ls(), function(x) {object.size(get(x))}))
```

