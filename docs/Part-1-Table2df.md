



# table2df

The `table2df` function takes an object of class `table`, `ftable`, and `xtabs` and converts them to `data.frame`s, retaining as many of the name details as possible.

## Arguments

* `mytable`: The table object you want to convert into a `data.frame`. This can be a saved object or you can make the call to `table`, `ftable`, or `xtabs` as the `mytable` argument to this function.
* `as.multitable`: Logical; defaults to `FALSE`. Some methods, for instance `xtabs` and `table`, will create an array of tables as the output when more than two variables are being tabulated. 
    * If `as.multitable` is `TRUE`, the function will return a list of `data.frame`s. 
    * If `as.multitable` is `FALSE`, the function will convert the object to an `ftable` object before performing the transformation.
* `direction`: Can be either `"long"` or `"wide"`. 
    * If `"long"`, the frequencies will all be tabulated into a single column. This is the same behavior you will generally get if you used `as.data.frame()` on a `table` object.
    * If `"wide"`, the tabular format is retained.

## Examples

First, we will create a dataset containing information about a person's gender; whether they are left handed, right handed, or ambidextrous; their favorite colors and favorite shapes; and the operating system on their computer.


```r
set.seed(1)
handedness <- data.frame(
  gender = sample(c("Female", "Male", "Unknown"), 200, replace = TRUE),
  handedness = sample(c("Right", "Left", "Ambidextrous"), 
                      200, replace = TRUE, prob = c(.7, .2, .1)),
  fav.col = sample(c("Red", "Orange", "Yellow", "Green", "Blue", 
                     "Indigo", "Violet", "Black", "White"), 
                   200, replace = TRUE),
  fav.shape = sample(c("Triangle", "Circle", "Square", "Pentagon", "Hexagon",
                       "Oval", "Octagon", "Rhombus", "Trapezoid"),
                     200, replace = TRUE),
  computer = sample(c("Win", "Mac", "Lin"), 200, replace = TRUE,
                    prob = c(.5, .25, .25)))

# Preview the data
list(head(handedness), tail(handedness))
```

```
## [[1]]
##    gender handedness fav.col fav.shape computer
## 1  Female      Right  Indigo   Rhombus      Mac
## 2    Male      Right  Orange Trapezoid      Win
## 3    Male      Right   White    Circle      Mac
## 4 Unknown      Right   White   Octagon      Lin
## 5  Female      Right   White Trapezoid      Win
## 6 Unknown      Right  Violet Trapezoid      Lin
## 
## [[2]]
##      gender handedness fav.col fav.shape computer
## 195  Female      Right   Black   Hexagon      Win
## 196    Male      Right  Indigo      Oval      Mac
## 197  Female      Right    Blue    Square      Lin
## 198 Unknown      Right    Blue   Hexagon      Win
## 199  Female      Right   Green   Rhombus      Win
## 200 Unknown      Right    Blue  Pentagon      Win
```


```r
# Load the function!
require(RCurl)
baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
source(textConnection(getURL(paste0(baseURL, "scripts/table2df.R"))))

# A very basic table
HT1 <- with(handedness, table(gender, handedness))
HT1
```

```
##          handedness
## gender    Ambidextrous Left Right
##   Female             5    5    46
##   Male              12   14    52
##   Unknown            6    9    51
```

```r
table2df(HT1)
```

```
##    gender Ambidextrous Left Right
## 1  Female            5    5    46
## 2    Male           12   14    52
## 3 Unknown            6    9    51
```

```r
table2df(HT1, direction = "long")
```

```
##    gender   handedness Freq
## 1  Female Ambidextrous    5
## 2    Male Ambidextrous   12
## 3 Unknown Ambidextrous    6
## 4  Female         Left    5
## 5    Male         Left   14
## 6 Unknown         Left    9
## 7  Female        Right   46
## 8    Male        Right   52
## 9 Unknown        Right   51
```

```r

# Another basic table
HT2 <- with(handedness, table(fav.col, computer))
HT2
```

```
##         computer
## fav.col  Lin Mac Win
##   Black    8   3  10
##   Blue     6   6  12
##   Green    5   6  20
##   Indigo   2   6  14
##   Orange   3   6  10
##   Red      5   7  10
##   Violet   4   6  13
##   White    8   8  10
##   Yellow   0   2  10
```

```r
table2df(HT2)
```

```
##   fav.col Lin Mac Win
## 1   Black   8   3  10
## 2    Blue   6   6  12
## 3   Green   5   6  20
## 4  Indigo   2   6  14
## 5  Orange   3   6  10
## 6     Red   5   7  10
## 7  Violet   4   6  13
## 8   White   8   8  10
## 9  Yellow   0   2  10
```

```r

# This will create multiple tables, one for each possible computer value
HT3 <- with(handedness, table(gender, fav.col, computer))
HT3
```

```
## , , computer = Lin
## 
##          fav.col
## gender    Black Blue Green Indigo Orange Red Violet White Yellow
##   Female      2    4     0      0      0   2      0     2      0
##   Male        3    1     2      2      0   2      2     5      0
##   Unknown     3    1     3      0      3   1      2     1      0
## 
## , , computer = Mac
## 
##          fav.col
## gender    Black Blue Green Indigo Orange Red Violet White Yellow
##   Female      0    2     1      2      2   2      0     1      0
##   Male        3    1     3      3      1   4      3     5      0
##   Unknown     0    3     2      1      3   1      3     2      2
## 
## , , computer = Win
## 
##          fav.col
## gender    Black Blue Green Indigo Orange Red Violet White Yellow
##   Female      3    1     9      5      3   4      2     7      2
##   Male        3    4     6      4      3   4      6     2      6
##   Unknown     4    7     5      5      4   2      5     1      2
```

