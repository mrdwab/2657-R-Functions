



# stratified

The `stratified` function samples from a `data.frame` in which one of the columns can be used as a "stratification" or "grouping" variable. The result is a new `data.frame` with the specified number of samples from each group.

## Arguments

* `df`: The source `data.frame`.
* `group`: Your grouping variables. Generally, if you are using more than one variable to create your "strata", you should list them in the order of slowest varying to quickest varying. Can be a vector of names or column indexes.
* `size`: The desired sample size. 
    * If `size` is a value between 0 and 1 expressed as a decimal, size is set to be proportional to the number of observations per group. 
    * If `size` is a single positive integer, it will be assumed that you want the same number of samples from each group.
    * If `size` is a vector, the function will check to see whether the length of the vector matches the number of groups and use those specified values as the desired sample sizes. The values in the vector should be in the same order as you would get if you tabulated the grouping variable (usually alphabetic order); alternatively, you can name each value to ensure it is properly matched.

    > ***Note***: Because of how computers deal with floating-point arithmetic, and because R uses a "round to even" approach, the `size` per strata that results when specifying a proportionate sample may be slightly higher or lower per strata than you might have expected.

* `seed`: The seed that you want to use (using `set.seed()`), if any. Defaults to `NULL`. 

    > ***Note***: This is different from using `set.seed()` before using the function. Setting a seed using this argument is equivalent to using `set.seed(seed)` each time that you go to take a sample from a different group (in other words, the same seed is used for each group). See "*Additional Information*" for further information.
    
* `...`: Further arguments to be passed to the `sample()` function.

## Examples

First, let's make up some data. In the dataset below, we can treat variables "A" and "D" as potential grouping variables.


```r
# Generate a couple of sample data.frames to play with
set.seed(1)
dat1 <- data.frame(ID = 1:100,
                   A = sample(c("AA", "BB", "CC", "DD", "EE"), 100, replace=T),
                   B = rnorm(100), C = abs(round(rnorm(100), digits=1)),
                   D = sample(c("CA", "NY", "TX"), 100, replace=T),
                   E = sample(c("M", "F"), 100, replace=T))

dat2 <- data.frame(ID = 1:20,
                   A = c(rep("AA", 5), rep("BB", 10), 
                         rep("CC", 3), rep("DD", 2)))

# What do the data look like in general?
summary(dat1)
```

```
##        ID         A            B                 C          D      E     
##  Min.   :  1.0   AA:13   Min.   :-1.9144   Min.   :0.000   CA:23   F:54  
##  1st Qu.: 25.8   BB:25   1st Qu.:-0.6141   1st Qu.:0.300   NY:42   M:46  
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
stratified(dat1, "A", .1, seed = 1)
```

```
##    ID  A        B   C  D E
## 27 27 AA -0.44329 0.8 TX M
## 22 22 BB -0.70995 0.1 TX M
## 26 26 BB  0.29145 0.0 TX F
## 40 40 CC  0.26710 0.9 NY F
## 44 44 CC  0.70021 0.8 CA M
## 23 23 DD  0.61073 0.5 NY F
## 39 39 DD  0.37002 0.4 CA F
## 49 49 DD -1.22461 0.4 NY F
## 21 21 EE  0.47551 2.3 TX F
## 29 29 EE  0.07434 1.0 TX M
```

```r

# Let's take 5 samples from all -D- groups in dat1, 
#   seed = 1, specified by column number
stratified(dat1, group = 5, size = 5, seed = 1)
```

