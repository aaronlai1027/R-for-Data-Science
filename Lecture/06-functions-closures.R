## User defined functions
## A named function has the structure:
## funcname <- function(arg1, arg2, ...) expression
## where:
## * funcname is the name of the function
## * arg1, arg2, ... are parameters to use by the function
## * expression is any R expression, usually a
##   grouped {} collection of expressions
## * Last expression on the collection is returned
##   as the value of the function

## Function with one expression. It takes two parameters
## that will be used as variables inside the function.
## The function returns the sum of both parameters.
func1 <- function(a, b) a + b
## You invoke the function as usual
func1(2, 3)
func1(-4, 12)

## Same function as above, but using grouping
func1 <- function(a, b) {
  a + b
}
func1(2, 3)
func1(-4, 12)

## Next will raise an error as the function expects
## two parameters, not less, not more.
func1(3)
func1(3, 4, 5)


## You can establish default values for the parameters
## that will be used if the caller does not
## provide them.
## For example, we will set default values for
## parameters b and c, but not for a.
func2 <- function(a, b = 3, c = 8) a + b + c

## If we provide all parameters, the provided values
## will be used.
func2(2, 1, 5)
## Here we do not provide the value for c. Hence, its
## default value (8) will be used.
func2(-4, 12)
## We only provide a.
func2(3)
## This will raise an error, as a is expected, with no
## default.
func2()

## If you specify the names on the calling side, you can
## supply the parameters in any order (if unnamed, they
## need to be in the expected order).
func2(2, c = 5, b = 1)
func2(c = 5, b = 1, a = 2)

## Grouping multiple expressions
## More elaborate function to
## calculate t statistic for a t-test
twosam <- function(y1, y2) {
  n1 <- length(y1); n2 <- length(y2)
  yb1 <- mean(y1); yb2 <- mean(y2)
  s1 <- var(y1); s2 <- var(y2)
  ## Calculate pooled sample variance
  s <- ((n1 - 1)*s1 + (n2 - 1)*s2)/(n1 + n2 - 2)
  ## Calculate the t statistic
  tst <- (yb1 - yb2)/sqrt(s*(1/n1 + 1/n2))
  ## Return the t statistic
  tst
}

twosam(rnorm(20,5), rnorm(20,5))
twosam(rnorm(20,5), rnorm(20,2))


## Ellipsis argument.
## Useful when you do not know in advance
## how many parameters will be supplied.
## all those parameters are inserted into
## a list that you can access by using
## list(...)
myfunc <- function(a, ...) {
  print(a)
  print(list(...))
}

myfunc(3, d=3, g="hello", 7, "bye", f=0)
## We have supplied named and unnamed
## elements.



## Use of control structure inside functions.
## You can have control structures
## (if(), for(), while(), repeat) inside a function,
## which seems the more natural place to use them.
func7 <- function(n) {
  while (n < 5) {
    cat(n, "\n")
    n <- n + 1
  }
  n
}

func7(0)

## The above while loop can be replaced by using
## a recursive function (or a function that
## calls itself)
func8 <- function(n) {
  if (n >= 5)
    return(n) ## exit strategy
  cat(n, "\n")
  
  func8(n + 1) ## call to itself
}

func8(0)

## Defining your own binary operator
"%=|=%" <- function(a, b) {
  a^2-a*b+b
}

3 %=|=% 5

## Another example, returning a matrix
"%==%" <- function(a, b) {
  matrix(rep(0, a*b), nrow = a)
}

3 %==% 5

## Your turn
## Create two functions:
## 1) mymean(numvec), which calculates the mean of numvec
## 2) mymedian(numvec), which calculates the median of numvec
## then use the functions mean() and median()
## to verify for correctness.
## Hint 1: median needs two approaches depending if there is
##         an odd or even number of elements
## Hint 2: you may need to use one of the following functions
a <- c(4,8,2,9,5,9,4,7,3,9)
sort(a)
order(a)
rank(a)

## Begin solution
## End solution



## Scope or visibility of variables
func3 <- function(a) {
  x <- a + 7
  print(x)
}

func3(3)
x
## x has been defined inside the function,
## so it exists only in a local environment,
## and not in the global environment (where we
## are performing operations).

## If we assign a value to x in the global
## environment
x <- 24
## and we call the function again
func3(3)
## the assignment to x inside the function
## will not alter the value of x in the
## global environment.
x
## The created function has its own environment
## where the variables are isolated from
## the global environment (or other environments).

## However, from inside the function, the variables
## of the global environment are visible, but
## (in principle) read only.

func33 <- function(a) {
  a + xx
}

xx <- 2
func33(8)
## The operation was performed using a, supplied to
## the function, and xx, in the global environment.

func333 <- function(a) {
  xx <- a + 1
  print(xx)
}
func333(8)
xx


