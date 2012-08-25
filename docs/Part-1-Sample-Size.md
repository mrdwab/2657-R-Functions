



# sample.size

The `sample.size` function either calculates the optimum survey sample size when provided with a population size, or the confidence interval of using a certain sample size with a given population. It can be used to generate tables (`data.frame`s) of different combinations of inputs of the following arguments, which can be useful for showing the effect of each of these in sample size calculation.

## The Arguments

* `population`: The population size for which a sample size needs to be calculated.
* `samp.size`: The sample size. 
    * This argument is only used when calculating the confidence interval, and defaults to `NULL`.
* `c.lev`: The desired confidence level. Defaults to a reasonable 95%.
* `c.int`: The confidence interval.
    * This argument is only used when calculating the sample size.
    * If not specified when calculating the sample size, defaults to 5% and a message is provided indicating this; this is also the default action if `c.int = NULL`.
* `what`: Should the function calculate the desired sample size or the confidence interval?
    * Accepted values are `"sample"` and `"confidence"` (quoted), and defaults to "`sample`".
* `distribution`: Response distribution. Defaults to 50%, which will give you the largest sample size. 

## Examples


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/sample.size.R"))))
# What should our sample size be for a population of 300?
# All defaults accepted.
sample.size(population = 300)
```

```
  population conf.level conf.int distribution sample.size
1        300         95        5           50         169
```

```r
# What sample should we take for a population of 300
#   at a confidence level of 97%?
sample.size(population = 300, c.lev = 97)
```

```
  population conf.level conf.int distribution sample.size
1        300         97        5           50         183
```

```r
# What about if we change our confidence interval?
sample.size(population = 300, c.int = 2.5, what = "sample")
```

```
  population conf.level conf.int distribution sample.size
1        300         95      2.5           50         251
```

```r
# What about if we want to determine the confidence interval
#   of a sample of 140 from a population of 300? A confidence
#   level of 95% is assumed.
sample.size(population = 300, samp.size = 140, what = "confidence")
```

```
  population conf.level conf.int distribution sample.size
1        300         95     6.06           50         140
```


## Advanced Usage

As the function is vectorized, it is possible to easily make tables with multiple scenarios.


```r
# What should the sample be for populations of 300 to 500 by 50?
sample.size(population=c(300, 350, 400, 450, 500))
```

```
  population conf.level conf.int distribution sample.size
1        300         95        5           50         169
2        350         95        5           50         183
3        400         95        5           50         196
4        450         95        5           50         207
5        500         95        5           50         217
```

```r
# How does varying confidence levels or confidence intervals
#   affect the sample size?
sample.size(population=300, 
            c.lev=rep(c(95, 96, 97, 98, 99), times = 3),
            c.int=rep(c(2.5, 5, 10), each=5))
```

```
   population conf.level conf.int distribution sample.size
1         300         95      2.5           50         251
2         300         96      2.5           50         255
3         300         97      2.5           50         259
4         300         98      2.5           50         264
5         300         99      2.5           50         270
6         300         95      5.0           50         169
7         300         96      5.0           50         176
8         300         97      5.0           50         183
9         300         98      5.0           50         193
10        300         99      5.0           50         207
11        300         95     10.0           50          73
12        300         96     10.0           50          78
13        300         97     10.0           50          85
14        300         98     10.0           50          93
15        300         99     10.0           50         107
```

```r
# What is are the confidence intervals for a sample of
#   150, 160, and 170 from a population of 300?
sample.size(population=300, 
            samp.size = c(150, 160, 170), 
            what="confidence")
```

```
  population conf.level conf.int distribution sample.size
1        300         95     5.67           50         150
2        300         95     5.30           50         160
3        300         95     4.96           50         170
```


Note that the use of `rep()` is required in constructing the arguments for the advanced usage examples where more than one argument takes on multiple values.

## References

See the *2657 Productions News* site for how this function progressively developed^[[http://news.mrdwab.com/2010/09/10/a-sample-size-calculator-function-for-r/](http://news.mrdwab.com/2010/09/10/a-sample-size-calculator-function-for-r/)]. The `sample.size` function is based on the following formulas^[See: Creative Research Systems. (n.d.). *Sample size formulas for our sample size calculator*. Retrieved from: [http://www.surveysystem.com/sample-size-formula.htm](http://www.surveysystem.com/sample-size-formula.htm). Archived on 07 August 2012 at [http://www.webcitation.org/69kNjMuKe](http://www.webcitation.org/69kNjMuKe).]:

$$
\large 
\begin{array}{rcl}
ss &=& \frac{-Z^2\times p\times(1-p)}{c^2} \\ \\
pss &=& \frac{ss}{1+\frac{ss-1}{pop}}
\end{array}
$$

\newpage
