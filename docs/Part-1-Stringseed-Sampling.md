



# stringseed.sampling

The `stringseed.sampling` function is designed as a batch sampling function that allows the user to specify any alphanumeric input as the seed *per sample in the batch*.

## Arguments

* `seedbase`: A vector of seeds to be used for sampling.
* `N`: The "population" from which to draw the sample.
* `n`: The desired number of samples.
* `write.output`: Logical. Should the output be written to a file? Defaults to `FALSE`. If `TRUE`, a csv file is written with the sample "metadata", and a plain text file is written with the details of the resulting sample. The names of the files written are "`Sample frame generated on {date the script was run} .csv`" and "`Samples generated on {date the script was run} .txt`" and will be found in your current working directory.

## Examples


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/stringseed.sampling.R"))))
# We'll use a data.frame with a list of village names, the population,
#   and the desired samples as our columns. The function will use the 
#   village names to generate a unique seed for each village before
#   drawing the sample.
myListOfPlaces <- data.frame(
  villageName = c("Melakkal", "Sholavandan", "T. Malaipatti"),
  population = c(120, 130, 140),
  requiredSample = c(30, 25, 12))
myListOfPlaces
```

```
##     villageName population requiredSample
## 1      Melakkal        120             30
## 2   Sholavandan        130             25
## 3 T. Malaipatti        140             12
```

```r
stringseed.sampling(seedbase = myListOfPlaces$villageName,
                    N = myListOfPlaces$population,
                    n = myListOfPlaces$requiredSample)
```

```
## $input
##        seedbase populations samplesizes      seeds
## 1      Melakkal         120          30 1331891848
## 2   Sholavandan         130          25  438637044
## 3 T. Malaipatti         140          12 1614276325
## 
## $samples
## $samples$Melakkal
##  [1] 108  13  54  96  56 111 110  27 112  84  60  62  22  12  23 117  93  67  79
## [20]  74  65  90  71 113  53  85  40  19  31  18
## 
## $samples$Sholavandan
##  [1]  94  14  27  96 102  11  47  18 118  91 120  57  40  89   5 105 116  70 109
## [20]  35  16  90   4  98  30
## 
## $samples$`T. Malaipatti`
##  [1] 130 102  20 123  85 104   5 105   7 115  96 120
```

```r
# Manual verification of the samples generated for Melakkal village
#   (for which the automatically generated seed was 1331891848)
set.seed(1331891848)
sample(120, 30)
```

```
##  [1] 108  13  54  96  56 111 110  27 112  84  60  62  22  12  23 117  93  67  79
## [20]  74  65  90  71 113  53  85  40  19  31  18
```

```r

# What about using the function on a single input?
stringseed.sampling("Santa Barbara", 1920, 100)
```

```
## $input
##        seedbase populations samplesizes     seeds
## 1 Santa Barbara        1920         100 323728098
## 
## $samples
##   [1]  129 1869 1170  192  344   18  694 1628  601  874  188  631 1910  605  367
##  [16] 1411  755 1741  489  658  821 1160 1783  150 1556  423  753  416 1510  707
##  [31] 1353 1744  520 1720 1608  990 1235  402 1669 1800  502 1516 1531 1860 1369
##  [46] 1431 1570 1290 1731 1679 1070  931   68 1466 1836  316  815   24 1877 1689
##  [61] 1141  981  279 1605  842 1773 1186 1081   17  661 1104 1668 1180   54 1233
##  [76] 1879 1666  449  838 1167 1157  773 1707  916 1243  492  525 1308 1460  232
##  [91] 1695 1644 1312 1051 1325  545  397 1551  477 1205
```


## References

Ben Bolker[^benbolker] recommended the use of the "digest" package to convert a string to a numeric value.\
See: [http://stackoverflow.com/q/10910698/1270695](http://stackoverflow.com/q/10910698/1270695).

[^benbolker]: Website: [http://www.math.mcmaster.ca/\~bolker](http://www.math.mcmaster.ca/\~bolker); Stack Overflow profile: [http://stackoverflow.com/users/190277/ben-bolker](http://stackoverflow.com/users/190277/ben-bolker).
