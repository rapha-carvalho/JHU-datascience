library(dplyr)
## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
  i <- NULL 
  set <- function(y) {
    x <<- y
    i <<- NULL
  }
  get <- function() x 
  setInverse <- function(inverse) i <<- inverse
  getInverse <- function() i
  list(set = set, get = get, 
       setInverse = setInverse, 
       getInverse = getInverse)
}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
 i <- x$getInverse() 
 if(!is.null(i)) {
   message("getting cached data")
   return(i)
 }
 data <- x$get()
 i <- solve(data, ...)
 x$setInverse(i)
 i
}

# Testing 

m <- matrix(c(2, 4, 5, 3), 2, 2)
matrix(c(2, 4, 5, 3), 2, 2)
cacheSolve(makeCacheMatrix(m))
