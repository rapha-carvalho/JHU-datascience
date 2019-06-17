# Part 3

## Write a function that takes a directory of data files 
## and a threshold for complete cases and calculates the 
## correlation between sulfate and nitrate for monitor locations 
## where the number of completely observed cases (on all variables) 
## is greater than the threshold. 

source("complete.R")

corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all variables) 
  ## required to compute the correlation between nitrate and sulfate;
  ## the default is 0
  
  ## Return a numeric vector of correlations 
  ## NOTE: Do not round the result!
  
  dir <- paste0(getwd(), "/", directory, "/")
  
  dt <- complete(directory)
  threshold.ids <- as.character(dt[dt$nobs > threshold, "id"])
  
  filenames <- paste0(dir, sprintf("%03s", threshold.ids), ".csv")
  correlations <- c()
  
  for (i in seq_along(threshold.ids)) {
    actual.id <- threshold.ids[i]
    dt.cor <- read.csv(filenames[i])
    dt.cor <- dt.cor[complete.cases(dt.cor), ]
    correlations <- c(correlations, cor(dt.cor$nitrate, dt.cor$sulfate))
  }
 correlations
}


# Tests 
cr <- corr("specdata", 150)

head(round(cr, digits = 8)) == c(-0.01895754, -0.14051254, -0.04389737, -0.06815956, -0.12350667, -0.07588814)
round(unname(summary(cr)), digits = 5) == c(-0.21057, -0.04999,  0.09463,  0.12525,  0.26844,  0.76313)

cr <- corr("specdata", 400)

head(round(cr, digits = 8)) == c(-0.01895754, -0.04389737, -0.06815956, -0.07588814,  0.76312884, -0.15782860)
round(unname(summary(cr)), digits = 5) == c(-0.17623, -0.03109,  0.10021,  0.13969,  0.26849,  0.76313)





