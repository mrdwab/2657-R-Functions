



# multi.freq.table

The `multi.freq.table` function takes a data frame containing Boolean responses to multiple response questions and tabulates the number of responses by the possible combinations of answers. In addition to tabulating the frequency (`Freq`), there are two other columns in the output: *Percent of Responses* (`Pct.of.Resp`) and *Percent of Cases* (`Pct.of.Cases`). *Percent of Responses* is the frequency divided by the total number of answers provided; this column should sum to 100%. In some cases, for instance when a combination table is generated and there are cases where a respondent did not select any option, the *Percent of Responses* value would be more than 100%. *Percent of Cases* is the frequency divided by the total number of valid cases; this column would most likely sum to more than 100% when a basic table is produced since each respondent (case) can select multiple answers, but should sum to 100% with other tables.

## Arguments

* `data`: The multiple responses that need to be tabulated.
* `sep`: The desired separator for collapsing the combinations of options; defaults to `""` (collapsing with no space between each option name).
* `boolean`: Are you tabulating boolean data (see `dat` examples)? Defaults to `TRUE`.
* `factors`: If you are trying to tabulate non-boolean data, and the data are not factors, you can specify the factors here (see `dat2` examples). 
    * Defaults to `NULL` and is not used when `boolean = TRUE`.
* `NAto0`: Should `NA` values be converted to `0`.
    * Defaults to `TRUE`, in which case, the number of valid cases should be the same as the number of cases overall.
    * If set to `FALSE`, any rows with `NA` values will be dropped as invalid cases.
    * Only applies when `boolean = TRUE`.
* `basic`: Should a basic table of each item, rather than combinations of items, be created? Defaults to `FALSE`.
* `dropzero`: Should combinations with a frequency of zero be dropped from the final table? 
    * Defaults to `TRUE`.
    * Does not apply when `boolean = TRUE`.
* `clean`: Should the original tabulated data be retained or dropped from the final table? 
    * Defaults to `TRUE`.
    * Does not apply when `boolean = TRUE`.

## Examples

### Boolean Data


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/multi.freq.table.R"))))

# Make up some data
set.seed(1)
dat = data.frame(A = sample(c(0, 1), 20, replace=TRUE),
                 B = sample(c(0, 1, NA), 20, 
                            prob=c(.3, .6, .1), replace=TRUE),
                 C = sample(c(0, 1, NA), 20, 
                            prob=c(.7, .2, .1), replace=TRUE),
                 D = sample(c(0, 1, NA), 20, 
                            prob=c(.3, .6, .1), replace=TRUE),
                 E = sample(c(0, 1, NA), 20, 
                            prob=c(.4, .4, .2), replace=TRUE))
# View your data
dat
```

```
   A  B C  D  E
1  0 NA 1 NA  0
2  0  1 0  1  0
3  1  0 1  1  1
4  1  1 0  1  1
5  0  1 0  0  0
6  1  1 1  1  1
7  1  1 0  1  0
8  1  1 0  0  1
9  1  0 1  1  1
10 0  1 0  0  1
11 0  1 0  1  1
12 0  1 1  0  1
13 1  1 0  1  0
14 0  1 0  1 NA
15 1  0 0  1  0
16 0  0 0  0  0
17 1  0 0  0  0
18 1  1 0  1  0
19 0  0 0  0 NA
20 1  1 0 NA  0
```

```r
# How many cases have "NA" values?
table(is.na(rowSums(dat)))
```

```

FALSE  TRUE 
   16     4 
```

```r
# Apply the function with all defaults accepted
multi.freq.table(dat)
```

```
   Combn Freq Weighted.Freq Pct.of.Resp Pct.of.Cases
1           2             2       4.167           10
2      A    1             1       2.083            5
3      B    1             1       2.083            5
4     AB    1             2       4.167            5
5      C    1             1       2.083            5
6     AD    1             2       4.167            5
7     BD    2             4       8.333           10
8    ABD    3             9      18.750           15
9     BE    1             2       4.167            5
10   ABE    1             3       6.250            5
11   BCE    1             3       6.250            5
12   BDE    1             3       6.250            5
13  ABDE    1             4       8.333            5
14  ACDE    2             8      16.667           10
15 ABCDE    1             5      10.417            5
```

```r
# Tabulate only on variables "A", "B", and "D", with a different
# separator, keep any zero frequency values, and keeping the 
# original tabulations. There are no solitary "D" responses.
multi.freq.table(dat[c(1, 2, 4)], sep="-", dropzero=FALSE, clean=FALSE)
```

```
  A B D Freq Combn Weighted.Freq Pct.of.Resp Pct.of.Cases
1 0 0 0    3                   3       8.571           15
2 1 0 0    1     A             1       2.857            5
3 0 1 0    3     B             3       8.571           15
4 1 1 0    2   A-B             4      11.429           10
5 0 0 1    0     D             0       0.000            0
6 1 0 1    3   A-D             6      17.143           15
7 0 1 1    3   B-D             6      17.143           15
8 1 1 1    5 A-B-D            15      42.857           25
```

```r
# As above, but without converting "NA" to "0".
# Note the difference in the number of valid cases.
multi.freq.table(dat[c(1, 2, 4)], NAto0=FALSE, 
                 sep="-", dropzero=FALSE, clean=FALSE)
