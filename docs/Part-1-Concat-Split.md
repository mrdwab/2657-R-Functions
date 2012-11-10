



# concat.split

The `concat.split` function takes a column with multiple values, splits the values into a list or into separate columns, and returns a new `data.frame`.

## Arguments

* `data`: the source `data.frame`.
* `split.col`: the variable that needs to be split; can be specified either by the column number or the variable name.
* `to.list`: logical; should the split column be returned as a single variable list (named "original-variable_list") or multiple new variables? If `to.list` is `TRUE`, the `mode` argument is ignored and a list of the original values are returned.
* `mode`: can be either `binary` or `value` (where `binary` is default and it recodes values to `1` or `NA`, like Boolean, but without assuming `0` when data is not available).
* `sep`: the character separating each value (defaults to `","`).
* `drop.col`: logical (whether to remove the original variable from the output or not; defaults to `TRUE`).

## Examples

First load some data from a CSV stored at [github](http://github.com). The URL is an HTTPS, so we need to use `getURL` from `RCurl`.


```r
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
temp = getURL(paste0(baseURL, "data/concatenated-cells.csv"))
concat.test = read.csv(textConnection(temp))
rm(temp)

# How big is the dataset?
dim(concat.test)
```

```
[1] 48  4
```

```r
# Just show me the first few rows
head(concat.test)
```

```
    Name     Likes                   Siblings    Hates
1   Boyd 1,2,4,5,6 Reynolds , Albert , Ortega     2;4;
2  Rufus 1,2,4,5,6  Cohen , Bert , Montgomery 1;2;3;4;
3   Dana 1,2,4,5,6                     Pierce       2;
4 Carole 1,2,4,5,6 Colon , Michelle , Ballard     1;4;
5 Ramona   1,2,5,6           Snyder , Joann ,   1;2;3;
6 Kelley   1,2,5,6          James , Roxanne ,     1;4;
```


Notice that the data have been entered in a very silly manner. Let's split it up!


```r
# Load the function!
# require(RCurl)
# baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/concat.split.R"))))
```

```
Error: 99:1: unexpected '}' 98: } 99: } ^
```

```r

# Split up the second column, selecting by column number
head(concat.split(concat.test, 2))
```

```
Error: could not find function "concat.split"
```

```r
# ... or by name, and drop the offensive first column
head(concat.split(concat.test, "Likes", drop.col=TRUE))
```

```
Error: could not find function "concat.split"
```

```r
# The "Hates" column uses a different separator:
head(concat.split(concat.test, "Hates", sep=";", drop.col=TRUE))
```

```
Error: could not find function "concat.split"
```

```r
# Retain the original values
head(concat.split(concat.test, 2, mode="value", drop.col=TRUE))
```

```
Error: could not find function "concat.split"
```

```r
# Let's try splitting some strings... Same syntax
head(concat.split(concat.test, 3, drop.col=TRUE))
```

```
Error: could not find function "concat.split"
```

```r
# Split up the "Likes column" into a list variable; retain original column
head(concat.split(concat.test, 2, to.list=TRUE, drop.col=FALSE))
```

```
Error: could not find function "concat.split"
```

```r
# View the structure of the output for the first 10 rows to verify 
# that the new column is a list; note the difference between "Likes"
# and "Likes_list".
str(concat.split(concat.test, 2, to.list=TRUE, drop.col=FALSE)[1:10, c(2, 5)])
```

```
Error: could not find function "concat.split"
```


## Advanced Usage

It is also possible to use `concat.split` to split multiple columns at once. This can be done in stages, or it can be all wrapped in nested statements, as follows:


```r
do.call(cbind, c(concat.test[1],
                 lapply(lapply(2:ncol(concat.test),
                               function(x) concat.test[x]),
                        concat.split, split.col=1, drop=TRUE, sep=";|,")))
```


In the example above (working from the inside of the function outwards):

* First, `lapply(2:ncol(concat.test), ...)` splits the columns of the `data.frame` into a list. 
* Second, `lapply(lapply(...))` does the splitting work.
    * Note the use of `sep=";|,"` to match multiple separators on which to split; if further separators are required, they can be specified by using the pipe symbol (`|`) *with no leading or trailing spaces*.
* Finally, `do.call(cbind, ...)` is evaluated last, "binding" the data together by columns. In this case, the data being bound together is the first column from the `concat.test` dataset, and the splitted output of the remaining columns. 

Alternatively, a similar approach can be taken using the function `dfcols.list` (see the "Snippets and Tips" section of this manual for the `dfcols.list` function).





```r
# Show just the first few lines, Boolean mode
head(do.call(cbind, c(concat.test[1],
                      lapply(dfcols.list(concat.test[-1]),
                             concat.split, split.col=1, drop=TRUE, sep=";|,"))))
```

```
Error: object 'concat.split' not found
```

```r
# Show just the first few lines, value mode
head(do.call(cbind, c(concat.test[1],
                      lapply(dfcols.list(concat.test[-1]),
                             concat.split, split.col=1, drop=TRUE, 
                             sep=";|,", mode="value"))))
```

```
Error: object 'concat.split' not found
```

```r
# Show just the first few lines, list output mode
head(do.call(cbind, c(concat.test[1],
                      lapply(dfcols.list(concat.test[-1]),
                             concat.split, split.col=1, drop=TRUE, 
                             sep=";|,", to.list=TRUE))))
```

```
Error: object 'concat.split' not found
```


## References

See: [http://stackoverflow.com/q/10100887/1270695](http://stackoverflow.com/q/10100887/1270695)

\newpage