## How to modify variables in an enclosing environment?
## The variable y has still not been defined
y
## so it raises an error when invoked.

## If we use inside a function the double assignment "<<-"
## then the variable y will be searched in all enclosing
## environments and assigned in the first where it is defined.
## If it is not found, it will be created in the global
## environment.
func4 <- function(a) {
  y <<- a + 7
  print(y)
}
y
func4(3)
y
## y was created in the global environment.

y <- 24
func4(3)
y
## The value of y has been modified.
## It is not recommended (in the majority of cases)
## to modify in this way variables in the
## global environment.

## The following case will have two enclosing
## environments, and it may be a very good way to
## use <<-
## func5 is a function that itself defines a
## function inside (func6). z will be defined
## inside func5 before calling func6. When
## func6 modifies z with <<-, the z in
## func5 will be modified, but not the z
## in the global environment.
func5 <- function(a) {  
  
  func6 <- function(b) {
    z <<- b
  }
  
  z <- a
  print(z)
  func6(2)
  print(z)
}

func5(8)
z
## As you can see, invoking z in the global
## environment raises an error.
## Also, func6 is internal to func5, and
## not defined in the global environment
func6(10)
## so invoking it raises an error.

## Functions are objects
funcl1 <- function(a, b) a + b
funcl2 <- function(a, b = 3, c = 8) a+b+c
## As such, you can create, for example, a list with
## functions as members
(myfunctions <- list(funcl1, 3, othername = funcl2))
## and you can even invoke them as elements of lists
myfunctions[[1]](3, 7)
myfunctions$othername(3)
## note that funcl2, from the list perspective,
## is called othername.


## Closures

## Let's start with a normal function
a <- function() 1 + 1
## You can inspect the code
a
## You call it and it always returns the same
a()

## Next step. Let's create a function that returns
## a function.
b <- function() {
  function() 2 + 1
}
## Inspect the code
b
## Let's call the function and assign its return
## value (that is a function) to an object name
d <- b()
## Inspect the code.
## NOTE: in addition to the code of the function,
##       there is and environment attached. It is
##       the calling environment when the function
##       was created.
d
## d is a closure.
## Anyway, it also returns always the same when called.
d()

## This next example shows how closures can be used
## to encapsulate variables.
e <- function() {
  n <- 1
  
  function() (n <<- n + 1)
}

f <- e()
f
## Look what happens if we call the closure
## several times
f()
f()
f()
## The results change each time!

## This is a variant, as the parameters to the
## function are variables inside the function
g <- function(n = 1) {
  
  function() (n <<- n + 1)
}
h <- g()
i <- g(8)

h()
i()
n

## Returning more than one closure
j <- function(n = 1) {
  
  list(up = function() (n <<- n + 1),
       dn = function() (n <<- n - 1))
}
k <- j()
l <- j(15)

k
l

k$up()
k$dn()

l$up()
l$dn()

## Creating object orientation feel
## with S3 classes
open.account <- function(total) {
  n.dep <- 1
  list(
    deposit = function(amount) {
      if(amount <= 0)
        stop("Deposits must be positive!\n")
      total <<- total + amount
      n.dep <<- n.dep + 1
      cat(amount, "deposited. Your balance is", total)
      cat(". Your average deposit is ", total/n.dep, ".\n", sep = "")
    },
    balance = function() {
      cat("Your balance is", total)
      cat(". Your average deposit is ", total/n.dep, ".\n", sep = "")
    }
  )
}
lily <- open.account(200)
ross <- open.account(100)

lily$deposit(100)
ross$deposit(50)
lily$deposit(30)
ross$deposit(-20)

lily$balance()
ross$balance()
open.account <- function(total) {
  n.dep <- 1
  
  deposit <- function(amount) {
    if(amount <= 0)
      stop("Deposits must be positive!\n")
    total <<- total + amount
    n.dep <<- n.dep + 1
    cat(amount, " deposited. ", sep = "")
    balance()
  }
  
  balance <- function() {
    cat("Balance:", total)
    cat(". You made ", n.dep," deposits, averaging ", total/n.dep,
        ".\n", sep = "")
  }
  
  list(deposit = deposit,
       balance = balance)
}
lily <- open.account(200)
ross <- open.account(100)

lily$deposit(100)
ross$deposit(50)
lily$deposit(30)
ross$deposit(-20)

lily$balance()
ross$balance()

## There is a new package, R6, providing
## many aspects of a real object oriented language.
## You can investigate it on your own.

## Your turn
## Modify open.account() so it is able to:
## 1) print the balance the first time it is called.
## 2) accept withdrawals
## 3) perform a transfer between two accounts.
##    It should be invoked as: 
##    lily$transfer(70, ross)

## Begin solution
## End solution
