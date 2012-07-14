## @knitr scriptsanddata
load.scripts.and.data = function(path,
                        pattern=list(scripts = "*.R$",
                                     data = "*.rda$|*.Rdata$"), 
                        ignore.case=TRUE) {
  # Reads all the data files and scripts from a specified directory.
  # In general, should only need to specify the directory.
  # Specify directories without trailing slashes.
  #
  # === EXAMPLE ===
  #
  #    scripts.and.data(c("~/Dropbox/Public", 
  #                       "~/Dropbox/Public/R Functions"))
  #
  # Note the construction of the scripts and data search matching!
  
  file.sources = list.files(path, 
                            pattern=pattern$scripts, 
                            full.names=TRUE, 
                            ignore.case=ignore.case)
  data.sources = list.files(path, 
                            pattern=pattern$data,
                            full.names=TRUE,
                            ignore.case=ignore.case)
  sapply(data.sources,load,.GlobalEnv)
  sapply(file.sources,source,.GlobalEnv)
}
