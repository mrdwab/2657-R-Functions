# ===== concat.split demo =====
concat.data = read.csv("./data/concatenated-cells.csv")
source("./scripts/concat.split.R")
head(concat.data)
head(concat.split(concat.data, "Likes", drop.col=TRUE))
head(concat.split(concat.data, 2, mode="value", drop.col=T))
head(concat.split(concat.data, "Siblings"))




# ==== df.sorter demo ==== 
# Make up some data
set.seed(1)
dat = data.frame(id = rep(1:5, each=3), times = rep(1:3, 5),
                 measure1 = rnorm(15), score1 = sample(300, 15),
                 code1 = replicate(15, paste(sample(LETTERS[1:5], 3), 
                                             sep="", collapse="")),
                 measure2 = rnorm(15), score2 = sample(150:300, 15), 
                 code2 = replicate(15, paste(sample(LETTERS[1:5], 3), 
                                             sep="", collapse="")))
# Preview your data
dat
# Change the variable order, grouping related columns
# Note that you do not need to specify full variable names,
#    just enough that the variables can be uniquely identified
head(df.sorter(dat, var.order = c("id", "ti", "cod", "mea", "sco")))
# Same output, but with a more awkward syntax
head(df.sorter(dat, var.order = c(1, 2, 5, 8, 3, 6, 4, 7)))
# As above, but sorted by 'times' and then 'id'
head(df.sorter(dat, var.order = c("id", "tim", "cod", "mea", "sco"), 
               col.sort = c(2, 1)))
# Drop 'measure1' and 'measure2', sort by 'times', and 'score1'
head(df.sorter(dat, var.order = c("id", "tim", "sco", "cod"), 
               col.sort = c(2, 3)))
# As above, but using names
head(df.sorter(dat, var.order = c("id", "tim", "sco", "cod"), 
               col.sort = c("times", "score1")))
# Just sort by columns, first by 'times' then by 'id'
head(df.sorter(dat, col.sort = c("times", "id")))
head(df.sorter(dat, col.sort = c("code1"))) # Sorting by character values




# ==== row.extractor demo ====
# Make up some data
set.seed(1)
dat = data.frame(V1 = 1:50, 
                 V2 = rnorm(50), 
                 V3 = round(abs(rnorm(50)), digits=2), 
                 V4 = sample(1:30, 50, replace=TRUE))
# Get a sumary of the data
summary(dat)
# Get the rows corresponding to the 'min', 'median', and 'max' of 'V4'
row.extractor(dat, 4) 
# Get the 'min' rows only, referenced by the variable name
row.extractor(dat, "V4", "min") 
# Get the 'median' rows only. Notice that there are two rows 
# since we have an even number of cases and true median 
# is the mean of the two central sorted values
row.extractor(dat, "V4", "median") 
# Get the rows corresponding to the deciles of 'V3'
row.extractor(dat, "V3", seq(0.1, 1, 0.1))

