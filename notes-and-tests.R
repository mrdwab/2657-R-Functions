
# Concat split on multiple columns.

temp = list(data.frame(Likes = concat.data$Likes), data.frame(Siblings = concat.data$Siblings), data.frame(Hates = concat.data$Hates))
lapply(temp, concat.split, split.col=1, drop=TRUE)
cbind(concat.data[1], data.frame(lapply(temp, concat.split, split.col=1, drop=TRUE)))
