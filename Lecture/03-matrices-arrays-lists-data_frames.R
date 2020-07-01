#### Class 3: Tuesday September 5

## Matrices and arrays.
## Lists.
## Data frames.

##**** Matrices and Arrays ****##
## Matrices and arrays are vectors with a ``dim''
## attribute set to a vector of 2 (for matrices) or
## more (for arrays) elements (each element adds a
## dimension) associated to it.

## A matrix is a particular case of an array
## (it is an array of dimension 2),
## but it is such an important particular case 
## that it will have a separate treatment.

## We have already created matrices (and arrays)
## by assigning a dimension vector
## to its ``dim'' attribute.

## Using the matrix function
matrix(1:8, nrow = 2)
matrix(1:8, ncol = 4)
## It assigns by column by default

## If you want to assign by row
matrix(1:8, nrow = 2, byrow = TRUE)

##**** Elements of Matrices ****##
(A <- matrix(10:19, nrow = 2))
A[7]   ## Remember that matrices are still vectors
A[1, 4] ## Row and Column desired [explore negative indexes]

##**** Index Matrices ****##
I <- matrix(c(1, 3,   ## Index Matrix
              1, 4,
              2, 2), ncol = 2, byrow = TRUE)
A[I]
A[I] <- 0
A

##**** Rows and Columns from Matrices ****##
A <- matrix(1:16, nrow = 4)
A[,]
A[, 2]
A[2,]

A[c(1, 3), c(2, 4)]

##**** Transpose of a Matrix ****##
(A <- matrix(10:19, nrow = 2))
t(A)
t(t(A))

##**** Different uses of function diag() ****##
diag(3)           ## 3x3 Identity matrix
diag(c(3, -1, 5))   ## 3x3 Square matrix with this diagonal

A
diag(A)           ## Diagonal of a matrix
sum(diag(A))      ## Calculate the trace of A

##**** Element by Element Product of Matrices ****##
(A <- matrix(1:4, nrow = 2))
(B <- matrix(2:5, nrow = 2))

A * B  ## Element by element product
(D <- matrix(1:6, nrow = 2))
A * D  ## Matrices need to have same number of rows
## and columns

##**** Matrix Product ****##
A %*% B   ## 2x2 * 2x2 = OK
A %*% D   ## 2x2 * 2x3 = OK
D %*% A   ## 2x3 * 2x2 = No!

##**** Concatenation of Matrices ****##
A
B

rbind(A,B)    # Vertically
cbind(A,B)    # Horizontally

##**** Operations on Rows and Columns of Matrices ****##
B
rowMeans(B)
rowSums(B)
colMeans(B)
colSums(B)

##**** Solving Linear Equations ****##
## Suppose we have the system A %*% x = b
A <- matrix(1:4, nrow = 2)  ## Matrix of coefficients
b <- c(3, -7)              ## Vector of independent terms
(x <- solve(A,b))         ## System solution

A %*% x                   ## = b. Verification

##**** Inverse of a square matrix ****##
## solve() is also used to invert a square matrix
solve(A)          ## Matrix inversion
A %*% solve(A)    ## Verification

## Your turn:
## Investigate matrix functions eigen, svd, qr, ...

 
## Your turn:
## Draw 1000 random samples of size 20 each from a
## standard normal distribution
## (remember you can use "rnorm" for that):
## 1) save all values in a 1000x20 matrix.
## 2) print the first 10 random samples (10x20 matrix)
## 3) calculate the 1000 sample means xbar
## 4) Verify numerically that E(xbar) = mu (approx solution)
## 5) Verify numerically that SD(xbar) = sigma/sqrt(n) 
## 6) Plot the empirical distribution (use function "hist")
##    of xbar


## Begin solution
## End solution



##**** Lists ****##
## A list is an object containing as elements objects of
## any type, including other lists.
L <- list(c(1, 3, 2),
          c("Two", "Words"),
          list(c(TRUE, FALSE, FALSE),
               "something"))
L
class(L)
str(L)

##**** Lists with Named Components ****##
## You can assign names to the elements of the list.
L <- list(number = c(1, 3, 2),
          char = c("Two", "Words"),
          other_list=list(logical = c(TRUE,FALSE,FALSE),
                          morechar = "something"))
L
class(L)
str(L)

