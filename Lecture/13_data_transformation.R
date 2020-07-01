## Topics
## Data transformation:
##    * The `magrittr` pipe `%>%`.
##    * Missing values and more aggregate functions.
##    * `count()`.
##    * Arithmetics with logicals.
##    * Using `group_by()` with `filter()` and `mutate()`.
##    * Window Functions.


## install.packages("devtools")
## devtools::install_github("hadley/yrbss")
##library(yrbss)

##data(survey)
## save(survey, file = "survey.RData")
load(file = "data/survey.RData")
dim(survey)
## The `magrittr` pipe `%>%`

# * The pipe `%>%` is implemented by the package `magrittr` by
# Stefan Milton Bache and Hadley Wickham:

#<https://cran.r-project.org/web/packages/magrittr/index.html>

library(dplyr)
library(magrittr)

## * Instead of:
survey_grouped <- group_by(survey, year)
summarise(survey_grouped,
          count = n(),
          countNA = sum(is.na(stheight)),
          mean = mean(stheight, na.rm = TRUE),
          median = median(stheight, na.rm = TRUE),
          sd = sd(stheight, na.rm = TRUE)) 
## you can do:
group_by(survey, year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight, na.rm = TRUE),
            median = median(stheight, na.rm = TRUE),
            sd = sd(stheight, na.rm = TRUE)) 

## The result from the first function, `group_by` is
## sent directly to the second, `summarise`,
## by using the pipe, so there is no need to save intermediate
## results.


## * It is also possible to do the following:
survey %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight, na.rm = TRUE),
            median = median(stheight, na.rm = TRUE),
            sd = sd(stheight, na.rm = TRUE)) 
## that we will use as default.

## * We can have pipelines as long as needed, and it is easy to
##   include new intermediate steps:
survey %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight, na.rm = TRUE),
            median = median(stheight, na.rm = TRUE),
            sd = sd(stheight, na.rm = TRUE)) %>%
  filter(!is.nan(mean)) ## Keep only years with results

## * The way of thinking of this, according to G&H, is that you have
## *verbs* (functions) connected by *then* (pipe `%>%`), such as,
## group by, *then* summarise, *then* filter, ...

## * NOTE: `Ctrl + Shift + M` (`Cmd + Shift + M` on Mac) is a shortcut
##   to insert the pipe operator `%>%`.

## * If you wish, you can save the final result:
summaries <-
  survey %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight, na.rm = TRUE),
            median = median(stheight, na.rm = TRUE),
            sd = sd(stheight, na.rm = TRUE)) %>%
  filter(!is.nan(mean)) ## Keep only years with results

## You could also put the assignment at the end:
survey %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight, na.rm = TRUE),
            median = median(stheight, na.rm = TRUE),
            sd = sd(stheight, na.rm = TRUE)) %>%
  filter(!is.nan(mean)) ->
summaries

#### `ggplot2` and the `%>%`

library(ggplot2)

## * `ggplot2` was designed previously to the pipe. You can still
## use it in a pipe environment, but you will have to mix
## `%>%` and `+`, as in the following example:
survey %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight, na.rm = TRUE),
            median = median(stheight, na.rm = TRUE),
            SE = 1.96*sd(stheight, na.rm = TRUE) /
              sqrt(sum(!is.na(stheight)))) %>% ## Interpret why this is needed
  filter(!is.nan(mean)) %>%
  ggplot() +
  geom_line(mapping = aes(x = year, y = mean), col = "green") +
  geom_line(mapping = aes(x = year, y = median), col = "blue") +
  geom_line(mapping = aes(x = year, y = mean + SE), col = "red") +

  geom_line(mapping = aes(x = year, y = mean - SE), col = "red")

### Missing values and more aggregate functions.

## We had to deal with missing values to obtain results. We did it
## by removing them inside each aggregate function.
## We could remove them earlier with a `filter()`.
## We will also add other aggregate functions.
survey %>%
  filter(!is.na(stheight)) %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight),
            SE = 1.96*sd(stheight)/sqrt(n()),
            trmean = mean(stheight, trim=0.1), # trimmed mean
            median = median(stheight),
            FirstQ = quantile(stheight, 1/4),
            ThirdQ = quantile(stheight, 3/4),
            IQR = IQR(stheight),               # interquartile range
            mad = mad(stheight),               # median absolute deviation
            min = min(stheight),
            max = max(stheight)) ->
