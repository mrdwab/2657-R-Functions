## @knitr stratified

stratified <- function(df, id, group, size, seed = NULL, ...) {
  # Returns a stratified random subset of a data.frame.
  #
  # --> df:     The source data.frame
  # --> id      Your "ID" variable
  # --> group   Your grouping variable
  # --> size    The desired sample size. If size is a decimal, a proportionate
  #             sample would be drawn. If it is >= 1, a sample will be taken
  #             of that specified size
  # --> seed    The seed that you want to use, if any
  # --> ...     Further arguments to the sample function
  #
  # === EXAMPLES ===
  #
  #   set.seed(1)
  #   dat = data.frame(A = 1:100, 
  #                    B = sample(c("AA", "BB", "CC", "DD", "EE"), 
  #                               100, replace=T),
  #                    C = rnorm(100), D = abs(round(rnorm(100), digits=1)),
  #                    E = sample(c("CA", "NY", "TX"), 100, replace=T))
  #     
  #   stratified(dat, 1, 5, .1, 1)
  #   stratified(dat, id = "A", group = "E", size = .1, seed = 1)
  #   stratified(dat, "A", "B", 5)
  
  k <- split(df[[id]], df[[group]])
  ifelse(size < 1, 
         n <- ceiling(sapply(k, length) * size), 
         n <- setNames(rep(size, length.out = length(k)), names(k)))
  seedme <- ifelse(is.null(seed), "No", "Yes")
  
  temp <- switch(
    seedme,
    No = { temp <- lapply(names(k), function(x) sample(k[[x]], n[x], ...)) },
    Yes = { temp <- lapply(names(k), 
                           function(x) { set.seed(seed)
                                         sample(k[[x]], n[x], ...) })})
  names(temp) <- names(k)
  temp <- setNames(
    data.frame(unlist(temp, use.names = FALSE),
               rep(names(temp), times = n)),
    c(names(df[id]), names(df[group])))
  
  w <- merge(df, temp)[, names(df)]
  w[order(w[[group]]), ]
}