##**** Accessing a Given List Component ****##
L[1]        ## Be careful about this way
str(L[1])
L[[1]]      ## Use this way
str(L[[1]])
L$number    ## or this way
str(L$number)
L[["number"]]


##**** Getting a Sub-List ****##
L[2:3]        ## This is right
L[[2:3]]      ## This does not work

L[c("number", "other_list")]        ## This is right
L[[c("number", "other_list")]]      ## This does not work

##**** Accessing Components of List Components ****##
L[[1]][2]
L$number[2]
L[[3]][[1]][2]
L$other_list$logical[2]
L[["other_list"]][["logical"]][2]

##**** Empty Lists and Adding Elements to Lists ****##
L <- list()       ## Empty list

L[[3]] <- c(2, -1)
L$morelogical <- c(FALSE, TRUE)

L

##**** Concatenating Lists ****##
L1 <- list(c(2,3), TRUE)
L2 <- list(NA, c("a", "v"))

c(L1, L2)



##**** Data Frames ****##
## Similar to Lists, but with a matrix-like structure.
df <- data.frame(num = c(3, 4, 2, -1),
                 char = c("a", "b", "b", "a"),
                 lgc = c(T, T, F, T))
df
str(df)
## NOTE: the character vector was converted to factor.
## To avoid set stringsAsFactors=FALSE.
df <- data.frame(num=c(3,4,2,-1),
                 char=c("a","b","b","a"),
                 lgc=c(T,T,F,T), stringsAsFactors = FALSE)
df
str(df)
## To set it as a global default
## (in general not recommended) run
## options(stringsAsFactors = FALSE)

##**** Dimension of Data Frames ****##
dim(df)
nrow(df)
ncol(df)

##**** Accessing Components of Data Frames ****##
df[1]
str(df[1])
df[[1]]
df[, 1]
df$num

## Matrix-Like Components
df[2, 1]
df[3, "lgc"]
df["3", "lgc"]
rownames(df) <- c("first", "second", "third", "fourth")
df
df["third", "lgc"]
df["3", "lgc"]


##**** Accessing R datasets ****##
## For a list of datasets
library(help = "datasets")

## Load CO2 dataset
data(CO2)

head(CO2)

str(CO2)


##**** attach() and detach() ****##
CO2$uptake[1:10]
uptake[1:10]
attach(CO2)
CO2$uptake[1:10]
uptake[1:10]
detach()
CO2$uptake[1:10]
uptake[1:10]

attach(CO2)
CO2$uptake[1:10]
uptake[1:10]
uptake[1:10] <- 0
detach()
uptake[1:10]
CO2$uptake[1:10]

## attach() and detach() can be used both with lists
## and dataframes.

##**** Writing/Reading Data to/from Files ****##

## Saving and Loading Human Readable Data
write.table(CO2, "../data/CO2.data")
write.csv(CO2, "../data/CO2.csv")

CO2.table <- read.table("../data/CO2.data")
str(CO2.table)
CO2.csv <- read.csv("../data/CO2.csv")
str(CO2.csv)

## Saving and Loading Binary Data
save(CO2, file="../data/CO2.RData")
CO2 <- NA
CO2
load(file="../data/CO2.RData")
head(CO2)


## Your turn:
## Make sure you have the library ggplot2 installed
## If not, install it by running the uncommented code below
## install.packages("ggplot2")
## Load the library
library(ggplot2)
## Activate the mpg data.frame provided by ggplot2
data(mpg)
## New versions of ggplot have all character variables, while
## older had factors. Transform manufacturer to factor
## to show how most data.frames treat character variables
mpg$manufacturer <- factor(mpg$manufacturer)
str(mpg)

## 1) Inspect the structure of mpg data.frame.
##    Note the kind of data provided

## 2) Run the summary function to learn more
##    about the variables

## 3) Get a subset of the data.frame including all
##    cars that are not ford nor audi

## 4) Determine if the manufacturer variable (that is a factor)
##    in your subset has or not dropped the now removed
##    manufacurers audi and ford

## 5) Devise a strategy to assure that the above factor has dropped
##    the levels that have no elements

## 6) Further subset the data making sure that only front drive
##    midsize cars model 2008 with at least 20 highway
##    or city miles per gallon are included.

## 7) Determine how many cars per manufacturer satisfy
##    these restrains. Only show manufacturers with
##    at least one vehicle.

## 8) Only show the case(s) with more cars
## Note: there might be ties...




## Begin solution
## End solution
