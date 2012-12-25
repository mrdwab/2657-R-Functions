## @knitr stratified

stratified <- function(df, id, group, size, seed = NULL, ...) {
  # Returns a stratified random subset of a data.frame.
  #
  # --> df      The source data.frame
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
  
  if (length(size) > 1) {
    if (length(size) != length(k)) stop("Number of groups is ", length(k), 
                                        " but number of sizes supplied is ", 
                                        length(size))
    if (is.null(names(size))) {
      n <- setNames(size, names(k))
      message(sQuote("size"), " vector entered as:\n\nsize = structure(c(", 
              paste(n, collapse = ", "), "),\n.Names = c(",
              paste(shQuote(names(n)), collapse = ", "), ")) \n\n")
    } else {
      ifelse(all(names(size) %in% names(k)), n <- size[names(k)], 
             stop("Named vector supplied with names ", 
                  paste(names(size), collapse = ", "),
                  "\n but the names for the group levels are ", 
                  paste(names(k), collapse = ", ")))
    } 
  } else {
    ifelse(size < 1, 
           n <- setNames(
             round(table(df[[group]]) * size, digits = 0), names(k)),
           ifelse(all(sapply(k, length) >= size), 
                  n <- setNames(rep(size, length.out = length(k)), names(k)),
{
  temp <- sapply(k, length)
  message(
    "Some groups---", 
    paste(names(temp[temp < size]), collapse = ", "),
    "---\ncontain fewer observations than desired number of samples.\n",
    "All observations have been returned from those groups.")
  n <- c(sapply(temp[temp >= size], function(x) x = size),
         temp[temp < size])[names(k)]
}))
  }
  
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
  
  rm(.Random.seed, envir=.GlobalEnv) # "resets" the seed
  
  w <- merge(df, temp)[, names(df)]
  w[order(w[[group]]), ]
}
