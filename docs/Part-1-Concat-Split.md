



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

# Split up the second column, selecting by column number
head(concat.split(concat.test, 2))
```

```
    Name     Likes                   Siblings    Hates Likes_1 Likes_2 Likes_3
1   Boyd 1,2,4,5,6 Reynolds , Albert , Ortega     2;4;       1       1      NA
2  Rufus 1,2,4,5,6  Cohen , Bert , Montgomery 1;2;3;4;       1       1      NA
3   Dana 1,2,4,5,6                     Pierce       2;       1       1      NA
4 Carole 1,2,4,5,6 Colon , Michelle , Ballard     1;4;       1       1      NA
5 Ramona   1,2,5,6           Snyder , Joann ,   1;2;3;       1       1      NA
6 Kelley   1,2,5,6          James , Roxanne ,     1;4;       1       1      NA
  Likes_4 Likes_5 Likes_6
1       1       1       1
2       1       1       1
3       1       1       1
4       1       1       1
5      NA       1       1
6      NA       1       1
```

```r
# ... or by name, and drop the offensive first column
head(concat.split(concat.test, "Likes", drop.col=TRUE))
```

```
    Name                   Siblings    Hates Likes_1 Likes_2 Likes_3 Likes_4
1   Boyd Reynolds , Albert , Ortega     2;4;       1       1      NA       1
2  Rufus  Cohen , Bert , Montgomery 1;2;3;4;       1       1      NA       1
3   Dana                     Pierce       2;       1       1      NA       1
4 Carole Colon , Michelle , Ballard     1;4;       1       1      NA       1
5 Ramona           Snyder , Joann ,   1;2;3;       1       1      NA      NA
6 Kelley          James , Roxanne ,     1;4;       1       1      NA      NA
  Likes_5 Likes_6
1       1       1
2       1       1
3       1       1
4       1       1
5       1       1
6       1       1
```

```r
# The "Hates" column uses a different separator:
head(concat.split(concat.test, "Hates", sep=";", drop.col=TRUE))
```

```
    Name     Likes                   Siblings Hates_1 Hates_2 Hates_3 Hates_4
1   Boyd 1,2,4,5,6 Reynolds , Albert , Ortega      NA       1      NA       1
2  Rufus 1,2,4,5,6  Cohen , Bert , Montgomery       1       1       1       1
3   Dana 1,2,4,5,6                     Pierce      NA       1      NA      NA
4 Carole 1,2,4,5,6 Colon , Michelle , Ballard       1      NA      NA       1
5 Ramona   1,2,5,6           Snyder , Joann ,       1       1       1      NA
6 Kelley   1,2,5,6          James , Roxanne ,       1      NA      NA       1
```

```r
# Retain the original values
head(concat.split(concat.test, 2, mode="value", drop.col=TRUE))
```

```
    Name                   Siblings    Hates Likes_1 Likes_2 Likes_3 Likes_4
1   Boyd Reynolds , Albert , Ortega     2;4;       1       2      NA       4
2  Rufus  Cohen , Bert , Montgomery 1;2;3;4;       1       2      NA       4
3   Dana                     Pierce       2;       1       2      NA       4
4 Carole Colon , Michelle , Ballard     1;4;       1       2      NA       4
5 Ramona           Snyder , Joann ,   1;2;3;       1       2      NA      NA
6 Kelley          James , Roxanne ,     1;4;       1       2      NA      NA
  Likes_5 Likes_6
1       5       6
2       5       6
3       5       6
4       5       6
5       5       6
6       5       6
```

```r
# Let's try splitting some strings... Same syntax
head(concat.split(concat.test, 3, drop.col=TRUE))
```

```
    Name     Likes    Hates Siblings_1 Siblings_2 Siblings_3
1   Boyd 1,2,4,5,6     2;4;   Reynolds     Albert     Ortega
2  Rufus 1,2,4,5,6 1;2;3;4;      Cohen       Bert Montgomery
3   Dana 1,2,4,5,6       2;     Pierce       <NA>       <NA>
4 Carole 1,2,4,5,6     1;4;      Colon   Michelle    Ballard
5 Ramona   1,2,5,6   1;2;3;     Snyder      Joann       <NA>
6 Kelley   1,2,5,6     1;4;      James    Roxanne       <NA>
```

```r
# Split up the "Likes column" into a list variable; retain original column
head(concat.split(concat.test, 2, to.list=TRUE, drop.col=FALSE))
```

```
    Name     Likes                   Siblings    Hates    Likes_list
