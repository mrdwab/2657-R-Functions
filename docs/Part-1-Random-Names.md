








# `RandomNames`

The `RandomNames()` function uses data from the *Genealogy Data: Frequently Occurring Surnames from Census 1990--Names Files* web page^[See [http://www.census.gov/genealogy/www/data/1990surnames/names_files.html](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html)] to generate a `data.frame` with random names.

## The Arguments

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
##    Gender FirstName   Surnames
## 1       M       Jon    Cranmer
## 2       M     Jamal Handelsman
## 3       F  Lashawna      Kolbe
## 4       M    Cletus    Custeau
## 5       F    Lenora      Abbot
## 6       F   Maryann     Mossor
## 7       M Guillermo    Baillio
## 8       M   Zackary  Hovsepian
## 9       M   Horacio     Lagoni
## 10      M     Donny Lamantagne
## 11      M      Seth        Abe
## 12      M      Carl     Sandos
## 13      F    Adelle   Letendre
## 14      M Francesco   Piccione
## 15      M    Lyndon     Rippin
## 16      M    Barney      Detro
## 17      M   Agustin      Mudie
## 18      M    Jayson     Resler
## 19      M    Jarred      Savio
## 20      M    Norris    Aadland
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
## 1       F    Vashti Deschenes
## 2       F    Phoebe   Kampner
## 3       M   Freddie    Banker
## 4       F    Audrie    Walper
## 5       F   Dolores  Jandreau
## 6       F       Liz   Pavlick
## 7       M     Chong  Patellis
## 8       M    Emmitt   Lenahan
## 9       F   Lekisha    Heyman
## 10      M     Danny  Moorhead
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
##    Gender FirstName     Surnames
## 1       F     Ninfa      Moscato
## 2       F      Chae        Arney
## 3       F  Annmarie         Jens
## 4       F     Ciera      Bassani
## 5       F   Merlene   Ferrandino
## 6       F   Classie       Burnes
## 7       F  Charlott      Onorati
## 8       F      Veda   Carrithers
## 9       F    Imelda Winterholler
## 10      F   Majorie        Devol
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
## 1       M         a        X
## 2       M         j        O
## 3       M         i        E
## 4       F         q        W
## 5       M         j        D
## 6       M         g        Z
## 7       F         z        K
## 8       F         r        W
## 9       F         k        J
## 10      F         p        V
## 11      M         a        Q
## 12      F         q        A
## 13      M         d        M
## 14      F         m        H
## 15      F         w        B
```


## References

* Inspired by the online Random Name Generator ([http://random-name-generator.info/](http://random-name-generator.info/)). 
* Uses data from the 1990 US Census ([http://www.census.gov/genealogy/www/data/1990surnames/names_files.html](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html))

\cleardoublepage