height_summaries

height_summaries %>%
  knitr::kable()

height_summaries %>%
  ggplot() +
  geom_line(mapping = aes(x = year, y = mean), col = "green") +
  geom_line(mapping = aes(x = year, y = mean + SE), col = "red") +
  geom_line(mapping = aes(x = year, y = mean - SE), col = "red") +
  geom_line(mapping = aes(x = year, y = median), col = "blue") +
  geom_line(mapping = aes(x = year, y = FirstQ), col = "orange") +
  geom_line(mapping = aes(x = year, y = ThirdQ), col = "orange")

## * Check if `countNA` is now 0 or not.

## NOTE: `Ctrl + Shift + P` (`Cmd + Shift + P` on Mac) to resend a whole
## block.

## dplyr also provides the functions `first`, `last`, and `nth`
## as wrappers to subsetting with `[[`. Also, `n_distinct` can be use
## to find number of unique values:

survey %>%
  filter(!is.na(stheight)) %>%
  group_by(year) %>%
  summarise(count = n(),
            unique = n_distinct(stheight),
            unique_alt = length(unique(stheight)),
            first = first(stheight),
            last = last(stheight),
            nth = nth(stheight, 4)) %>%
  knitr::kable()

a <- 11:20

a[[3]]
`[[`(a, 3)
nth(a, 3)

first(a)
last(a)

## There is also a `count` function (`dplyr`)
survey %>%
  count()

## which gives number of rows. There is also
## a `base` counterpart, `nrow`

survey %>%
  nrow()

## Remember you can also use `dim()` (`base`)
survey %>%
  dim()

## For the number of variables (columns)
survey %>%
  ncol()

survey %>%
  count()

## * You can also use `count` on a given variable
survey %>%
  count(sex)

## or group of variables

survey %>%
  count(sex, race4)

## It can also be used with a numerical variable

survey %>%
  filter(!is.na(stheight)) %>%
  count(stheight) %>%
  ggplot() +
  geom_point(mapping = aes(x = stheight, y = n))

## Count also accepts a weight argument (`wt`)
## that allows to weight (`sum`) on another variable

survey %>%
  filter(!is.na(stheight)) %>%
  count(year, wt = stheight)

## The above can also obtained in the following way,
## that makes more evident what you are doing.

survey %>%
  filter(!is.na(stheight)) %>%
  group_by(year) %>%
  summarise(totheight = sum(stheight))

### Arithmetics with logicals

## In numeric functions, logicals are converted to `1` (`TRUE`)
## and `0` (`FALSE`). We have already seen this to find totals
## of `NA`s by using `sum`. We can also find proportions
## by using `mean`.

survey %>%
  group_by(year) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            propNA = mean(is.na(stheight))) %>%
  knitr::kable()


### Grouping on multiple variables

## * You are not limited to group by one variable only.
## If we are interested to group by year and sex:

survey %>%
  filter(!is.na(stheight)) %>%
  group_by(year, sex) %>%
  summarise(count = n(),
            countNA = sum(is.na(stheight)),
            mean = mean(stheight),
            SE = 1.96*sd(stheight)/sqrt(n()),
            trmean = mean(stheight, trim=0.1), # trimmed mean
            median = median(stheight),
            FirstQ = quantile(stheight, 1/4),
            ThirdQ = quantile(stheight, 3/4),
            IQR = IQR(stheight),               # interquartile range
            mad = mad(stheight),               # median absolute deviation
            min = min(stheight),
            max = max(stheight))  %>%
  knitr::kable()

### Ungrouping

## * You can release the grouping by calling `ungroup`.

### Using `group_by` with `filter`

## * Suppose we want a subset containing only the students
## that were the shortest on a given year and, differentiating
## among females and males.

