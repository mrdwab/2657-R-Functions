








# `RandomNames`

The `RandomNames()` function uses data from the *Genealogy Data: Frequently Occurring Surnames from Census 1990--Names Files* web page^[See [http://www.census.gov/genealogy/www/data/1990surnames/names_files.html](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html)] to generate a `data.frame` with random names.

## Arguments

* `N`: The number of random names you want. Defaults to 100.
* `cat`: Do you want `"common"` names, `"rare"` names, names with an `"average"` frequency, or some combination of these? Should be specified as a character vector (for example, `c("rare", "common")`). Defaults to `NULL`, in which case all names are used as the sample frame.
* `gender`: Do you want first names from the `"male"` dataset, the `"female"` dataset, or from all available names? Should be specified as a quoted string (for example, `"male"`). Defaults to `NULL`, in which case all available first names are used as the sample frame.
* `MFprob`: What proportion of the sample should be male names and what proportion should be female? Specify as a numeric vector that sums to 1 (for example, `c(.6, .4)`). The first number represents the probability of sampling a `"male"` first name, and the second number represents the probability of sampling a `"female"` name. This argument is not used if only one `gender` has been specified in the previous argument. Defaults to `NULL`, in which case, the probability used is `c(.5, .5)`.
* `dataset`: What do you want to use as the dataset of names from which to sample? A default dataset is provided that can generate over 400 million unique names. See the "*Dataset Details*" section for more information.

## Dataset Details

This function samples from a provided dataset of names. By default, it uses the data from the *Genealogy Data: Frequently Occurring Surnames from Census 1990--Names Files* web page. Those data have been converted to `list` named "`CensusNames1990`" containing three `data.frame`s (named `"surnames"`, `"malenames"`, and `"femalenames"`) and saved as an `.RData` file named `CensusNames.RData`. The data file (approximately 615 kb) can be manually downloaded from [Github](https://github.com/mrdwab/2657-R-Functions/blob/master/data/CensusNames.RData)^[See: [https://github.com/mrdwab/2657-R-Functions/blob/master/data/CensusNames.RData](https://github.com/mrdwab/2657-R-Functions/blob/master/data/CensusNames.RData)] and loaded to your workspace. The function will perform some basic checking to see if either the `CensusNames.RData` file or the `CensusNames1990` objects are available in your workspace or working directory. If neither is found and an internet connection is active during your R session, the function will offer you the option to automatically download the dataset and add it to your *current* session.

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
##    Gender FirstName    Surnames
## 1       F    Dalila     Cordrey
## 2       M    Raymon       Selic
## 3       M    Wilber        Rife
## 4       M  Federico      Helena
## 5       M       Rey Vanderroest
## 6       M   Maynard    Madhavan
## 7       M   Agustin       Queja
## 8       M   Gregory    Woollard
## 9       F    Kazuko      Feasel
## 10      M     Gavin      Musolf
## 11      M      Huey   Dominique
## 12      M   Tristan    Anzualda
## 13      M      Neil    Gasbarro
## 14      F   Lashawn      Deland
## 15      M   Jamison      Brucki
## 16      F    Sharyl     Martinz
## 17      F   Eugenie      Sifers
## 18      M     Galen     Fabozzi
## 19      F   Suzette    Camareno
## 20      M    Harlan Suellentrop
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
##    Gender FirstName    Surnames
## 1       F     Flora        Todt
## 2       F    Willie        Dehl
## 3       F    Ingrid      Fetter
## 4       F    Emilie      Gnagey
## 5       F      Elli      Fahner
## 6       F   Gregory     Linsley
## 7       F    Marisa      Dewees
## 8       F   Jeanice Bloomstrand
## 9       F     Kyoko      Watral
## 10      M    Rafael      Farria
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
##    Gender FirstName Surnames
## 1       F     Julie  Lenberg
## 2       F  Trinidad Killings
## 3       F     Terri    Alier
## 4       F  Donnetta Golanski
## 5       F    Cindie   Helder
## 6       F    Shayna  Stepien
## 7       F      Geri  Gostlin
## 8       F     James   Missey
## 9       F   Rosenda Scroggin
## 10      F   Rosella  Lantrip
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
##    Gender FirstName Surnames
## 1       M         f        J
## 2       M         d        U
## 3       F         s        K
## 4       F         w        L
## 5       M         h        Y
## 6       F         x        C
## 7       M         i        B
## 8       M         b        L
## 9       M         c        J
## 10      M         a        J
## 11      M         c        E
## 12      F         m        J
## 13      M         h        N
## 14      F         r        H
## 15      M         c        M
```


## References

* Inspired by the online Random Name Generator ([http://random-name-generator.info/](http://random-name-generator.info/)). 
* Uses data from the 1990 US Census ([http://www.census.gov/genealogy/www/data/1990surnames/names_files.html](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html))

\cleardoublepage
