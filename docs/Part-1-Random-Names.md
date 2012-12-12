








# `RandomNames`

The `RandomNames()` function uses data from the *Genealogy Data: Frequently Occurring Surnames from Census 1990--Names Files* web page^[See [http://www.census.gov/genealogy/www/data/1990surnames/names_files.html](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html)] to generate a `data.frame` with random names.

## The Arguments

* `N`: The number of random names you want. Defaults to 100.
* `cat`: Do you want `"common"` names, `"rare"` names, names with an `"average"` frequency, or some combination of these? Should be specified as a character vector (for example, `c("rare", "common")`). Defaults to `NULL`, in which case all names are used as the sample frame.
* `gender`: Do you want first names from the `"male"` dataset, the `"female"` dataset, or from all available names? Should be specified as a quoted string (for example, `"male"`). Defaults to `NULL`, in which case all available first names are used as the sample frame.
* `MFprob`: What proportion of the sample should be male names and what proportion should be female? Specify as a numeric vector that sums to 1 (for example, `c(.6, .4)`). The first number represents the probability of sampling a `"male"` first name, and the second number represents the probability of sampling a `"female"` name. This argument is not used if only one `gender` has been specified in the previous argument. Defaults to `NULL`, in which case, the probability used is `c(.5, .5)`.
* `dataset`: What do you want to use as the dataset of names from which to sample? A default dataset is provided that can generate over 400 million unique names. See the "*Dataset Details*" section for more information.

## Dataset Details

This function samples from a provided dataset of names. By default, it uses the data from the *Genealogy Data: Frequently Occurring Surnames from Census 1990--Names Files* web page. Those data have been converted to `list` named "`CensusNames1990`" containing three `data.frame`s (named `"surnames"`, `"malenames"`, and `"femalenames"`) and saved as an `.RData` file named `CensusNames.RData`. The data file (approximately 615 kb) can be manually downloaded from [Github](https://github.com/mrdwab/2657-R-Functions/blob/master/data/CensusNames.RData)^[See: [https://github.com/mrdwab/2657-R-Functions/blob/master/data/CensusNames.RData](https://github.com/mrdwab/2657-R-Functions/blob/master/data/CensusNames.RData)] and loaded to your workspace; however, provided an internet session is active during your R session, the function will automatically download the dataset for you if it is not found in your workspace or working directory.

Alternatively, you may provide your own data in a `list` formatted according to the following specifications (see the "`myCustomNames`" data in the "*Examples*" section). *Please remember that R is case sensitive!*

* This must be a named list with three items: `"surnames"`, `"malenames"`, and `"femalenames"`. 
* The contents of each list item is a `data.frame` with at least the following named columns: `"Name"` and `"Category"`.
* Acceptable values for `"Category"` are `"common"`, `"rare"`, and `"average"`.

## Examples


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/random.names.R"))))

# Generate 20 random names
RandomNames(N = 20)
```

```
##    Gender  FirstName   Surnames
## 1       M        Rex Grossetete
## 2       M      Elvin     Oshima
## 3       M    Jamison    Tankard
## 4       M       Hong      Adger
## 5       M    Clinton     Lingel
## 6       M     Connie      Abeta
## 7       M     Dexter    Stelter
## 8       F   Christie    Debraga
## 9       M    Barrett    Wehmann
## 10      M   Napoleon       Gagg
## 11      M    Delbert    Lofland
## 12      F   Estefana    Degroot
## 13      M     Michel  Masterman
## 14      M      Cyrus      Farve
## 15      M       Cody   Roginson
## 16      M    Bennett      Bashi
## 17      M      Duane      Vidra
## 18      F     Stevie     Romane
## 19      M     Alonzo     Torris
## 20      M Kristopher     Kinsel
```

```r

# Generate a reproducible list of 100 random names with approximately 80% of
#   the names being female names, and 20% being male names.
set.seed(1)
temp <- RandomNames(cat = "common", MFprob = c(.2, .8))
list(head(temp), tail(temp))
```

```
## [[1]]
##   Gender FirstName   Surnames
## 1      F   Mildred     Moring
## 2      F  Gertrude      Duron
## 3      F     Marta      Croom
## 4      F  Angelita  Neuberger
## 5      M    Morris   Gallucci
## 6      F      Enid Barrientos
## 
## [[2]]
##     Gender FirstName  Surnames
## 95       F    Jeanie Toussaint
## 96       F Rosalinda  Beauvais
## 97       F   Blanche Schaeffer
## 98       F      Lena      Hepp
## 99       F    Louisa    Struck
## 100      F    Dorthy    Divito
```

```r
table(temp$Gender)
```

```
## 
##  F  M 
## 84 16
```

```r
# Cleanup
rm(.Random.seed, envir=globalenv()) # Resets your seed
rm(temp)

# Generate 10 names from the common and rare categories of names
RandomNames(N = 10, cat = c("common", "rare"))
```

```
##    Gender FirstName  Surnames
## 1       F      Lila     Zullo
## 2       M      Cory    Proulx
## 3       M    Jordon Lassetter
## 4       M     Dario  Ankersen
## 5       F     Twila    Gruner
## 6       M    Alfred       Aho
## 7       M     Toney   Pardall
## 8       F     Elene     Geise
## 9       M    Jessie   Yessios
## 10      F     Myrta   Shawler
```

```r
# Error messages
RandomNames(cat = c("common", "rare", "avg"))
```

```
## Error: cat must be either "all", NULL, or a combination of "common", "average",
## or "rare"
```

```r
# Generate 10 female names
RandomNames(N = 10, gender = "female")
```

```
##    Gender FirstName  Surnames
## 1       F     Terri     Bayon
## 2       F  Kimberly      Situ
## 3       F   Rosenda   Schmeer
## 4       F   Caroyln     Monti
## 5       F     Elyse Schlobohm
## 6       F   Ethelyn     Plake
## 7       F     Janet Furgerson
## 8       F   Romelia   Mazingo
## 9       F      Kina    Washor
## 10      F    Ashlie     Galaz
```


### Using Your Own Data

As mentioned, it is possible to use your own list of names as the basis for generating the random names (though this is perhaps unnecessary, given the number of random names possible with the provided dataset). The following is an example of how your dataset must be structured. Note that the dataset name in the `dataset` argument is *not* quoted.


```r
myCustomNames <- list(
  surnames = data.frame(
    Name = LETTERS[1:26], 
    Category = c(rep("rare", 10), rep("average", 10), rep("common", 6))),
  malenames = data.frame(
    Name = letters[1:10], 
    Category = c(rep("rare", 4), rep("average", 4), rep("common", 2))),
  femalenames = data.frame(
    Name = letters[11:26],
    Category = c(rep("rare", 8), rep("average", 4), rep("common", 4))))
str(myCustomNames)
```

```
## List of 3
##  $ surnames   :'data.frame':	26 obs. of  2 variables:
##   ..$ Name    : Factor w/ 26 levels "A","B","C","D",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ Category: Factor w/ 3 levels "average","common",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ malenames  :'data.frame':	10 obs. of  2 variables:
##   ..$ Name    : Factor w/ 10 levels "a","b","c","d",..: 1 2 3 4 5 6 7 8 9 10
##   ..$ Category: Factor w/ 3 levels "average","common",..: 3 3 3 3 1 1 1 1 2 2
##  $ femalenames:'data.frame':	16 obs. of  2 variables:
##   ..$ Name    : Factor w/ 16 levels "k","l","m","n",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ Category: Factor w/ 3 levels "average","common",..: 3 3 3 3 3 3 3 3 1 1 ...
```

```r
RandomNames(N = 15, dataset = myCustomNames)
```

```
## Error: could not find function "RandomNames"
```


## References

* Inspired by the online Random Name Generator ([http://random-name-generator.info/](http://random-name-generator.info/)). 
* Uses data from the 1990 US Census ([http://www.census.gov/genealogy/www/data/1990surnames/names_files.html](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html))

## To Do

* Make function look for the `CensusNames.RData` file in the current working directory before downloading it.
* Rewrite the function to use `exists()` instead.

\cleardoublepage
