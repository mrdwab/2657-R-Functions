



# row.extractor

The `row.extractor` function takes a `data.frame` and extracts rows with the `min`, `median`, or `max` values of a given variable, or extracts rows with specific quantiles of a given variable.

## Arguments

* `data`: the source `data.frame`.
* `extract.by`: the column which will be used as the reference for extraction; can be specified either by the column number or the variable name.
* `what`: options are `min` (for all rows matching the minimum value), `median` (for the median row or rows), `max` (for all rows matching the maximum value), or `all` (for `min`, `median`, and `max`); alternatively, a numeric vector can be specified with the desired quantiles, for instance `c(0, .25, .5, .75, 1)`

## Examples


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/row.extractor.R"))))

# Make up some data
set.seed(1)
dat = data.frame(V1 = 1:50, V2 = rnorm(50), 
                 V3 = round(abs(rnorm(50)), digits=2), 
                 V4 = sample(1:30, 50, replace=TRUE))
# Get a sumary of the data
summary(dat)
```

```
       V1             V2               V3              V4       
 Min.   : 1.0   Min.   :-2.215   Min.   :0.000   Min.   : 2.00  
 1st Qu.:13.2   1st Qu.:-0.372   1st Qu.:0.347   1st Qu.: 8.25  
 Median :25.5   Median : 0.129   Median :0.590   Median :13.00  
 Mean   :25.5   Mean   : 0.100   Mean   :0.774   Mean   :14.80  
 3rd Qu.:37.8   3rd Qu.: 0.728   3rd Qu.:1.175   3rd Qu.:20.75  
 Max.   :50.0   Max.   : 1.595   Max.   :2.400   Max.   :29.00  
```

```r
# Get the rows corresponding to the 'min', 'median', and 'max' of 'V4'
row.extractor(dat, 4) 
```

```
   V1      V2   V3 V4
28 28 -1.4708 0.00  2
47 47  0.3646 1.28 13
29 29 -0.4782 0.07 13
11 11  1.5118 2.40 29
14 14 -2.2147 0.03 29
18 18  0.9438 1.47 29
19 19  0.8212 0.15 29
50 50  0.8811 0.47 29
```

```r
# Get the 'min' rows only, referenced by the variable name
row.extractor(dat, "V4", "min") 
```

```
   V1     V2 V3 V4
28 28 -1.471  0  2
```

```r
# Get the 'median' rows only. Notice that there are two rows 
#    since we have an even number of cases and true median 
#    is the mean of the two central sorted values
row.extractor(dat, "V4", "median") 
```

```
   V1      V2   V3 V4
47 47  0.3646 1.28 13
29 29 -0.4782 0.07 13
```

```r
# Get the rows corresponding to the deciles of 'V3'
row.extractor(dat, "V3", seq(0.1, 1, 0.1)) 
```

```
   V1       V2   V3 V4
10 10 -0.30539 0.14 22
26 26 -0.05613 0.29 16
39 39  1.10003 0.37 13
41 41 -0.16452 0.54 10
30 30  0.41794 0.59 26
44 44  0.55666 0.70  5
37 37 -0.39429 1.06 21
49 49 -0.11235 1.22 14
34 34 -0.05381 1.52 19
11 11  1.51178 2.40 29
```


## To Do

* Add some error checking to make sure a valid `what` is provided.

## References

`which.quantile` function by [cbeleites](http://stackoverflow.com/users/755257/cbeleites)  
See: [http://stackoverflow.com/q/10256503/1270695](http://stackoverflow.com/q/10256503/1270695)

\cleardoublepage
