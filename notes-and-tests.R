
# Concat split on multiple columns.

temp = list(data.frame(Likes = concat.test$Likes), 
            data.frame(Siblings = concat.test$Siblings), 
            data.frame(Hates = concat.test$Hates))
lapply(temp, concat.split, split.col=1, drop=TRUE, sep=";|,")
cbind(concat.test[1], data.frame(lapply(temp, 
                                        concat.split, 
                                        split.col=1, 
                                        drop=TRUE)))
