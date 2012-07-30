2657-R-Functions
================

Selected functions I've written for use with R.

Functions include:
    
1. `concat.split.R`

    >> Use to split cells which contain concatenated data into separate columns. Works with string and numeric data. For numeric data, the splitted output can retain original values or be recoded as "1" and "NA" to facilitate frequency calculations. Can also split data into a `list` within a `data.frame`.
    
1. `df.sorter.R`

    >> Sort a `data.frame` by rows, columns, or both. Can also be used to subset data.
    
1. `multi.freq.table.R`

    >> Takes columns from a `data.frame` containing Boolean multiple-response data and tabulates the output.

1. `row.extractor.R`

    >> Use to extract rows which contan a specified column's `min`, `median`, or `max` values, or to extract rows with specified quantiles.

- Sample Size Calculator (to determine the sample size for a given population)

## Extras

The `snippets.R` script includes several small "utility" functions. In cases where they are functions I've found online, I've mentioned the source in the head of the function.

Snippets include:

1. `load.scripts.and.data`

    >> Loads all scripts and data files from a specified set of directories matching a specified pattern.

1. `unlist.dfs`

    >> Takes a list of `data.frame`s and assigns them as individual `data.frame`s in the current workspace.

1. `dfcols.list`

    >> Takes a `data.frame` and converts it to a list where each list item represents one of the columns from the original `data.frame`.

1. `mv`

    >> Renames objects in the workspace in one step, instead of having to copy the object and remove the original object.