```
##    ID  A        B   C  D E
## 36 36 DD  0.33295 0.2 CA M
## 44 44 CC  0.70021 0.8 CA M
## 57 57 BB  0.71671 0.7 CA M
## 73 73 BB -0.21458 0.6 CA F
## 32 32 CC -0.13518 1.0 CA M
## 23 23 DD  0.61073 0.5 NY F
## 37 37 DD  1.06310 1.5 NY M
## 52 52 EE  0.04212 1.7 NY F
## 91 91 BB -1.91436 0.7 NY M
## 17 17 DD -1.80496 0.3 NY M
## 26 26 BB  0.29145 0.0 TX F
## 29 29 EE  0.07434 1.0 TX M
## 54 54 BB  0.15803 0.3 TX M
## 80 80 EE -0.32427 0.3 TX M
## 15 15 DD -0.74327 0.6 TX F
```

```r

# Let's try to take a sample from all -A- groups in dat1, seed = 1,
#   where we specify the number wanted from each group,
#   but we did not specify the correct number of groups
stratified(dat1, "A", size = c(3, 5, 7), seed = 1)
```

```
## Error: Number of groups is 5 but number of sizes supplied is 3
```

```r

# Try again
stratified(dat1, "A", size = c(3, 5, 4, 5, 2), seed = 1)
```

```
## 'size' vector entered as:
## 
## size = structure(c(3, 5, 4, 5, 2), .Names = c('AA', 'BB', 'CC', 'DD', 'EE'))
```

```
##    ID  A        B   C  D E
## 27 27 AA -0.44329 0.8 TX M
## 34 34 AA -1.52357 1.5 CA F
## 47 47 AA -1.27659 1.4 TX M
## 22 22 BB -0.70995 0.1 TX M
## 26 26 BB  0.29145 0.0 TX F
## 62 62 BB -0.46164 0.4 CA F
## 78 78 BB -0.03763 1.6 NY M
## 14 14 BB  0.02800 0.9 TX F
## 40 40 CC  0.26710 0.9 NY F
## 44 44 CC  0.70021 0.8 CA M
## 51 51 CC -0.62037 0.4 TX F
## 67 67 CC -0.31999 0.3 CA F
## 23 23 DD  0.61073 0.5 NY F
## 39 39 DD  0.37002 0.4 CA F
## 49 49 DD -1.22461 0.4 NY F
## 85 85 DD  0.30656 0.1 NY F
## 17 17 DD -1.80496 0.3 NY M
## 21 21 EE  0.47551 2.3 TX F
## 29 29 EE  0.07434 1.0 TX M
```

```r

# Use a two-column strata: -E- and -D-
#   -E- varies more slowly, so it is better to put that first
stratified(dat1, c("E", "D"), size = .15, seed = 1)
```

```
##    ID  A        B   C  D E
## 45 45 CC  1.58683 1.2 CA F
## 58 58 CC  0.91017 0.5 CA F
## 32 32 CC -0.13518 1.0 CA M
## 35 35 EE  0.59395 0.5 CA M
## 31 31 CC -0.56867 1.2 NY F
## 41 41 EE -0.54252 0.2 NY F
## 49 49 DD -1.22461 0.4 NY F
## 18 18 EE  1.46555 1.4 NY M
## 25 25 BB -1.25363 0.3 NY M
## 56 56 AA  1.76729 2.5 NY M
## 15 15 DD -0.74327 0.6 TX F
## 26 26 BB  0.29145 0.0 TX F
## 51 51 CC -0.62037 0.4 TX F
## 29 29 EE  0.07434 1.0 TX M
## 42 42 DD  1.20787 0.4 TX M
```

```r

# Use a three-column strata: -E-, -D-, and -A-
s.out <- stratified(dat1, c("E", "D", "A"), size = 2, seed = 1)
```

```
## Some groups ---F.NY.AA, M.CA.BB, M.TX.CC, F.CA.EE, M.CA.EE--- contain fewer
## observations than desired number of samples. All observations have been
## returned from those groups.
```

```r
list(head(s.out), tail(s.out))
```

