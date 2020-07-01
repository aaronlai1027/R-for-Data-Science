#### Class 11: Tuesday February 20

## Topics
## Data transformation: `dplyr` and base R.
## `filter()` and `subset()`
## `arrange()`.
## `select()`.
## `mutate()` and `within()`.
## `transmute()`.
## `with()`.
## `summarise()`.
## `group_by()`.

## install.packages("devtools")
## devtools::install_github("hadley/yrbss")
## library(yrbss)

## data(survey)
## save(survey, file = "survey.RData")
load(file = "data/survey.RData")
dim(survey)


## Let's see the beginning of the data, and some columns,
## using direct subsetting:
  
survey[1:10, 4:11]

## You can use `View` to have an interactive tabular representation:

# View(survey)   ## Uncomment to run

## `dplyr`
## by Hadley Wickham, Romain Francois, and RStudio
## <https://cran.r-project.org/web/packages/dplyr/index.html>
## allows to perform data transformations in the way data science
## projects are performed these days in R.

library(dplyr)

##`survey` is a *tibble*, an extension of `data.frame`
## that you can use as a normal `data.frame` (we will see
## details of tibbles later.
## Once you load `dplyr`, it creates methods to handle the
## `print` of this kind of data:
  
str(survey)

## We will see the following verbs (functions) that are
## included in the package `dplyr`:
    ## filter observation by a condition (`filter`),
    ## reorder the rows (`arrange`),
    ## pick variables by their names (`select`),
    ## create new variables with functions of existing variables (`mutate`), or
    ## collapse many values down to a single summary (`summarise`).

## We will also illustrate some base R counterparts.

### `filter` (`dplyr`) and `subset` (`base`)

## Use filter to get a subset (of rows) from a data.frame.

## Example: how do we obtain a subset of survey containing
## only responses from 2013 and females?

filter(survey, year == 2013, sex == "Female")

## `filter` takes a dataframe (or tibble)
##  and produces a dataframe (or tibble).
## It joins the conditions separated by commas with & (AND).
## You can also do the following (only one filter argument)
filter(survey, year == 2013 & sex == "Female")

## in which case there is no difference in relation
## to use the `base` function `subset()`.
subset(survey, year == 2013 & sex == "Female")

## Your condition can be as complicated as needed, using parentheses,
## & (and) and | (or). Remember to use `==` instead of `=`.
## You can also use >, >=, <, <=.

## To achieve the same using direct subsetting,
## you should use the more complicated expression
survey[survey$year == 2013 & survey$sex == "Female" & 
         !is.na(survey$year) & !is.na(survey$sex),, drop = FALSE]

## `drop = FALSE` is used to be certain that the result will
## be a data.frame. In this case it is not needed, as shown below:
survey[survey$year == 2013 & survey$sex == "Female" & 
         !is.na(survey$year) & !is.na(survey$sex),]

## Why it may be needed? If possible, R tends to simplify objects.
## This means that if your source is a data.frame and you ask to
## return only one column, the returned object would be a vector
## instead of a data.frame.

## Note: as survey is a tibble, this problem does not appear.

## Let's make sure we are working with a data.frame:
survey_df <- as.data.frame(survey)

str(survey_df[survey_df$year == 2013 & survey_df$sex == "Female" & 
                !is.na(survey_df$year) & !is.na(survey_df$sex), "weight"])

str(survey_df[survey_df$year == 2013 & survey_df$sex == "Female" & 
                !is.na(survey_df$year) & !is.na(survey_df$sex), "weight", drop = FALSE])

## This does not happen if you ask for more than one column:
str(survey_df[survey_df$year == 2013 & survey_df$sex == "Female" & 
                !is.na(survey_df$year) & !is.na(survey_df$sex),
              c("weight", "age")])

## nor if your source is a tibble and you ask for a column:
str(survey[survey$year == 2013 & survey$sex == "Female" & 
             !is.na(survey$year) & !is.na(survey$sex), "weight"])

## It is important the `is.na` to make sure that eventual `NA`
## results are not included. For example:
a <- c(NA, 7, 3, 8, NA, 2)
a[a < 4]

