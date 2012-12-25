2657-R-Functions
================

Selected functions I've written for use with R. Full documentation available in the "`docs`" folder (or as a [PDF](https://github.com/mrdwab/2657-R-Functions/blob/master/docs/2657-Functions.pdf?raw=true)). 

All functions can be downloaded from the "`scripts`" folder.

Alternatively, if you have the "RCurl" package installed, you can use:

    library(RCurl)
    baseURL = c("https://raw.github.com/mrdwab/2657-R-Functions/master/")
    source(textConnection(getURL(paste0(baseURL, "scripts/---script-name---.R"))))
    
All scripts mentioned in the `snippets` section are found in a single `snippets.R` script.

Functions include:
    
1. [`concat.split.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/concat.split.R)

    >> Use to split cells which contain concatenated data into separate columns. Works with string and numeric data. For numeric data, the splitted output can retain original values or be recoded as "1" and "NA" to facilitate frequency calculations. Can also split data into a `list` within a `data.frame`.
    
1. [`df.sorter.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/df.sorter.R)

    >> Sort a `data.frame` by rows, columns, or both. Can also be used to subset data.
    
1. [`multi.freq.table.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/multi.freq.table.R)

    >> Takes columns from a `data.frame` containing Boolean multiple-response data and tabulates the output.
    
1. [`RandomNames.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/RandomNames.R)

    >> Uses data from the [*Genealogy Data: Frequently Occurring Surnames from Census 1990--Names Files* web page](http://www.census.gov/genealogy/www/data/1990surnames/names_files.html) to generate a `data.frame` with random names.

1. [`row.extractor.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/row.extractor.R)

    >> Use to extract rows which contan a specified column's `min`, `median`, or `max` values, or to extract rows with specified quantiles.

1. [`sample.size.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/sample.size.R)

    >> Used to determine the desired sample size of a given population, or the confidence interval for a given population and sample. 
    
1. [`stratified.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/stratified.R)

    >> Used to sample from a `data.frame` according to a grouping (or *stratification*) variable.
    
1. [`stringseed.sampling.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/stringseed.sampling.R)

    >> The `stringseed.sampling()` function is designed as a batch sampling function that allows the user to specify any alphanumeric input as the seed per sample in the batch.

## Extras

The [`snippets.R`](https://github.com/mrdwab/2657-R-Functions/blob/master/scripts/snippets.R) script includes several small "utility" functions. In cases where they are functions I've found online, I've mentioned the source in the head of the function.

Snippets include:

1. `load.scripts.and.data`

    >> Loads all scripts and data files from a specified set of directories matching a specified pattern.

1. `unlist.dfs`

    >> Takes a list of `data.frame`s and assigns them as individual `data.frame`s in the current workspace.

1. `dfcols.list`

    >> Takes a `data.frame` and converts it to a list where each list item represents one of the columns from the original `data.frame`.

1. `mv`

    >> Renames objects in the workspace in one step, instead of having to copy the object and remove the original object.
    
1. `tidyHTML`

    >> Reformats a web page using HTML Tidy (the online service) and uses the XML package to parse the resulting file. Can optionally save the reformatted page.

1. `round2`

    >> Rounds numbers according to the rule you might have learned in school, not according to "round to even" (which is less biased and is used by R).
    
1. `CBIND`

    >> Binds (by columns) `data.frame`s with differing number of rows, filling the extra rows with `NA` values. 
    
1. `randomNamesOnline`

    >> Like the `RandomNames()` function, but uses an online service ([http://random-name-generator.info/](http://random-name-generator.info/)) to generate the names.
    
1. `stringseed.basic`

    >> Like the `stringseed.sampling()` function, but uses a much more basic approach to generating the seed. Also known as `TDASample.R`.
    