```

```
  A B D Freq Combn Weighted.Freq Pct.of.Resp Pct.of.Cases
1 0 0 0    2                   2       6.061       11.111
2 1 0 0    1     A             1       3.030        5.556
3 0 1 0    3     B             3       9.091       16.667
4 1 1 0    1   A-B             2       6.061        5.556
5 0 0 1    0     D             0       0.000        0.000
6 1 0 1    3   A-D             6      18.182       16.667
7 0 1 1    3   B-D             6      18.182       16.667
8 1 1 1    5 A-B-D            15      45.455       27.778
```

```r
# View a basic table.
multi.freq.table(dat, basic=TRUE)
```

```
  Freq Pct.of.Resp Pct.of.Cases
A   11       22.92           55
B   13       27.08           65
C    5       10.42           25
D   11       22.92           55
E    8       16.67           40
```


### Non-Boolean Data


```r
# Make up some data
dat2 = structure(list(Reason.1 = c("one", "one", "two", "one", "two", 
                                   "three", "one", "one", NA, "two"), 
                      Reason.2 = c("two", "three", "three", NA, NA, 
                                   "two", "three", "two", NA, NA), 
                      Reason.3 = c("three", NA, NA, NA, NA, 
                                   NA, NA, "three", NA, NA)), 
                 .Names = c("Reason.1", "Reason.2", "Reason.3"), 
                 class = "data.frame", 
                 row.names = c(NA, -10L))
# View your data
dat2
```

```
   Reason.1 Reason.2 Reason.3
1       one      two    three
2       one    three     <NA>
3       two    three     <NA>
4       one     <NA>     <NA>
5       two     <NA>     <NA>
6     three      two     <NA>
7       one    three     <NA>
8       one      two    three
9      <NA>     <NA>     <NA>
10      two     <NA>     <NA>
```

```r
# The following will not work.
# The data are not factored.
multi.freq.table(dat2, boolean=FALSE)
```

```
Error: Input variables must be factors.  Please provide factors using the
'factors' argument or convert your data to factor before using function.
```

```r
# Factor create the factors.
multi.freq.table(dat2, boolean=FALSE, 
                 factors = c("one", "two", "three"))
```

```
        Combos Freq Weighted.Freq Pct.of.Resp Pct.of.Cases
1                 1             1       5.882           10
8          one    1             1       5.882           10
12         two    2             2      11.765           20
15    onethree    2             4      23.529           20
17    threetwo    2             4      23.529           20
22 onethreetwo    2             6      35.294           20
```

```r
# And, a basic table.
multi.freq.table(dat2, boolean=FALSE,
                 factors = c("one", "two", "three"),
                 basic=TRUE)
```

```
   Item Freq Pct.of.Resp Pct.of.Cases
1   one    5       29.41           50
2   two    6       35.29           60
3 three    6       35.29           60
```


### Extended Examples

The following example is based on some data available from the University of Auckland's Student Learning Resources^[See: [http://www.cad.auckland.ac.nz/index.php?p=spss](http://www.cad.auckland.ac.nz/index.php?p=spss)].

When the data are read into R, the factor labels are very long, which makes it difficult to see on the screen. Thus, in the first example that follows, the factor levels are first recoded before the multiple frequency tables are created. Additionally, the data for the binary information in the second example was coded in a common `1 = Yes` and `2 = No` format, but we need `0 = No` instead, so we need to do some recoding there too before using the function.



```r
# Get the data
library(foreign)
temp = "http://cad.auckland.ac.nz/file.php/content/files/slc/"
computer = read.spss(paste0(temp, 
                            "computer_multiple_response.sav"), 
                     to.data.frame=TRUE)
rm(temp)
# Preview 
dim(computer)
```

```
[1] 100  20
```

```r
names(computer)
```

```
 [1] "id"       "ms_word"  "ms_excel" "ms_ppt"   "ms_outlk" "ms_pub"  
 [7] "ms_proj"  "ms_acc"   "netscape" "int_expl" "adobe_rd" "endnote" 
[13] "spss"     "quality1" "quality2" "quality3" "quality4" "quality5"
[19] "quality6" "gender"  
```

```r
# First, let's just tabulate the instructor qualities.
#   Extract the relevant columns, and relevel the factors.
instructor.quality = 
  computer[, grep("quali", names(computer))]
# View the existing levels.
lapply(instructor.quality, levels)[[1]]
```

```
[1] "Ability to provide practical examples" 
[2] "Ability to answer questions positively"
[3] "Ability to clearly explain concepts"   
[4] "Ability to instruct at a suitable pace"
[5] "Knowledge of software"                 
[6] "Humour"                                
[7] "Other"                                 
```

```r
instructor.quality = lapply(instructor.quality,
                            function(x) { levels(x) = 
  list(Q1 = "Ability to provide practical examples",
       Q2 = "Ability to answer questions positively",
       Q3 = "Ability to clearly explain concepts",
       Q4 = "Ability to instruct at a suitable pace",
       Q5 = "Knowledge of Software",
       Q6 = "Humour", Q7 = "Other"); x })
