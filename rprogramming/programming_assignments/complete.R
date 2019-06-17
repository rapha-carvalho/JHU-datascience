# Part 2

## Write a function that reads a directory full of files 
##and reports the number of completely observed cases in 
##each data file. The function should return a data frame 
##where the first column is the name of the file and the second
##column is the number of complete cases.


complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form: 
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the 
  ## number of complete cases
  
  directory <- paste0(getwd(), "/", directory, "/")
  filenames <- paste0(directory, sprintf("%03d", id), ".csv")
  
  observations <- c()
  
  for (i in seq_along(id)) {
    actual.id <- id[i]
    dt <- read.csv(filenames[i])
    observations <- c(observations, sum(complete.cases(dt)))
  }
  names(observations) <- id
  observations <- stack(observations)
  names(observations) <- c("nobs", "id")
  return(observations[, c(2, 1)])
}

#Tests 

ifelse(sum(complete("specdata", 1)$nobs) == 117, TRUE, FALSE)
ifelse(sum(complete("specdata", c(2, 4, 8, 10, 12))$nobs) == 1951, TRUE, FALSE)
ifelse(sum(complete("specdata", 30:25)$nobs) == 3505, TRUE, FALSE)
ifelse(sum(complete("specdata", 3)$nobs) == 243, TRUE, FALSE)
