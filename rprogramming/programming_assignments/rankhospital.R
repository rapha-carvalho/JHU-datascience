rankhospital <- function(state, outcome, num) {
  root <- "/Users/raphaelcarvalho/Documents/Cursos/JHU-datascience"
  ## Read outcome data
  dt <- read.csv(paste0(root, "/rprogramming/programming_assignments/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv"), colClasses = "character")
  
  ## Check that state and outome are valid
  outcomes <- c("heart failure", "heart attack", "pneumonia")
  states <- as.character(unique(dt[, "State"]))
  if (!(state %in% states)) {
    return(stop("invalid state"))
  }
  if (!(outcome %in% outcomes)) {
    return(stop("invalid outcome"))
  }
  
  
  ## Return hospital name in that state with the required rank for 30-day death rate
  
  colnames.norm <- gsub("\\.", " ", colnames(dt))
  metrics.cols <- colnames.norm[grep("^Hospital 30 Day Death  Mortality  Rates from", colnames.norm)]
  match.col <- metrics.cols[grep(outcome, metrics.cols, ignore.case = TRUE)]
  colnames(dt) <- colnames.norm
  
  # Subset dataset columns
  dt <- dt[, c("State", "Hospital Name", match.col)]
  dt <- dt[which(dt$State == state), c("Hospital Name", match.col)]
  dt[[match.col]] <- suppressWarnings(as.numeric(dt[[match.col]], na.rm = TRUE))
  dt <- dt[order(dt[[match.col]]),]
  if (num %in% c("best", "worst")) {
    if (num == "best") {
      dt <- dt[order(dt[[match.col]], dt[["Hospital Name"]]),]
      rank <- dt[1, "Hospital Name"]
    } else {
      dt <- dt[order(dt[[match.col]], dt[["Hospital Name"]], decreasing = TRUE),]
      rank <- dt[1, "Hospital Name"]
    }
  } else {
    dt <- dt[order(dt[[match.col]], dt[["Hospital Name"]]),]
    rank <- dt[num, "Hospital Name"]
  }
  rank
}