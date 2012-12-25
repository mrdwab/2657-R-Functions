



# stratified

The `stratified` function samples from a `data.frame` in which one of the columns represents an "identifier" variable and one of the columns represents a "stratification" or "grouping" variable. The result is a new `data.frame` with the specified number of samples from each group.

## Arguments

* `df`: The source `data.frame`.
* `id`: Your "ID" variable.
* `group`: Your grouping variable.
* `size`: The desired sample size. 
    * If `size` is a value between 0 and 1 expressed as a decimal, size is set to be proportional to the number of observations per group. 
    * If `size` is a single positive integer, it will be assumed that you want the same number of samples from each group.
    * If `size` is a vector, the function will check to see whether the length of the vector matches the number of groups and use those specified values as the desired sample sizes. The values in the vector should be in the same order as you would get if you tabulated the grouping variable (usually alphabetic order); alternatively, you can name each value to ensure it is properly matched.

    > ***Note***: Because of how computers deal with floating-point arithmetic, and because R uses a "round to even" approach, the `size` per strata that results when specifying a proportionate sample may be slightly higher or lower per strata than you might have expected.

* `seed`: The seed that you want to use (using `set.seed()`), if any. Defaults to `NULL`. 

    > ***Note***: This is different from using `set.seed()` before using the function. Setting a seed using this argument is equivalent to using `set.seed(seed)` each time that you go to take a sample from a different group (in other words, the same seed is used for each group). See "Additional Information".
    
* `...`: Further arguments to be passed to the `sample()` function.

## Examples

First, let's make up some data. In the dataset below, we can treat variables "A" and "D" as potential grouping variables.


```r
# Generate a couple of sample data.frames to play with
set.seed(1)
dat1 <- data.frame(ID = 1:100,
                   A = sample(c("AA", "BB", "CC", "DD", "EE"), 100, replace=T),
                   B = rnorm(100), C = abs(round(rnorm(100), digits=1)),
                   D = sample(c("CA", "NY", "TX"), 100, replace=T))

dat2 <- data.frame(ID = 1:20,
                   A = c(rep("AA", 5), rep("BB", 10), 
                         rep("CC", 3), rep("DD", 2)))

# What do the data look like in general?
summary(dat1)
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

```r
summary(dat2)
```

```
##        ID         A     
##  Min.   : 1.00   AA: 5  
##  1st Qu.: 5.75   BB:10  
##  Median :10.50   CC: 3  
##  Mean   :10.50   DD: 2  
##  3rd Qu.:15.25          
##  Max.   :20.00
```


Now, let's try different settings applying the `stratified` function.


```r
# Load the function!
require(RCurl)
```

```
## Loading required package: RCurl
```

```
## Loading required package: bitops
```

```r
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/stratified.R"))))

# Let's take a 10% sample from all -A- groups in dat1, seed = 1
stratified(dat1, "ID", "A", .1, seed = 1)
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

# Let's take 5 samples from all -D- groups in dat1, 
#   seed = 1, specified by column number
stratified(dat1, 1, 5, 5, 1)
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

```r

# Let's try to take a sample from all -A- groups in dat1, seed = 1,
#   where we specify the number wanted from each group--but make a mistake
stratified(dat1, "ID", "A", size = c(3, 5, 7), seed = 1)
```

```
## Error: Number of groups is 5 but number of sizes supplied is 3
```

```r

# Try again
stratified(dat1, "ID", "A", size = c(3, 5, 4, 5, 2), seed = 1)
```

```
## 'size' vector entered as:
## 
## size = structure(c(3, 5, 4, 5, 2), .Names = c('AA', 'BB', 'CC', 'DD', 'EE'))
```

```
##    ID  A        B   C  D
## 7  27 AA -0.44329 0.8 TX
## 9  34 AA -1.52357 1.5 CA
## 13 47 AA -1.27659 1.4 TX
## 1  14 BB  0.02800 0.9 TX
## 4  22 BB -0.70995 0.1 TX
## 6  26 BB  0.29145 0.0 TX
## 16 62 BB -0.46164 0.4 CA
## 18 78 BB -0.03763 1.6 NY
## 11 40 CC  0.26710 0.9 NY
## 12 44 CC  0.70021 0.8 CA
## 15 51 CC -0.62037 0.4 TX
## 17 67 CC -0.31999 0.3 CA
## 2  17 DD -1.80496 0.3 NY
## 5  23 DD  0.61073 0.5 NY
## 10 39 DD  0.37002 0.4 CA
## 14 49 DD -1.22461 0.4 NY
## 19 85 DD  0.30656 0.1 NY
## 3  21 EE  0.47551 2.3 TX
## 8  29 EE  0.07434 1.0 TX
```

