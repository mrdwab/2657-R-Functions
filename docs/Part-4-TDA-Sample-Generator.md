
\appendix

# Sample Generator for Students at the Tata-Dhan Academy

> **Abstract**: This note^[This concept note was written on 24 December 2012 by Ananda Mahto and relates to V1.1 of the `TDASample()` function. Please consider using the `stringseed.basic()` function (which may be more up-to-date) or the `stringseed.sampling()` function (which uses a more robust method for generating seeds). Both can be found at the [2657-R-Functions Github page](https://github.com/mrdwab/2657-R-Functions): [https://github.com/mrdwab/2657-R-Functions](https://github.com/mrdwab/2657-R-Functions).] describes a function written to assist students at the Tata-Dhan Academy to generate random samples in a systematic and reproducible (and, thus, verifiable) manner. A common method for reproducible random samples is to use the *seed* function available in major statistics and data analysis software packages. To minimize researcher bias, even the choice of seed must be justified. The function described in this note obfuscates the seed setting process but still results in output that is reproducible. Furthermore, the seed used for generating the sample is included in the output to allow others to independently validate the results.




Many times, students need to do a pretty straightforward task of taking a random sample of households from a given village to complete their study. There are a lot of random number generators available. For instance, most scientific calculators have a feature to generate random numbers, spreadsheets often have a `RAND()` function, and student statistics or research textbooks may have a random table in their appendix. However, none of these methods are verifiable or reproducible.^[It may seem counter-intuitive to want to reproduce a *random* sequence, but this is sometimes important in research settings. It is not uncommon to hear, for example, a question like "How did you 'randomly' select your sample?"] 

Common statistics and data analysis software (for example SPSS, Stata, and R) use the concept of a `seed` with their random number generator. These packages have their own methods for automatically setting a seed so that there are different numbers each time a function that uses a random number generator is run; this number is not readily visible to the end user. Most professional packages will also allow the user to specify the seed, in case they want to make their result reproducible, for instance if they want to share their scripts with another user to verify the output.

Following is a simple example of where using a seed is useful. Using R, we are going to draw a sample of 10 from a population of 50 twice. You'll note that the resulting samples are different. After that, we will set the seed (arbitrarily) to `1` and repeat the exercise.


```r
sample(50, 10)
```

```
##  [1] 30 35 22 46  5 37 49 31 47 15
```

```r
sample(50, 10)
```

```
##  [1] 41 35 33 47 44  8 43 37  1 34
```

```r
set.seed(1)
sample(50, 10)
```

```
##  [1] 14 19 28 43 10 41 42 29 27  3
```

```r
set.seed(1)
sample(50, 10)
```

```
##  [1] 14 19 28 43 10 41 42 29 27  3
```


As can be seen, by using the `set.seed()` function in R, you are able to generate a verifiable sample. 

Since there is a choice (in other words, user decision) in selecting a seed, you do still run the risk of introducing bias. An investigator who wants household 46 to be a part of their sample might, for instance, try different seeds until they get a sample that includes 46 in its selection (in this case, `set.seed(3); sample(50, 10)` would include household 46). Also, some people are simply confused by the concept of a seed and do not really want to think about what it is or why it is necessary.

Most of the students at the Tata-Dhan Academy conduct several participatory rural appraisals before getting into more traditional research methods. Of these varied methods, it is expected that the "*social mapping*" exercise would assist them in any subsequent sampling exercises they may need to do for their study. After completing a social mapping exercise, students are generally able to provide a list something like the following:

         Household_ID   Head_of_Household
        -------------   -------------------
                    1   A Umarani
                    2   LB Rajkumar
                    3   Damodar Jena
                  ...   ...
                  ...   ...
                  118   Madhan Kumar
                  119   Ananda Mahto
                  120   JAN Vijayabharathi

The sampling function presented in this note makes use of this information to help students generate a reproducible random (non-stratified) sample (without replacement) of all the households without having to think about what an appropriate seed would be. The envisaged usage is that the student would enter a string, the population size they are sampling from, and the desired number of samples. The string can be anything, but for the case of reproducible analysis using available data, it is suggested that the string should be the name of the first person and the last person in the village "census" (as illustrated in the example household listing) or the village name. The social mapping exercise would also be the basis for `N` (the total number of households).

## The `TDASample()` Function

The following code can be copied and pasted into an R session to make the function available to the user. For convenience, you should copy and paste the function into a plain text file, save that file to your system as "TDASample.R", and load it by typing `source("--path/to/file--")`. For instance, if you saved the file to a folder called "Scripts" in your "`C`" drive, you can load it using `source("C:/Scripts/TDASample.R")`. Alternatively, if an internet connection is available, you can load the function by typing: `source("http://ideone.com/plain/BRO66P")`


```r
TDASample <- function(inString, N, n, toFile = FALSE) {
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


### Function Arguments

* `inString`: A quoted string. The name of the first person and last person from your social mapping result is recommended. For instance, using the example data provided earlier, the `inString` value for this dataset would be `"A Umarani, JAN Vijayabharathi"`.
* `N`: The number of households. From the example above, `N = 120`.
* `n`: The desired number of samples. 
* `toFile`: Logical. Should the output of your sample be written to a file? If `toFile = TRUE`, a file named *"Sample from --Date--.txt"* (where date is the current date) will be written to your working directory. The contents of this file will be appended to if further samples are run using the `TDASample()` function. 

## Examples





```r
TDASample("A Umarani, JAN Vijayabharathi", 120, 30)
```

```
## $Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.           
## [2]                 The seed input was: 'A Umarani, JAN Vijayabharathi'
## [3] The total number of households was: 120.                           
## [4]  The desired number of samples was: 30.                            
## 
## $SeedUsed
## [1] 171640
## 
## $FinalSample
##  [1]   1  75  49  53 119 105  20  71  55  12  95  62 113  18   2  50  99  22 110
## [20]  46  26  85  15  54  70 118   5  83  78  60
## 
## $FinalSample_sorted
##  [1]   1   2   5  12  15  18  20  22  26  46  49  50  53  54  55  60  62  70  71
## [20]  75  78  83  85  95  99 105 110 113 118 119
```

```r
# Manual verification. Compare results below with "FinalSample" above
set.seed(187241); sample(120, 30)
```

```
##  [1]  27  23  45  32  14  54  17  56  90 101  70 105 119 118  22  72 107  78 113
## [20] 117  40  69  68  89  61  94  85  62 109  44
```

```r
# Was a file written with our output?
list.files(pattern="Sample from")
```

```
## character(0)
```

```r
# Nope. Nothing was written. Let's write the output to a file.
TDASample("A Umarani, JAN Vijayabharathi", 120, 30, toFile=TRUE)
```

```
## $Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.           
## [2]                 The seed input was: 'A Umarani, JAN Vijayabharathi'
## [3] The total number of households was: 120.                           
## [4]  The desired number of samples was: 30.                            
## 
## $SeedUsed
## [1] 171640
## 
## $FinalSample
##  [1]   1  75  49  53 119 105  20  71  55  12  95  62 113  18   2  50  99  22 110
## [20]  46  26  85  15  54  70 118   5  83  78  60
## 
## $FinalSample_sorted
##  [1]   1   2   5  12  15  18  20  22  26  46  49  50  53  54  55  60  62  70  71
## [20]  75  78  83  85  95  99 105 110 113 118 119
```

```r
# Check again
list.files(pattern="Sample from")
```

```
## [1] "Sample from 2012-12-24 .txt"
```

```r
cat(noquote(readLines(list.files(pattern="Sample from")[1])), sep="\n")
```

```
## $Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.           
## [2]                 The seed input was: 'A Umarani, JAN Vijayabharathi'
## [3] The total number of households was: 120.                           
## [4]  The desired number of samples was: 30.                            
## 
## $SeedUsed
## [1] 171640
## 
## $FinalSample
##  [1]   1  75  49  53 119 105  20  71  55  12  95  62 113  18   2  50  99  22 110
## [20]  46  26  85  15  54  70 118   5  83  78  60
## 
## $FinalSample_sorted
##  [1]   1   2   5  12  15  18  20  22  26  46  49  50  53  54  55  60  62  70  71
## [20]  75  78  83  85  95  99 105 110 113 118 119
```

```r
# Try a different string, 
#   for example a seed based on a village name
TDASample("Melakkal", 120, 30)
```

```
## $Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.
## [2]                 The seed input was: 'Melakkal'          
## [3] The total number of households was: 120.                
## [4]  The desired number of samples was: 30.                 
## 
## $SeedUsed
## [1] 6032
## 
## $FinalSample
##  [1]  89  35  43  26  60  83  25  75  58 101  40 104   5  30  47  53  28 103  98
## [20]  94  67   7  62  27  42 108  69  29  31  78
## 
## $FinalSample_sorted
##  [1]   5   7  25  26  27  28  29  30  31  35  40  42  43  47  53  58  60  62  67
## [20]  69  75  78  83  89  94  98 101 103 104 108
```






## Advanced Example

It is possible to use this in a more sophisticated way, for instance to perform batch sampling provided a `data.frame` with at least the following information: 

1. A column containing the information to be used as your `inString`.
2. A column containing the "population" from which to draw a sample.
3. A column containing the desired sample size.

Here is one such dataset:


```r
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


To batch generate the samples, you can use `apply()`, specifying the column numbers to be used for each argument. For instance, `inString` is represented by the first column (`x[1]`), `N` by the second (`x[2]`), and `n` by the third (`x[3]`).


```r
setNames(apply(myListOfPlaces, 1, function(x) 
    TDASample(x[1], as.numeric(x[2]), as.numeric(x[3]))), 
         myListOfPlaces[[1]])
```

```
## $Melakkal
## $Melakkal$Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.
## [2]                 The seed input was: 'Melakkal'          
## [3] The total number of households was: 120.                
## [4]  The desired number of samples was: 30.                 
## 
## $Melakkal$SeedUsed
## [1] 6032
## 
## $Melakkal$FinalSample
##  [1]  89  35  43  26  60  83  25  75  58 101  40 104   5  30  47  53  28 103  98
## [20]  94  67   7  62  27  42 108  69  29  31  78
## 
## $Melakkal$FinalSample_sorted
##  [1]   5   7  25  26  27  28  29  30  31  35  40  42  43  47  53  58  60  62  67
## [20]  69  75  78  83  89  94  98 101 103 104 108
## 
## 
## $Sholavandan
## $Sholavandan$Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.
## [2]                 The seed input was: 'Sholavandan'       
## [3] The total number of households was: 130.                
## [4]  The desired number of samples was: 25.                 
## 
## $Sholavandan$SeedUsed
## [1] 26909
## 
## $Sholavandan$FinalSample
##  [1]  31  39 119  71  56  59  63  49  44 104  24  16  79 107  85  54 125  34 105
## [20]   4  76  47  55  62  48
## 
## $Sholavandan$FinalSample_sorted
##  [1]   4  16  24  31  34  39  44  47  48  49  54  55  56  59  62  63  71  76  79
## [20]  85 104 105 107 119 125
## 
## 
## $`T. Malaipatti`
## $`T. Malaipatti`$Metadata
## [1]            The sample was drawn on: 2012-12-24 11:39:15.
## [2]                 The seed input was: 'T. Malaipatti'     
## [3] The total number of households was: 140.                
## [4]  The desired number of samples was: 12.                 
## 
## $`T. Malaipatti`$SeedUsed
## [1] 482178
## 
## $`T. Malaipatti`$FinalSample
##  [1]  75  17   4 107  96  16  68  79  27  99 120  93
## 
## $`T. Malaipatti`$FinalSample_sorted
##  [1]   4  16  17  27  68  75  79  93  96  99 107 120
```


## How the Function Works

The function works by using various methods to generate "noise" in your `inString` and ultimately converting your `inString` to a numeric value (though in a somewhat obfuscated manner) that can be used as the seed in R. For instance, at one level, the actual string you input is changed using basic character replacement techniques. Any numeric values in the resulting string are extracted and basic functions (like taking their product, or means, or standard deviation) are applied to add further "noise". Characters are converted to numeric values based on their position in the alphabet, and similar basic functions are applied to them as part of the "formula" for generating the seed. Once the seed is generated, the sample is drawn and displayed in a convenient format that can be used for reporting purposes.

It should be noted that the method of adding "noise" might actually not be noisy enough. At the base is simple character replacement (for example, replacing all instances of "a" with, say, "x"). Thus, using `"ananda"` as your `inString` will result in the same seed as using `"adnana"`; ideally, this would not be the case. There are methods around this, for instance using the `digest` package to convert a string to a `crc32` value and then converting it to a number to use as a seed^[A function that uses this approach is "stringseed.sampling" available at [https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/stringseed.sampling.R](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/stringseed.sampling.R)]. However, the function shared here should be fine for most student uses, and has the advantage that no extra R packages are required for the function to run. 
