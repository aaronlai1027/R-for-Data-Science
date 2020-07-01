#### Class 5: Thursday January 25

## cat() and paste().
## Control structures (if, for, while, repeat).
## Vectorial approach: avoiding loops using the Apply family.


## cat and paste: functions to output and
##                concatenate objects.

## cat() outputs objects, concatenating them.
cat("Hello World!")
## Insert a newline (\n)
cat("Hello World!\nAnother Hello!\n\nYet Another!\n")

a <- 10:1
## By default, cat will separate the elements with a space.
cat(a)
## but you can specify your separator
cat(a, sep="-:-")
## For example, you can separate with a newline
cat(a, sep="\n")

## You can mix objects of different type
## (such as character and numeric)
a <- 1 + 1
cat("The result of 1 + 1 is", a)

## You can send the output to an external file
a <- 10:1
cat(a, sep="\n", file="a.txt")

## You can "pipe" the output to an external
## program (in Linux and Mac).
## Next two commands may not work in Windows
cat(a, sep="\n", file="|sort")
## Note: cat sent the initial output to the program sort
##       the observed output is from the program sort
## You could also ask sort to save its output
## in an external file (again, not in Windows)
cat(a, sep="\n", file="|sort > a_sorted.txt")

## You cannot save the "result" to an object.
## cat only outputs (we will use paste() for that)
s <- cat(a)
s

## paste() concatenate vectors after converting
## them to character (and the result can be
## saved in an object)
(a <- 1:5)
paste(a)
## It has converted them to a character vector.
## Same as using as.character()
as.character(a)
## Of course, this is not the reason to use paste().

## We can save the result to an object
b <- paste(a)
b

## paste() can be used, for example to create names
## mixing a prefix with a sequence
paste("Var", a)
## Note: we have a vector of concatenated strings.
## The default separator is space. It can be changed
## to whatever you want.
paste("Var", a, sep="_")
## To remove separator:
paste("Var", a, sep="")
## paste0() is a shorcut to achieve the same
paste0("Var", a)

## collapse allows to transform the obtained vector
## into a single string using that separator.
paste("Var", a, sep="", collapse="-:-")
## Note: this is a scalar (only one element)
## collapse also works with paste0().
paste0("Var", a, collapse="-:-")



## If you want to submit all your output to an
## external file, you can use sink() for that
(a <- 3:1)
## Once you call sink() with the name of the external
## file, all output will be sent to it
## until it finds another sink() without parameters.
sink("results.txt")
(b <- 1:10)
(d <- 11:20)
b+d
sink()
## All output now will go to the console again
(e <- 4:9)
## Check the file results.txt to see if the
## output was sent to it.



## Control structures
## You use control structures (if(), for(),
## while(), and repeat) to alter the flow
## of your program.

## Conditional execution: if clause.
## Use if() to evaluate a logical expression
## and run the contained code *only* when the
## logical expression evaluates to TRUE
cond <- TRUE
if (cond) {
  cat("cond is TRUE")
}

cond <- FALSE
if (cond) {
  cat("cond is TRUE")
}
## Note: if you have only one expression, there is no
## need to use {}. But to avoid problems, it is advisable
## to use them even in one expression cases.

## Of course the logical expression can be as complicated
## as needed, including parentheses, && (and) and || (or)
a <- 24
b <- 12
if (a < 50 && (a-b > 7 || a/b < 2)) {
  cat("cond is TRUE")
}

## Note that there is a difference between && and &,
## and || and |. The cases with only one & or | are
## used for elementwise comparisons of vectors (as
## arithmetic operators). && and || are used in if
## clauses where scalars are compared.

## You can use and "else" clause to execute code
## when the if condition is false
cond <- TRUE
if (cond) {
  cat("cond is TRUE")
} else {
  cat("cond is FALSE")
}  

cond <- FALSE
if (cond) {
  cat("cond is TRUE")
} else {
  cat("cond is FALSE")
}  


a <- 7
b <- 5
if (a > 3 && b < 8) {
  cat("both conditions TRUE")
} else {
  cat("at least one condition is FALSE")
}  
## Modify a and b above to change behavior

## If you want to test several possibilities,
## you can use "else if()" and even a final
## "else" as a catch all strategy at the end.
a <- 7
b <- 5
if (a > 9 && b < 8) {
  cat("both conditions TRUE")
} else if (a > 9) {
  cat("first condition TRUE")
} else if (b < 8) {
  cat("second condition TRUE")
} else {
  cat("no condition TRUE")
}  
## Keep in mind that the conditions will be
## tested orderly. Only the first condition that
## evaluates to TRUE will have its code executed.
## If there are other following conditions that
## also test TRUE, they will *not* be executed.
## The "else" code will only be executed if *none*
## of the conditions evaluate to TRUE.

## You should not use vectors in if() clauses, only
## scalars. If you use a vector, only the first
## element will be tested and a warning will
## be printed, as demonstrated below
a <- 7:10
b <- 5:8
if (a > 9 && b < 8) {
  cat("both conditions TRUE")
} else if (a > 9) {
  cat("first condition TRUE")
} else if (b < 8) {
  cat("second condition TRUE")
} else {
  cat("no condition TRUE")
}  


## You can use the ifelse() function if
## you want to traverse a vector. The condition
## that each element of the vector needs to
## satisfy is specified as first element.
## The second elements is what to do when
## the condition evaluates to TRUE, while
## the third element is what to do when the
## condition evaluates to FALSE. The result
## will have the same number of elements
## as the first element
a <- 9:22
(b <- ifelse(a %% 2 == 0, "even", "odd"))
data.frame(a,b)

