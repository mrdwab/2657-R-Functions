## @knitr stratified

stratified <- function(df, group, size, seed = NULL, ...) {
  # Returns a stratified random subset of a data.frame.
  #
  # --> df      The source data.frame
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
  #   stratified(dat, 5, .1, 1)
  #   stratified(dat, group = "E", size = .1, seed = 1)
  #   stratified(dat, "B", 5)
  
  temp0 <- table(df[[group]])
  temp1 <- split(df, df[[group]])
  
  if (length(size) > 1) {
    if (length(size) != length(temp1))
      stop("Number of groups is ", length(temp1),
           " but number of sizes supplied is ", length(size))
    if (is.null(names(size))) {
      n <- setNames(size, names(temp1))
      message(sQuote("size"), " vector entered as:\n\nsize = structure(c(", 
              paste(n, collapse = ", "), "),\n.Names = c(",
              paste(shQuote(names(n)), collapse = ", "), ")) \n\n")
    } else {
      ifelse(all(names(size) %in% names(temp1)), 
             n <- size[names(temp1)], 
             stop("Named vector supplied with names ", 
                  paste(names(size), collapse = ", "),
                  "\n but the names for the group levels are ", 
                  paste(names(temp1), collapse = ", ")))
    } 
  } else {
    ifelse(size < 1, 
           n <- setNames(
             round(temp0 * size, digits = 0), names(temp1)),
           ifelse(
             all(sapply(temp1, length) >= size),
             n <- setNames(rep(size, length.out = length(temp1)),
                           names(temp1)),
{
  temp <- sapply(temp1, length)
  message(
    "Some groups---", 
    paste(names(temp[temp < size]), collapse = ", "),
    "---\ncontain fewer observations than desired number of samples.\n",
    "All observations have been returned from those groups.")
  n <- c(sapply(temp[temp >= size], function(x) x = size),
         temp[temp < size])[names(temp1)]
}))
  }
  
  seedme <- ifelse(is.null(seed), "No", "Yes")
  
  temp <- switch(
    seedme,
    No = { temp <- lapply(
      names(temp1), 
      function(x) temp1[[x]][sample(temp0[x], n[x], ...), ]) },
    Yes = { temp <- lapply(
      names(temp1),
      function(x) { set.seed(seed)
                    temp1[[x]][sample(temp0[x], n[x], ...), ] })})
  
  rm(.Random.seed, envir=.GlobalEnv) # "resets" the seed
  do.call("rbind", temp)
}
