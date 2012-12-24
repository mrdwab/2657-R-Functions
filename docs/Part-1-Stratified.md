



# stratified

The `stratified` function samples from a `data.frame` in which one of the columns represents an "identifier" variable and one of the columns represents a "stratification" or "grouping" variable. The result is a new `data.frame` with the specified number of samples from each group.

## Arguments

* `df`: The source `data.frame`.
* `id`: Your "ID" variable.
* `group`: Your grouping variable.
* `size`: The desired sample size. If `size` is a decimal, a proportionate sample would be drawn. If `size` is a positive integer, it will be assumed that you want the same number of samples from each group.

    > ***Note***: Because of how computers deal with floating-point arithmetic, and because R uses a "round to even" approach, the `size` per strata that results when specifying a proportionate sample may be slightly higher or lower per strata than you might have expected.

* `seed`: The seed that you want to use (using `set.seed()`), if any. Defaults to `NULL`. 

    > ***Note***: This is different from using `set.seed()` before using the function. This method uses the same seed before sampling from each group. 
    
* `...`: Further arguments to be passed to the `sample()` function.

## Examples

First, let's make up some data. In the dataset below, we can treat variables "A" and "D" as potential grouping variables.


```r
# Generate some sample data to play with
set.seed(1)
dat = data.frame(ID = 1:100, 
                 A = sample(c("AA", "BB", "CC", "DD", "EE"), 100, replace=T),
                 B = rnorm(100), C = abs(round(rnorm(100), digits=1)),
                 D = sample(c("CA", "NY", "TX"), 100, replace=T))

# What do the data look like in general?
summary(dat)
```

```
##        ID         A            B                 C          D     
##  Min.   :  1.0   AA:13   Min.   :-1.9144   Min.   :0.000   CA:23  
##  1st Qu.: 25.8   BB:25   1st Qu.:-0.6141   1st Qu.:0.300   NY:42  
##  Median : 50.5   CC:19   Median :-0.1176   Median :0.650   TX:35  
##  Mean   : 50.5   DD:26   Mean   :-0.0176   Mean   :0.825          
##  3rd Qu.: 75.2   EE:17   3rd Qu.: 0.5382   3rd Qu.:1.200          
##  Max.   :100.0           Max.   : 2.4016   Max.   :2.900
```


Now, let's try different settings applying the `stratified` function.


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/stratified.R"))))

# Let's take a 10% sample from all -A- groups, seed = 1
stratified(dat, "ID", "A", .1, seed = 1)
```

```
##    ID  A        B   C  D
## 5  27 AA -0.44329 0.8 TX
## 2  22 BB -0.70995 0.1 TX
## 4  26 BB  0.29145 0.0 TX
## 8  40 CC  0.26710 0.9 NY
## 9  44 CC  0.70021 0.8 CA
## 3  23 DD  0.61073 0.5 NY
## 7  39 DD  0.37002 0.4 CA
## 10 49 DD -1.22461 0.4 NY
## 1  21 EE  0.47551 2.3 TX
## 6  29 EE  0.07434 1.0 TX
```

```r

# Let's take 5 samples from all -D- groups, seed = 1, specified by column number
stratified(dat, 1, 5, 5, 1)
```

```
##    ID  A        B   C  D
## 6  32 CC -0.13518 1.0 CA
## 7  36 DD  0.33295 0.2 CA
## 9  44 CC  0.70021 0.8 CA
## 12 57 BB  0.71671 0.7 CA
## 13 73 BB -0.21458 0.6 CA
## 2  17 DD -1.80496 0.3 NY
## 3  23 DD  0.61073 0.5 NY
## 8  37 DD  1.06310 1.5 NY
## 10 52 EE  0.04212 1.7 NY
## 15 91 BB -1.91436 0.7 NY
## 1  15 DD -0.74327 0.6 TX
## 4  26 BB  0.29145 0.0 TX
## 5  29 EE  0.07434 1.0 TX
## 11 54 BB  0.15803 0.3 TX
## 14 80 EE -0.32427 0.3 TX
```


## To Do

* Error handling for when fixed sample size is specified but some strata have fewer observations than specified sample size.
* Option to specify vector of required samples

## References

The evolution of this function can be found at the following URLs: 

1. [http://news.mrdwab.com/2011/05/15/stratified-random-sampling-in-r-beta/](http://news.mrdwab.com/2011/05/15/stratified-random-sampling-in-r-beta/)
1. [http://news.mrdwab.com/2011/05/20/stratified-random-sampling-in-r-from-a-data-frame/](http://news.mrdwab.com/2011/05/20/stratified-random-sampling-in-r-from-a-data-frame/)
1. [http://stackoverflow.com/a/9714207/1270695](http://stackoverflow.com/a/9714207/1270695)

The version here is entirely reworked and does not require an additional package to be loaded.

\cleardoublepage
