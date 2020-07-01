library(yrbss)
library(dplyr)
library(magrittr)
library(ggplot2)
library(reshape2)
library(ggplot2movies)
### Your turn

## * Given the dataset `iris`:
data(iris)
head(iris)

## * Get a subset containing only `Species` `"versicolor"`,
##   such that `Sepal.Width` is less than $2.5$.

## Begin solution:
iris %>%
  subset(Species == "versicolor" & Sepal.Width < 2.5) 
## End solution


## * Get a subset containing only `Species` `"versicolor"` and `"virginica"`,
##   such that `Sepal.Width` is between $2.5$ and $3.2$. Keep only columns `Species`
##   and `Sepal.Width` (in that order).

## Begin solution
iris %>%
  subset(Species == "versicolor" | Species == "virginica") %>%
  subset(Sepal.Width >= 2.5 & Sepal.Width <= 3.2) %>%
  select(Species, Sepal.Width)
## End solution


## * Calculate the means for each of the 4 numerical variables.

## Begin solution
iris %>%
  summarise(n = n(),
            Sepal.Length_mean = mean(Sepal.Length, na.rm = TRUE),
            Sepal.Width_mean = mean(Sepal.Width, na.rm = TRUE),
            Petal.Length_mean = mean(Petal.Length, na.rm = TRUE),
            Petal.Width_mean = mean(Petal.Width, na.rm = TRUE))
## End solution


## * Include the medians to the previous problem.

## Begin solution
iris %>%
  summarise(n = n(),
            Sepal.Length_mean = mean(Sepal.Length, na.rm = TRUE),
            Sepal.Width_mean = mean(Sepal.Width, na.rm = TRUE),
            Petal.Length_mean = mean(Petal.Length, na.rm = TRUE),
            Petal.Width_mean = mean(Petal.Width, na.rm = TRUE),
            Sepal.Length_median = median(Sepal.Length, na.rm = TRUE),
            Sepal.Width_median = median(Sepal.Width, na.rm = TRUE),
            Petal.Length_median = median(Petal.Length, na.rm = TRUE),
            Petal.Width_median = median(Petal.Width, na.rm = TRUE))
## End solution

## * Calculate the means for each of the 4 numerical variables,
##  by `Species`.

## Begin solution
iris %>%
  group_by(Species) %>%
  summarise(n = n(),
            Sepal.Length_mean = mean(Sepal.Length, na.rm = TRUE),
            Sepal.Width_mean = mean(Sepal.Width, na.rm = TRUE),
            Petal.Length_mean = mean(Petal.Length, na.rm = TRUE),
            Petal.Width_mean = mean(Petal.Width, na.rm = TRUE))
## End solution


## * Given the dataset `movies` in package `ggplot2movies`:


data(movies)
movies

## * Get the subset of movies that have a `budget`:
##     1. keeping only columns `title`, `year`, and `budget`
##     2. keeping all columns but `title`, `year`, and `budget`


## Begin solution:
#1
movies %>%
  subset(!is.na(budget)) %>%
  select(title, year, budget)

#2
movies %>%
  subset(!is.na(budget)) %>%
  select(-c(title, year, budget))
## End solution


##  Find median rating per year and plot using ggplot.


## Begin solution
movies %>%
  group_by(year) %>%
  summarise(median = median(rating), na.rm = TRUE) %>%
  ggplot() +
  aes(x = year, y = median) +
  geom_line()
  
## End solution

## * For rated movies (`mpaa`):
##     1. Find proportion of rated movies. What do you think of the result?
##     2. Of the rated movies, find distribution (proportion)
##        of ratings. Plot with ggplot.
##     3. Interpret if the distribution has probabilitic meaning or not.


## Begin solution
#1
movies %>%
  subset(mpaa != "") %>%
  summarise(proportion = length(mpaa)/nrow(movies)*100)
#The mpaa only includes NC-17, PG, PG-13 and R.
#However, the proportion of rated movies is only 8.376% in all movies.
#I think it is probably because other unrated movies are rated as G(General Audiences). 

#2
movies %>%
  group_by(mpaa) %>%
  subset(mpaa != "") %>%
  ggplot() +
  aes(x = rating , colour = factor(mpaa))+
  geom_density()

#3 
#The average rating of all kinds of rated movies are almost the same.
#It's nearly between 5 and 7.

## End solution


##     1. Find the distribution (proportion) of movie types
##     (`"Action"` to `"Short"`). Plot with ggplot.
##     2. Interpret if the distribution has probabilitic meaning or not.


## Begin solution
#1
movies %>%
  summarise(pAction = sum(Action)/nrow(movies),
            pAnimation = sum(Animation)/nrow(movies),
            pComedy = sum(Comedy)/nrow(movies),
            pDrama = sum(Drama)/nrow(movies),
            pDocumentary = sum(Documentary)/nrow(movies),
            pRomance = sum(Romance)/nrow(movies),
            pShort = sum(Short)/nrow(movies)) %>%
  as.data.frame() %>%
  melt() %>%
  ggplot() +
  aes(x = variable, y = value) +
  geom_bar(stat="identity") +
  labs(
    x = "Types",
    y = "Proportion"
    )

#2
#Because one movie could be more than one type.
#As the result, the Drama and Comedy have more proportion than others.
#I think it's probably beacause people love those two types more.

## End solution


##  Plot yearly $\log_{10}$ median budget with ggplot.

## Begin solution
movies %>%
  subset(!is.na(budget))%>%
  group_by(year) %>%
  summarise(median = log10(median(budget)), na.rm = TRUE) %>%
  ggplot() +
  aes(x = year, y = median) +
  geom_line() +
  labs(
    x = "Year",
    y = "Budget"
  )
#
## End solution