a[a < 4 & !is.na(a)]

## And in fact there are several `NA`s in survey:

survey[survey$year == 2013 & survey$sex == "Female",, drop = FALSE]

## In conclusion, even if you could do everything using direct subsetting,
## you need to keep track of more details and the syntax is more involved
## (and easier to get it wrong). `filter` and `subset` are simpler to use.


#### Your turn:
## Using filter, get a subset from survey containing
## Hispanic/Latinos or Asians (race7) males up to 16 years old
## with a bmi in the interval [20, 23] who never wore a helmet (q8).


## Begin solution:
## End solution

### `arrange` (`dplyr`)

## Use `arrange` to reorder the dataframe by certain columns.
## The ordering will be applied left to right:
arrange(survey, year)


#### Your turn:
## Sort as above, but using direct subsetting:



## Begin solution
## End solution

#### Your turn:
## Sort, using `arrange`, by year, sex and stheight.
## The first two variables in ascending order, the last one in
## descending order (see help).

## Begin solution
## End solution


### `select` (`dplyr`)

## Keep only certain columns, disregarding the rest:

select(survey, year, sex, q8)

## Same by direct subsetting:
survey[, c("year", "sex", "q8")]

## Same using `subset`:
subset(survey, select = c(year, sex, q8))

## You can select an interval of variables
select(survey, year, sex, q8:q11)

## or exclude an interval
select(survey, -(q8:qn86))

## You can use helper functions, that **only** work inside `select`:
  ##  - `starts_with`
  ##  - `ends_with`
  ##  - `num_range`
  ##  - `contains`
  ##  - `matches`

#### Your turn:
## Using the helper functions, select columns that
## 1. start with "q" 
## 2. do not start with "q"
## 3. end with "9"
## 4. are contained between "q8" and "q13"
## 5. contain the word "sleep"
## 6. start with "q" or "qn" followed by number(s)

## Begin solution
## End solution


## You can rename variables while selecting:
select(survey, hello = q9)

## If you just want to rename some variables without selecting,
## use `rename`:
rename(survey, hello = sitetype)


### `mutate` (dplyr) and `within` (`base`)
## `mutate` can be used to add new columns to a data.frame.

## For example, the weight `stweight` is specified in Kg.
## To add a column containing the weight in Lb, we can do:
mutate(survey, stweight_lb = stweight / 0.454)


#### Your turn:
## Include heights in inches.
## Show only the columns containing the weights (in Kg and Lb)
## and heights (in m and in):

## Begin solution
## End solution


## Suppose we want to verify if the calculation of
## bmi (body mass index) is correct. We know the formula for bmi when
## weight is in Kg (`stweight`) and height in m (`stweight`) is

## bmi = weight/height}^2

## Let's first find a subset of the dataset such that
## no rows with missing required info is included, and containing
## only the columns of interest.

#### Your turn:
## 1. Using `filter` and `select`, obtain a subset of `survey` containing
## only rows with no NAs for `stheight` and `stweight`,
## and columns `record`, `stheight`, `stweight`, and `bmi`.
## 2. Do the same using `subset`.

## Begin solution
## End solution

#### Your turn:
## 1. Use `mutate` to add a new column to `survey_red`
## containing the calculated bmi. Add another column
## containing the absolute difference between the
## calculated bmi and provided bmi.
## 2. Are there cases where provided and calculated bmi disagree
## by at least .3 bmi units? If so, show them from largest
## to shortest discrepancy.

## Begin solution 
## End solution

## NOTE: base R has another function, `transform`, similar to
## `mutate` in syntax but that does not allow for creation
## of columns based on just created columns. `mutate` represents
## an improvement over `transform`.

## Instead of `mutate`, you could use the `base` function `within`
## that works in the following way:
within(survey, {
  stweight_lb <- stweight / 0.454
})


#### Your turn:
## * Use `within` to add a new column to `survey_red`
## containing the calculated bmi. Add another column
## containing the absolute difference between the
## calculated bmi and provided bmi. In addition,
## remove columns `stweight` and `stheight`.

## Begin solution:
## End solution


### `transmute` (`dplyr`)