## Use of & or |
(b <- ifelse(a %% 5 == 0 & a %% 2 == 0, "div by 2 and 5", 
             "not div by 2 and 5"))
data.frame(a,b)

## Nested ifelse
(b <- ifelse(a %% 5 == 0, "div by 5", 
             ifelse(a %% 2 == 0, "even", "odd")))
data.frame(a,b)


## Loops. You can create loops with
## for(), while(), and repeat.

## for() loop.
## The syntax is
## for (element in object)
## where object is any object
## and element will have assigned
## sequencially each element of the object

## For example, using a numerical sequence
a <- 1:10
for (i in a) {
  print(i^2)
}

## Using a character vector
a <- paste0("Var", 1:10)
for (i in a) {
  print(i)
}

## Using a list
a <- list(c(1,2,3),
          c(TRUE, FALSE),
          data.frame(a=c(3,2,1),
                     b=c("a","b","c")))
for (i in a) {
  print(i)
}

## Using an if() inside a for() loop.
data(CO2)
for (i in 1:nrow(CO2)) {
  if (i %% 2 == 0 && i < 13) {
    print(CO2[i,])
  }
}

## Use of "next" and "break".
## "next" is used in situations where you do not
## want to continue evaluating code from the current
## iteration, but you want to jump straight to the following.
## "break" is used when you want to abort the loop.
## Of course, it makes sense that there will be some
## if() clause testing something for you to modify
## the behavior of the loop.
## For example, if I only want to output only the even rows
## of the data.frame, and only the first 12 rows, I could
## do something like this:
for (i in 1:nrow(CO2)) {
  if (i %% 2 == 1)
    next
  else if (i >= 13)
    break
  print(CO2[i,])
}


## while() loop
## Loops can be also performed with a while() loop.
## While the condition evaluates to TRUE, the loop
## will be performed. Once it evaluates to FALSE,
## it will stop. It is needed to have a strategy
## such that at a certain point the condition will
## change from TRUE to FALSE, to avoid an
## infinite loop. Also you need to make sure
## that the condition evaluates to TRUE at the
## very beginning, or the loop will not be executed.
## (of course, there may be cases where times this
## may be what is wanted)
a <- 1
while (a < 10) {
  cat(a, "\n")
  a <- a + 1
}

## repeat loop.
## This is still another possibility of a loop. The
## only way to get out of it is with a "break" clause.
## So you need a strategy involving an if() clause
## with a "break" inside it.
a <- 1
repeat {
  cat(a, "\n")
  a <- a + 1
  if (a >= 10)
    break
}


## Performing loops in R may be a bad idea. In the past
## there were performance reasons. Nowadays it is possible
## not that bad. However, other approaches can be more
## succint and elegant, using the vectorial capabilities of R.
## There are functions (apply(), lapply(), sapply(),
## and tapply()) that can
## traverse objects and apply a function to each
## element of the object, in a compact and
## fast way.

## apply() can apply a function to margins of a
## matrix or array

(a <- matrix(rnorm(20), nrow=10))
## If we want to find the mean by row
apply(a, 1, mean)
## If by column
apply(a, 2, mean)

## For number of elements:
apply(a, 1, length)
## If by column
apply(a, 2, length)

## The result does not need to be a single number
apply(a, 2, summary)

## apply() also works with data.frames
## As data.frames can have columns of different
## nature (numeric, character, logical), you
## may need to work on subsets of it to avoid
## raising errors.
CO2s <- CO2[1:20, c("conc", "uptake")]
apply(CO2s, 1, mean)
apply(CO2s, 2, mean)


## lapply() can apply a function to each element of a list.
lst <- list(1:20, seq(-2,15,l=200), rnorm(25))

lapply(lst, mean)
lapply(lst, length)
## lapply() returns a list of results

## sapply() is a variant that tries to return the
## most compact representation of the result
sapply(lst, mean)
## For example a vector in the above case
sapply(lst, length)

## Remember that data.frames are lists too. So you
## can use lapply() and sapply() on them.
lapply(CO2s, mean)
sapply(CO2s, mean)

## tapply() can be used with "ragged arrays", that are
## composed by a vector of values and a vector (or factors)
## of categories used to group the values. Each group may
## have different number of elements (this makes it ragged).
## For example, "incomes" has the values in which we want to
## apply a function, and "statef" the groups to which each
## of the values belong.
incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69,
             70, 42, 56, 61, 61, 61, 58, 51, 48, 65,
             49, 49, 41, 48, 52, 46, 59, 46, 58, 43)
state <- c("tas", "sa",  "qld", "nsw", "nsw", "nt",
           "wa",  "wa",  "qld", "vic", "nsw", "vic",
           "qld", "qld", "sa",  "tas", "sa",  "nt", 
           "wa",  "vic", "qld", "nsw", "nsw", "wa",
           "sa",  "act", "nsw", "vic", "vic", "act")
## tapply() is used in this way to find the mean per group
tapply(incomes, state, mean)
## To count how many elements each group has
tapply(incomes, state, length)
## Of course the above could have been done with table()
## alone in state (without using incomes)
table(state)
## We could have used a factor too
statef <- factor(state)
tapply(incomes, statef, mean)

## We could have two grouping variables
genderf <- factor(c("f", "m",  "f", "m", "m", "f",
                    "m",  "f",  "f", "f", "f", "f",
                    "f", "m", "f",  "m", "f",  "m",
                    "m",  "f", "f", "m", "m", "f",
                    "m",  "f", "m", "f", "m", "m"))
## In this case, the categories need to be provided
## as a list.
tapply(incomes, list(statef,genderf), mean)
tapply(incomes, list(statef,genderf), length)