1   Boyd 1,2,4,5,6 Reynolds , Albert , Ortega     2;4; 1, 2, 4, 5, 6
2  Rufus 1,2,4,5,6  Cohen , Bert , Montgomery 1;2;3;4; 1, 2, 4, 5, 6
3   Dana 1,2,4,5,6                     Pierce       2; 1, 2, 4, 5, 6
4 Carole 1,2,4,5,6 Colon , Michelle , Ballard     1;4; 1, 2, 4, 5, 6
5 Ramona   1,2,5,6           Snyder , Joann ,   1;2;3;    1, 2, 5, 6
6 Kelley   1,2,5,6          James , Roxanne ,     1;4;    1, 2, 5, 6
```

```r
# View the structure of the output for the first 10 rows to verify 
# that the new column is a list; note the difference between "Likes"
# and "Likes_list".
str(concat.split(concat.test, 2, to.list=TRUE, drop.col=FALSE)[1:10, c(2, 5)])
```

```
'data.frame':	10 obs. of  2 variables:
 $ Likes     : Factor w/ 5 levels "1,2,3,4,5","1,2,4,5",..: 3 3 3 3 5 5 3 3 3 4
 $ Likes_list:List of 10
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 5 6
  ..$ : num  1 2 5 6
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 4 5 6
  ..$ : num  1 2 5
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
    Name Likes_1 Likes_2 Likes_3 Likes_4 Likes_5 Likes_6 Siblings_1 Siblings_2
1   Boyd       1       1      NA       1       1       1   Reynolds     Albert
2  Rufus       1       1      NA       1       1       1      Cohen       Bert
3   Dana       1       1      NA       1       1       1     Pierce       <NA>
4 Carole       1       1      NA       1       1       1      Colon   Michelle
5 Ramona       1       1      NA      NA       1       1     Snyder      Joann
6 Kelley       1       1      NA      NA       1       1      James    Roxanne
  Siblings_3 Hates_1 Hates_2 Hates_3 Hates_4
1     Ortega      NA       1      NA       1
2 Montgomery       1       1       1       1
3       <NA>      NA       1      NA      NA
4    Ballard       1      NA      NA       1
5       <NA>       1       1       1      NA
6       <NA>       1      NA      NA       1
```

```r
# Show just the first few lines, value mode
head(do.call(cbind, c(concat.test[1],
                      lapply(dfcols.list(concat.test[-1]),
                             concat.split, split.col=1, drop=TRUE, 
                             sep=";|,", mode="value"))))
```

```
    Name Likes_1 Likes_2 Likes_3 Likes_4 Likes_5 Likes_6 Siblings_1 Siblings_2
1   Boyd       1       2      NA       4       5       6   Reynolds     Albert
2  Rufus       1       2      NA       4       5       6      Cohen       Bert
3   Dana       1       2      NA       4       5       6     Pierce       <NA>
4 Carole       1       2      NA       4       5       6      Colon   Michelle
5 Ramona       1       2      NA      NA       5       6     Snyder      Joann
6 Kelley       1       2      NA      NA       5       6      James    Roxanne
  Siblings_3 Hates_1 Hates_2 Hates_3 Hates_4
1     Ortega      NA       2      NA       4
2 Montgomery       1       2       3       4
3       <NA>      NA       2      NA      NA
4    Ballard       1      NA      NA       4
5       <NA>       1       2       3      NA
6       <NA>       1      NA      NA       4
```

```r
# Show just the first few lines, list output mode
head(do.call(cbind, c(concat.test[1],
                      lapply(dfcols.list(concat.test[-1]),
                             concat.split, split.col=1, drop=TRUE, 
                             sep=";|,", to.list=TRUE))))
```

```
    Name    Likes_list            Siblings_list Hates_list
1   Boyd 1, 2, 4, 5, 6 Reynolds, Albert, Ortega       2, 4
2  Rufus 1, 2, 4, 5, 6  Cohen, Bert, Montgomery 1, 2, 3, 4
3   Dana 1, 2, 4, 5, 6                   Pierce          2
4 Carole 1, 2, 4, 5, 6 Colon, Michelle, Ballard       1, 4
5 Ramona    1, 2, 5, 6            Snyder, Joann    1, 2, 3
6 Kelley    1, 2, 5, 6           James, Roxanne       1, 4
```


## References

See: [http://stackoverflow.com/q/10100887/1270695](http://stackoverflow.com/q/10100887/1270695)

\newpage