## `transmute` differs from `mutate` in the fact that the newly
## created columns are the *only* ones returned.
transmute(survey,
          bmi_calc = stweight/stheight^2,
          abs_diff_bmi = abs(bmi_calc - bmi))


### Useful functions in data transformations
## `+`, `-`, `*`, `/`, `^`, `%/%` (integer division), `%%` (remainder)
## `log()`, `log2()`, `log10()`, `sin()`, `cos()`, `pnorm()`, `qnorm()`, etc
## `lead()`, `lag()`

a <- 1:10
data.frame(a, lead = lead(a), lag = lag(a))

## `cumsum()`, `cumprod()`, `cummin()`, `cummax()` (`base`).
## `cummean()` (`dplyr`)

set.seed(1)
b <- sample(a)
data.frame(b, cumsum = cumsum(b), cumprod = cumprod(b),
           cummin = cummin(b), cummax = cummax(b), cummean = cummean(b))

## Effect of `NA`:
b <- sample(c(a, NA))
data.frame(b, cumsum = cumsum(b), cumprod = cumprod(b),
           cummin = cummin(b), cummax = cummax(b), cummean = cummean(b))

## Ranking. `rank` is from `base`, the rest (shown below) are from `dplyr`.
## See documentation for details. G&H state `min_rank` does the most
## *usual* type of ranking.
y <- c(1, 2, 2, NA, 3, 4)
data_frame(
  rank(y),
  row_number(y),
  min_rank(y),
  dense_rank(y),
  percent_rank(y),
  cume_dist(y)
)

### `with` (`base`)

## `with` creates an environment where the variables
## of the data_frame or list are local.

## Instead of:
table(survey$age, useNA = "always")
## you can do:
with(survey, table(age, useNA = "always"))

## Moreover, you can run several commands in a block (`{}`):
with(survey, {
  print(table(age, useNA = "always"))
  print(table(sex, useNA = "always"))
  print(table(race4, useNA = "always"))
  print(summary(stheight))
})

## It can be very useful if you want to run several functions
## that are *conventional* R.


### `summarise` and `group_by` (`dplyr`)
## `summarise` is useful to get summaries for the data, by
## calling *aggregate functions* that input a vector and output a value,
## such as `mean`, `median`, and `sd`.
summarise(survey,
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 

## `summarise` will fail if your aggregate function returns
## more than one result.

summarise(survey, summary = summary(stheight))

summary(survey$stheight)

## If you pre-process the `data_frame` with `group_by`, you
## can obtain summaries according to the desired grouping.
survey_grouped <- group_by(survey, year)
summarise(survey_grouped,
          total = n(),  ## Function to use internally of summarise only
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 

## Note the `NaN` (not a number). It is because all cases are `NA`.
## `mean` and `sd` return `NaN` instead of `NA`. `median` returns `NA`.

survey_grouped <- group_by(survey, year)
summarise(survey_grouped,
          count = n(),
          countNA = sum(is.na(stheight)),
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 

mean(c(2,4,NA), na.rm = TRUE)
mean(c(NA,NA,NA), na.rm = TRUE)

## Note we had to save an intermediate state of `survey` into
## `survey_grouped`, before calling `summarise`.

## Suppose you do not want to save intermediate results. One
## possible technique would be the following:
summarise(group_by(survey, year),
          count = n(),
          countNA = sum(is.na(stheight)),
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 
## where you feed the result of `group_by` directly to `summarise`.

## In this particular case, it seems completely fine. However, suppose
## that you have to perform more data transformations before calling
## `summarise`.
A <- select(survey, year, stheight)
B <- filter(A, !is.na(stheight))
C <- group_by(B, year)
summarise(C,
          count = n(),
          countNA = sum(is.na(stheight)),
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 

## Avoiding creation of intermediate temporary objects:
summarise(group_by(filter(select(survey, year, stheight), !is.na(stheight)), year),
          count = n(),
          countNA = sum(is.na(stheight)),
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 

## The approach works perfectly fine, but more complicated,
## difficult to follow, and error prone.

## An alternative approach it to use the **pipe**, `%>%`. Next lecture.