```
## [[1]]
##    ID  A        B   C  D E
## 34 34 AA -1.52357 1.5 CA F
## 92 92 AA  1.17658 1.0 CA F
## 24 24 AA -0.93410 0.1 CA M
## 69 69 AA  0.49419 0.6 CA M
## 12 12 AA -0.03924 0.2 NY M
## 88 88 AA -0.52828 1.2 NY M
## 
## [[2]]
##    ID  A        B   C  D E
## 18 18 EE  1.46555 1.4 NY M
## 76 76 EE  0.71267 1.8 NY M
## 6   6 EE  1.98040 1.1 TX F
## 70 70 EE -0.17733 0.0 TX F
## 29 29 EE  0.07434 1.0 TX M
## 80 80 EE -0.32427 0.3 TX M
```

```r

# How many samples were taken from each strata?
table(interaction(s.out[c("E", "D", "A")]))
```

```
## 
## F.CA.AA M.CA.AA F.NY.AA M.NY.AA F.TX.AA M.TX.AA F.CA.BB M.CA.BB F.NY.BB M.NY.BB 
##       2       2       0       2       2       2       2       1       2       2 
## F.TX.BB M.TX.BB F.CA.CC M.CA.CC F.NY.CC M.NY.CC F.TX.CC M.TX.CC F.CA.DD M.CA.DD 
##       2       2       2       2       2       2       2       0       2       2 
## F.NY.DD M.NY.DD F.TX.DD M.TX.DD F.CA.EE M.CA.EE F.NY.EE M.NY.EE F.TX.EE M.TX.EE 
##       2       2       2       2       0       1       2       2       2       2
```

```r

# Can we verify the message about group sizes?
names(which(table(interaction(dat1[c("E", "D", "A")])) < 2))
```

```
## [1] "F.NY.AA" "M.CA.BB" "M.TX.CC" "F.CA.EE" "M.CA.EE"
```

```r
names(which(table(interaction(s.out[c("E", "D", "A")])) < 2))
```

```
## [1] "F.NY.AA" "M.CA.BB" "M.TX.CC" "F.CA.EE" "M.CA.EE"
```

```r

# Try a 10% sample from all -A- groups in dat2, seed = 1
stratified(dat2, "A", size = .1, seed = 1)
```

```
##   ID  A
## 8  8 BB
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
stratified(dat2, "A", size = ceiling(table(dat2$A) * .1), seed = 1)
```

```
##    ID  A
## 2   2 AA
## 8   8 BB
## 16 16 CC
## 19 19 DD
```


## Additional Information

### `seed`

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
stratified(dat2, "A", 2, 1)
```

```
##    ID  A
## 2   2 AA
## 5   5 AA
## 8   8 BB
## 9   9 BB
## 16 16 CC
## 18 18 CC
## 19 19 DD
## 20 20 DD
```

```r

# Now, use -set.seed()- before running the function.
set.seed(1); stratified(dat2, "A", 2)
```

```
##    ID  A
## 2   2 AA
## 5   5 AA
## 11 11 BB
## 14 14 BB
## 16 16 CC
## 17 17 CC
## 20 20 DD
## 19 19 DD
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

### `strata.sampling`

A related function, `strata.sampling()`, is a basic wrapper around the `strata()` function from the "sampling" package that allows the user to draw either a fixed size sample or proportionate sample. The `strata.sampling()` function has the advantage that it also includes a column indicating the probability for each observation being selected.

The `strata.sampling()` function is included as one of the "snippets" found under "Snippets and Tips."

## References

The evolution of this function can be found at the following URLs: 

1. [http://news.mrdwab.com/2011/05/15/stratified-random-sampling-in-r-beta/](http://news.mrdwab.com/2011/05/15/stratified-random-sampling-in-r-beta/)
1. [http://news.mrdwab.com/2011/05/20/stratified-random-sampling-in-r-from-a-data-frame/](http://news.mrdwab.com/2011/05/20/stratified-random-sampling-in-r-from-a-data-frame/)
1. [http://stackoverflow.com/a/9714207/1270695](http://stackoverflow.com/a/9714207/1270695)

The version here is entirely reworked and does not require an additional package to be loaded.

\cleardoublepage