```r
# Default settings
table2df(HT3)
```

```
##    fav.col  gender Lin Mac Win
## 1    Black  Female   2   0   3
## 2     Blue  Female   4   2   1
## 3    Green  Female   0   1   9
## 4   Indigo  Female   0   2   5
## 5   Orange  Female   0   2   3
## 6      Red  Female   2   2   4
## 7   Violet  Female   0   0   2
## 8    White  Female   2   1   7
## 9   Yellow  Female   0   0   2
## 10   Black    Male   3   3   3
## 11    Blue    Male   1   1   4
## 12   Green    Male   2   3   6
## 13  Indigo    Male   2   3   4
## 14  Orange    Male   0   1   3
## 15     Red    Male   2   4   4
## 16  Violet    Male   2   3   6
## 17   White    Male   5   5   2
## 18  Yellow    Male   0   0   6
## 19   Black Unknown   3   0   4
## 20    Blue Unknown   1   3   7
## 21   Green Unknown   3   2   5
## 22  Indigo Unknown   0   1   5
## 23  Orange Unknown   3   3   4
## 24     Red Unknown   1   1   2
## 25  Violet Unknown   2   3   5
## 26   White Unknown   1   2   1
## 27  Yellow Unknown   0   2   2
```

```r
# As a list of data.frames
table2df(HT3, as.multitable = TRUE)
```

```
## $Lin
##    gender Black Blue Green Indigo Orange Red Violet White Yellow
## 1  Female     2    4     0      0      0   2      0     2      0
## 2    Male     3    1     2      2      0   2      2     5      0
## 3 Unknown     3    1     3      0      3   1      2     1      0
## 
## $Mac
##    gender Black Blue Green Indigo Orange Red Violet White Yellow
## 1  Female     0    2     1      2      2   2      0     1      0
## 2    Male     3    1     3      3      1   4      3     5      0
## 3 Unknown     0    3     2      1      3   1      3     2      2
## 
## $Win
##    gender Black Blue Green Indigo Orange Red Violet White Yellow
## 1  Female     3    1     9      5      3   4      2     7      2
## 2    Male     3    4     6      4      3   4      6     2      6
## 3 Unknown     4    7     5      5      4   2      5     1      2
```

```r
# As above, but with the output in long format
#   Only showing the first three lines of each data.frame
lapply(table2df(HT3, as.multitable = TRUE, direction = "long"), head, 3)
```

```
## $Lin
##    gender fav.col Freq
## 1  Female   Black    2
## 2    Male   Black    3
## 3 Unknown   Black    3
## 
## $Mac
##    gender fav.col Freq
## 1  Female   Black    0
## 2    Male   Black    3
## 3 Unknown   Black    0
## 
## $Win
##    gender fav.col Freq
## 1  Female   Black    3
## 2    Male   Black    3
## 3 Unknown   Black    4
```

```r

# Applied to an ftable
HT4 <- ftable(handedness, 
              col.vars="fav.col", 
              row.vars=c("gender", "computer"))
HT4
```

```
##                  fav.col Black Blue Green Indigo Orange Red Violet White Yellow
## gender  computer                                                               
## Female  Lin                  2    4     0      0      0   2      0     2      0
##         Mac                  0    2     1      2      2   2      0     1      0
##         Win                  3    1     9      5      3   4      2     7      2
## Male    Lin                  3    1     2      2      0   2      2     5      0
##         Mac                  3    1     3      3      1   4      3     5      0
##         Win                  3    4     6      4      3   4      6     2      6
## Unknown Lin                  3    1     3      0      3   1      2     1      0
##         Mac                  0    3     2      1      3   1      3     2      2
##         Win                  4    7     5      5      4   2      5     1      2
```

```r
table2df(HT4)
```

```
##   computer  gender Black Blue Green Indigo Orange Red Violet White Yellow
## 1      Lin  Female     2    4     0      0      0   2      0     2      0
## 2      Mac  Female     0    2     1      2      2   2      0     1      0
## 3      Win  Female     3    1     9      5      3   4      2     7      2
## 4      Lin    Male     3    1     2      2      0   2      2     5      0
## 5      Mac    Male     3    1     3      3      1   4      3     5      0
## 6      Win    Male     3    4     6      4      3   4      6     2      6
## 7      Lin Unknown     3    1     3      0      3   1      2     1      0
## 8      Mac Unknown     0    3     2      1      3   1      3     2      2
## 9      Win Unknown     4    7     5      5      4   2      5     1      2
```


### Other examples

Here are a few other examples to try using some of the inbuilt datasets available in R.


```r
table2df(xtabs(cbind(ncases, ncontrols) ~ ., data = esoph))
table2df(xtabs(cbind(ncases, ncontrols) ~ ., data = esoph), 
         direction = "long")
table2df(xtabs(cbind(ncases, ncontrols) ~ ., data = esoph), 
         as.multitable = TRUE, direction = "long")
table2df(xtabs(cbind(ncases, ncontrols) ~ ., data = esoph), 
         as.multitable = TRUE, direction = "wide")
table2df(ftable(Sex ~ Class + Age, data = x))
```


## References

The `expand.grid` method for remaking the columns from an `ftable` was described by Kohske at [http://stackoverflow.com/a/6463137/1270695](http://stackoverflow.com/a/6463137/1270695).
