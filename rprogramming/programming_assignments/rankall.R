rankall <- function(outcome, num = "best") {
  root <- "/Users/raphaelcarvalho/Documents/Cursos/JHU-datascience"
  ## Read outcome data
  dt <- read.csv(paste0(root, "/rprogramming/programming_assignments/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv"), colClasses = "character")[,c(2,7,11,17,23)]
  
  ## Check that state and outome are valid
  outcomes <- c("heart failure", "heart attack", "pneumonia")
  if (!(outcome %in% outcomes)) {
    return(stop("invalid outcome"))
  }
  
  ## Normalizing column names 
  
  colnames.norm <- gsub("\\.", " ", colnames(dt))
  metrics.cols <- colnames.norm[grep("^Hospital 30 Day Death  Mortality  Rates from", colnames.norm)]
  match.col <- metrics.cols[grep(outcome, metrics.cols, ignore.case = TRUE)]
  colnames(dt) <- colnames.norm
  
  ## Subsetting the dataset
  dt <- dt[, c("Hospital Name", "State", match.col)]
  colnames(dt) <- c("hospital", "state", "metric")
  dt$metric <- as.numeric(dt$metric)
  dt <- dt[!is.na(dt$metric), ]
  
  ## Creating a list of dataframes for each state 
  splitted.dt <- split(dt, dt$state)
  rank <- lapply(splitted.dt, function(x, num) {
    x <- x[order(x$metric, x$hospital), ]
    if (num == "best") {
      return (x$hospital[1])
    } else if (num == "worst") {
      return(x$hospital[nrow(x)])
    } else {
      return(x$hospital[num])
    }
  },num)
  return(data.frame(hospital=unlist(rank), state=names(rank)))
}