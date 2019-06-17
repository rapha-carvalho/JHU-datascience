
# Part 1
## Write a function named 'pollutantmean' that calculates the mean 
#of a pollutant (sulfate or nitrate) across a specified list of monitors.

dir <- paste0(getwd(),"./rprogramming/programming_assignments/specdata/")



pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files 
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the 
  ## mean; either "sulfate" or "nitrate". 
  
  ## 'id' is an integer vector indicating the monitor ID numbers 
  ## to be used. 
  
  ## Return the mean of the pollutant across all monitors list 
  ## in the 'id' vector (ignoring NA values)
  ## NOTE: Do not round the result! 
  
  directory <- paste0(getwd(), "/", directory, "/")
  filenames <- paste0(directory, sprintf("%03d", id), ".csv")
  pollutant.values <- c()
  
  for (i in filenames) {
    dt <- read.csv(i)
    pollutant.values <- c(pollutant.values, dt[[pollutant]])
  }
  pollutant.mean <- mean(as.numeric(pollutant.values), na.rm = TRUE)
  return(pollutant.mean)
}

#Tests 
ifelse(round(pollutantmean("specdata", "sulfate", 1:10), digits = 6) == 4.064128, TRUE, FALSE)
ifelse(round(pollutantmean("specdata", "nitrate", 70:72), digits = 6) == 1.706047, TRUE, FALSE)
ifelse(round(pollutantmean("specdata", "nitrate", 23), digits = 6) == 1.280833, TRUE, FALSE)