```r

# Try a 10% sample from all -A- groups in dat2, seed = 1
stratified(dat2, "ID", "A", size = .1, seed = 1)
```

```
##   ID  A
## 1  8 BB
```

```r

# How does that compare to -table(dat2$A) * .1)-?
table(dat2$A) * .1
```

```
## 
##  AA  BB  CC  DD 
## 0.5 1.0 0.3 0.2
```

```r

# Instead of -round()- you can use -floor()- or -ceiling()- to
#   round down or up to an integer
stratified(dat2, "ID", "A", size = ceiling(table(dat2$A) * .1), seed = 1)
```

```
##   ID  A
## 3  2 AA
## 4  8 BB
## 1 16 CC
## 2 19 DD
```


## Additional Information

The inclusion of a `seed` argument is mostly a matter of convenience, to be able to have a single seed with which the samples can be verified later. However, by using the `seed` argument, *the same seed is used to sample from each group*. This may be a problem if there are many groups that have the same number of observations, since it means that the same observation number will be selected from each of those grops. For instance, if group "AA" and "DD" both had the same number of observations (say, 5) and you were using a `seed` of 1, the second, fifth, and fourth observation would be taken from each of those groups. To avoid this, you can set the seed using `set.seed()` before you run the function.

The following examples should demonstrate the difference between the two approaches.


```r
# Let's manually split the dataset and sample 2 from each group, seed = 1
(seedy.demonstration <- split(dat2$ID, dat2$A))
```

```
## $AA
## [1] 1 2 3 4 5
## 
## $BB
##  [1]  6  7  8  9 10 11 12 13 14 15
## 
## $CC
## [1] 16 17 18
## 
## $DD
## [1] 19 20
```

```r
set.seed(1); sample(seedy.demonstration$AA, 2)
```

```
## [1] 2 5
```

```r
set.seed(1); sample(seedy.demonstration$BB, 2)
```

```
## [1] 8 9
```

```r
set.seed(1); sample(seedy.demonstration$CC, 2)
```

```
## [1] 16 18
```

```r
set.seed(1); sample(seedy.demonstration$DD, 2)
```

```
## [1] 19 20
```

```r

# Now do the same with the stratified function. 
#   Note that the IDs are the same as we got manually.
stratified(dat2, "ID", "A", 2, 1)
```

```
##   ID  A
## 5  2 AA
## 6  5 AA
## 7  8 BB
## 8  9 BB
## 1 16 CC
## 2 18 CC
## 3 19 DD
## 4 20 DD
```

```r

# Now, use -set.seed()- before running the function.
set.seed(1); stratified(dat2, "ID", "A", 2)
```

```
##   ID  A
## 7  2 AA
## 8  5 AA
## 1 11 BB
## 2 14 BB
## 3 16 CC
## 4 17 CC
## 5 19 DD
## 6 20 DD
```

```r

# And the same manually...
set.seed(1)
sample(seedy.demonstration$AA, 2)
```

```
## [1] 2 5
```

```r
sample(seedy.demonstration$BB, 2)
```

```
## [1] 11 14
```

```r
sample(seedy.demonstration$CC, 2)
```

```
## [1] 16 17
```

```r
sample(seedy.demonstration$DD, 2)
```

```
## [1] 20 19
```

```r

# OK. So far so good. But what about if we do something else involving 
#   random number generation during our interactive session?
set.seed(1)
sample(seedy.demonstration$AA, 2) # This matches....
```

```
## [1] 2 5
```

```r
rnorm(1)                          # This involves random number generation....
```

```
## [1] 0.1836
```

```r
sample(seedy.demonstration$BB, 2) # Things go out of order now....
```

```
## [1]  8 14
```

```r

# Or, let's try the same, but sampling in a different order.
set.seed(1)
sample(seedy.demonstration$CC, 2) # Already, no match....
```

```
## [1] 16 18
```


As a user, you need to weigh the benefits and drawbacks of setting the seed *before* running the function as opposed to setting the seed *with* the function. Setting the seed *before* would be useful if there are several groups with the same number of observations; however, in the slim chance that you need to verify the samples manually, you *may* run into problems. 

## References

The evolution of this function can be found at the following URLs: 

1. [http://news.mrdwab.com/2011/05/15/stratified-random-sampling-in-r-beta/](http://news.mrdwab.com/2011/05/15/stratified-random-sampling-in-r-beta/)
1. [http://news.mrdwab.com/2011/05/20/stratified-random-sampling-in-r-from-a-data-frame/](http://news.mrdwab.com/2011/05/20/stratified-random-sampling-in-r-from-a-data-frame/)
1. [http://stackoverflow.com/a/9714207/1270695](http://stackoverflow.com/a/9714207/1270695)

The version here is entirely reworked and does not require an additional package to be loaded.

\cleardoublepage