survey %>%
  filter(!is.na(stheight)) %>%
  group_by(year, sex) %>%
  filter(stheight == min(stheight)) %>% 
  select(year, sex, stheight)  %>%
  knitr::kable()

### Using `group_by` with `mutate`

## Suppose you want to standardize the height.


## \text{z} = \frac{X - \bar{X}}{\text{SD}_X}

## If we do the following:

survey %>%
  filter(!is.na(stheight)) %>%
  mutate(zscore = (stheight - mean(stheight))/sd(stheight)) %>% 
  select(year, sex, stheight, zscore)

## we obtain the zscores by standardizing with the overall mean and
## standard deviation.

## However, if we want to standardize relative to the responses of
## a given year and sex, we can do the following:

survey %>%
  filter(!is.na(stheight)) %>%
  group_by(year, sex) %>%
  mutate(zscore = (stheight - mean(stheight))/sd(stheight)) %>% 
  select(year, sex, stheight, zscore)

## The use of `mutate()` and `filter()` with a group_by enables the
## use of window functions.

### Window Functions

## (from postgresql documentation, https://www.postgresql.org/docs/9.1/static/tutorial-window.html)
## "A window function performs a calculation across a set of table
## rows that are somehow related to the current row.
## This is comparable to the type of calculation that can be done
## with an aggregate function. But unlike regular aggregate functions,
## use of a window function does not cause rows to become grouped into
## a single output row — the rows retain their separate identities.
## Behind the scenes, the window function is able to access more than just the current row of the query result."

## So the `mean` and `sd` in the last case above is performing calculations on windows
## (defined by year and sex), not on all of the data. Other example, extracted
## from `vignette("window-functions")` and modified to use pipes, follows.

library(Lahman)

Batting %>%
  tbl_df() %>%
  select(playerID, yearID, teamID, G, AB:H) %>%
  arrange(playerID, yearID, teamID) %>%
  group_by(playerID) ->
players

# Within each player, rank each year by the number of games played
players %>%
  mutate(G_rank = min_rank(G))

# For each player, find all where they played more games than average
players %>%
  filter(G > mean(G))

# For each, player compute a z score based on number of games played
players %>%
  mutate(G_z = (G - mean(G)) / sd(G))
# Ungroup to destroy the window
players %>%
  ungroup() %>%
  mutate(G_z = (G - mean(G)) / sd(G))


### Your turn

## * Given the dataset `iris`:
data(iris)
head(iris)

## * Get a subset containing only `Species` `"versicolor"`,
##   such that `Sepal.Width` is less than $2.5$.

## Begin solution:
## End solution


## * Get a subset containing only `Species` `"versicolor"` and `"virginica"`,
##   such that `Sepal.Width` is between $2.5$ and $3.2$. Keep only columns `Species`
##   and `Sepal.Width` (in that order).

## Begin solution
## End solution


## * Calculate the means for each of the 4 numerical variables.

## Begin solution
## End solution


## * Include the medians to the previous problem.

## Begin solution
## End solution

## * Calculate the means for each of the 4 numerical variables,
##  by `Species`.

## Begin solution
## End solution


## * Given the dataset `movies` in package `ggplot2movies`:

## install.packages("ggplot2movies")
library(ggplot2movies)
data(movies)
movies

## * Get the subset of movies that have a `budget`:
##     1. keeping only columns `title`, `year`, and `budget`
##     2. keeping all columns but `title`, `year`, and `budget`


## Begin solution:
## End solution


##  Find median rating per year and plot using ggplot.


## Begin solution
## End solution

## * For rated movies (`mpaa`):
##     1. Find proportion of rated movies. What do you think of the result?
##     2. Of the rated movies, find distribution (proportion)
##        of ratings. Plot with ggplot.
##     3. Interpret if the distribution has probabilitic meaning or not.


## Begin solution
## End solution
 

##     1. Find the distribution (proportion) of movie types
##     (`"Action"` to `"Short"`). Plot with ggplot.
##     2. Interpret if the distribution has probabilitic meaning or not.


## Begin solution
## End solution


##  Plot yearly $\log_{10}$ median budget with ggplot.

## Begin solution
## End solution