# Now, apply multi.freq.table to the data.
multi.freq.table(data.frame(instructor.quality),
                 boolean=FALSE, basic=TRUE)
```

```
  Item Freq Pct.of.Resp Pct.of.Cases
1   Q1   47      18.077           47
2   Q2   59      22.692           59
3   Q3   55      21.154           55
4   Q4   43      16.538           43
5   Q5    0       0.000            0
6   Q6   47      18.077           47
7   Q7    9       3.462            9
```

```r
list(head(multi.freq.table(data.frame(instructor.quality),
                           boolean=FALSE, sep="-")),
     tail(multi.freq.table(data.frame(instructor.quality),
                           boolean=FALSE, sep="-")))
```

```
[[1]]
   Combos Freq Weighted.Freq Pct.of.Resp Pct.of.Cases
1      Q1    1             1      0.3846            1
21     Q2    3             3      1.1538            3
31     Q3    2             2      0.7692            2
37     Q4    2             2      0.7692            2
39     Q6    3             3      1.1538            3
41  Q1-Q2    8            16      6.1538            8

[[2]]
               Combos Freq Weighted.Freq Pct.of.Resp Pct.of.Cases
133       Q1-Q3-Q6-Q7    1             4       1.538            1
141       Q2-Q3-Q4-Q6    4            16       6.154            4
151       Q3-Q4-Q6-Q7    1             4       1.538            1
161    Q1-Q2-Q3-Q4-Q6    1             5       1.923            1
164    Q1-Q2-Q3-Q6-Q7    1             5       1.923            1
201 Q1-Q2-Q3-Q4-Q6-Q7    1             6       2.308            1

```

```r
# Now. let's look at the software.
instructors.sw = computer[2:13]
# These columns are coded as 1 = Yes and 2 = No,
#   so, convert to integers, and subtract two, and
#   take the absolute value to convert to binary.
instructors.sw = lapply(instructors.sw, 
                        function(x) abs(as.integer(x)-2))
# Apply multi.freq.table
multi.freq.table(data.frame(instructors.sw), basic=TRUE)
```

```
         Freq Pct.of.Resp Pct.of.Cases
ms_word    77      13.975           77
ms_excel   48       8.711           48
ms_ppt     55       9.982           55
ms_outlk   52       9.437           52
ms_pub     19       3.448           19
ms_proj    21       3.811           21
ms_acc     57      10.345           57
netscape   10       1.815           10
int_expl   84      15.245           84
adobe_rd   48       8.711           48
endnote    55       9.982           55
spss       25       4.537           25
```

```r
# The output here is not pretty. To get prettier (or more meaningful)
#   output, provide shorter names for the variables or use just a
#   meaningful subset of the variables.
list(head(multi.freq.table(data.frame(instructors.sw), sep="-")),
     tail(multi.freq.table(data.frame(instructors.sw), sep="-")))
```

```
[[1]]
                                           Combn Freq Weighted.Freq Pct.of.Resp
1                 ms_word-ms_excel-ms_ppt-ms_acc    1             4      0.7260
2 ms_word-ms_excel-ms_ppt-ms_outlk-ms_pub-ms_acc    1             6      1.0889
3                                       int_expl    2             2      0.3630
4                               ms_word-int_expl    1             2      0.3630
5                        ms_word-ms_ppt-int_expl    1             3      0.5445
6                      ms_word-ms_outlk-int_expl    1             3      0.5445
  Pct.of.Cases
1            1
2            1
3            2
4            1
5            1
6            1

[[2]]
                                                                     Combn Freq
91 ms_word-ms_excel-ms_outlk-ms_pub-ms_proj-int_expl-adobe_rd-endnote-spss    1
92           ms_word-ms_excel-ms_ppt-ms_acc-int_expl-adobe_rd-endnote-spss    1
93                  ms_word-ms_outlk-ms_acc-int_expl-adobe_rd-endnote-spss    1
94           ms_word-ms_ppt-ms_outlk-ms_acc-int_expl-adobe_rd-endnote-spss    1
95                    ms_word-ms_pub-ms_acc-int_expl-adobe_rd-endnote-spss    1
96                  ms_outlk-ms_proj-ms_acc-int_expl-adobe_rd-endnote-spss    1
   Weighted.Freq Pct.of.Resp Pct.of.Cases
91             9       1.633            1
92             8       1.452            1
93             7       1.270            1
94             8       1.452            1
95             7       1.270            1
96             7       1.270            1

```



## References

`apply` shortcut for creating the `Combn` column in the output by [Justin](http://stackoverflow.com/users/906490/justin)  
See: [http://stackoverflow.com/q/11348391/1270695](http://stackoverflow.com/q/11348391/1270695) and [http://stackoverflow.com/q/11622660/1270695](http://stackoverflow.com/q/11622660/1270695)

\newpage
