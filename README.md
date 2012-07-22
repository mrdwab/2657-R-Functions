2657-R-Functions
================

Selected functions I've written for use with R.

Functions include:
    
1. concat.split.R

    >> Use to split cells which contain concatenated data into separate columns. Works with string and numeric data. For numeric data, the splitted output can retain original values or be recoded as "1" and "NA" to facilitate frequency calculations. Can also split data into a `list` within a `data.frame`.
    
1. df.sorter.R

    >> Sort a `data.frame` by rows, columns, or both. Can also be used to subset data.
    
1. multi.freq.table.R

    >> Takes columns from a `data.frame` containing Boolean multiple-response data and tabulates the output.

1. row.extractor.R

    >> Use to extract rows which contan a specified column's `min`, `median`, or `max` values, or to extract rows with specified quantiles.

- Sample Size Calculator (to determine the sample size for a given population)