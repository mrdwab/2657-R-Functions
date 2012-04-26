# ===== concat.split demo =====
concat.data = read.csv("./data/concatenated-cells.csv")
source("./scripts/concat.split.R")
head(concat.data)
head(concat.split(concat.data, "Likes", drop.col=TRUE))
head(concat.split(concat.data, 2, mode="value", drop.col=T))
head(concat.split(concat.data, "Siblings"))