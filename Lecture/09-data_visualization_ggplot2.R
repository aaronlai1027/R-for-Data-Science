#### Class 9: Tuesday February 13

## More geoms.
## Faceting.
## Smoothers.

library(ggplot2)


### Diamonds datasets
data(diamonds)

set.seed(1410)
## Get a sample of 100 diamonds
dsmall <- diamonds[sample(nrow(diamonds), 100), ]


### Histogram and density plots

## Histogram
qplot(x = carat, data = diamonds, geom = "histogram")
## or
ggplot(data = diamonds) + 
  aes(x = carat) +
  geom_histogram()
## Density
qplot(x = carat, data = diamonds, geom = "density")
## Frequency polygon
qplot(x = carat, data = diamonds, geom = "freqpoly")

## Your turn:
## Do the ggplot version of the above two.


## Begin solution
## End solution


## Specifying binwidth.
qplot(carat, data = diamonds, geom = "histogram", binwidth = 1)
qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.1)
qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.01)
## This last reveals striations (at "nice" numbers of carats)

## Frequency polygon with binwidth
qplot(carat, data = diamonds, geom = "freqpoly", binwidth = 0.01)

## Your turn:
## Create histogram of highway miles per gallon.
## Experiment with binwidth.
## Create also a density plot.
## Do both qplot as well as ggplot versions.



## Begin solution
## End solution

## Your turn:
## Superimpose a histogram with its corresponding
## density plot



## Begin solution
## End solution


## To compare distribution of subgroups, use an aesthetic
## Overlayed in the case of density
qplot(carat, data = diamonds, geom = "density",
      color = color)
## Stacked in the case of histogram
qplot(carat, data = diamonds, geom = "histogram",
      fill = color)

## NOTE: Density seems easy to read and compare different
## curves. But it assumes that the data is unbounded,
## continuous and smooth, which is not true for the data.

### Bar charts

## Bar chart (discrete analogous of histogram)
qplot(color, data = diamonds, geom = "bar")
## If the data has already been tabulated or if you’d like
## to tabulate class members in some other way, such as by
## summing up a continuous variable, you can use the weight
## geom.

## What to do if we have a summary dataframe...
## Let's first contruct one
tmp <- table(diamonds$color)
summ <- data.frame(color = names(tmp), amount = as.numeric(tmp))
## Now show the same as above (using weight)
qplot(color, data = summ, geom = "bar", weight = amount)

## You can use any continuous variable to sum its content.
qplot(color, data = diamonds, geom = "bar", weight = carat) +
  ylab("carat")
## Same with ggplot
ggplot(diamonds) + aes(color, weight = carat) +
  geom_bar() +
  ylab("carat")
## Also
ggplot(diamonds) + aes(color) +
  geom_bar(aes(weight = carat)) +
  ylab("carat")

## If you want to show percents, instead of quantities, you
## need to do as follows (we will see more about ..xx.. 
## variables later, but here it is if you need it)
require(scales)
ggplot(diamonds) + aes(color) +
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent) +
  ylab("Percent")


## Your turn:
## Using ggplot (not qplot)
## 1) Produce a barplot with the frequency of class
## 2) Another with the relative frequency



## Begin solution
## End solution


### Time series with line and path plots
head(economics)

## Showing time series data
qplot(date, uempmed, data = economics, geom = "line")
## or
ggplot(data = economics) + aes(date, uempmed) +
  geom_line()


## xlim, ylim, log, main, xlab, ylab

## Setting main and axes title.
qplot(carat, price, data = dsmall,
      xlab = "Price ($)", ylab = "Weight (carats)",
      main = "Price-weight relationship")
## Same with ggplot
ggplot(dsmall) +
  aes(carat, price) + 
  labs(title = "Price-weight relationship",
       x = "Price ($)",
       y = "Weight (carats)") +
  geom_point()
## or
ggplot(dsmall) +
  aes(carat, price) + 
  ggtitle("Price-weight relationship") +
  xlab("Price ($)") +
  ylab("Weight (carats)") +
  geom_point()

## Using an expression
qplot(carat, price/carat, data = dsmall,
      ylab = expression(frac(price, carat)),
      xlab = "Weight (carats)",
      main="Small diamonds",
      xlim = c(.2,1))
qplot(carat, price/carat, data = dsmall,
      main = expression(frac(beta[1], gamma)),
      xlim = c(.2,1))

## Your turn:
## Add title, label axes, and limit x display for
ggplot(data = mpg) + aes(x = hwy) +
  geom_histogram(binwidth = 5)



## Begin solution
## End solution


## Log 10 scale
qplot(carat, price, data = dsmall, log = "xy")
## Same with ggplot
ggplot(dsmall) +
  aes(carat, price) +
  scale_x_log10() +
  scale_y_log10() +
  geom_point()
## Also
ggplot(dsmall) +
  aes(carat, price) +
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10") +
  geom_point()

## Natural logs
ggplot(dsmall) +
  aes(carat, price) +
  scale_x_continuous(trans = "log") +
  scale_y_continuous(trans = "log") +
  geom_point()

## Base 2 logs
ggplot(dsmall) +
  aes(carat, price) +
  scale_x_continuous(trans = "log2") +
  scale_y_continuous(trans = "log2") +
  geom_point()


### Faceting

## * Faceting generates small multiples each showing a
##   different subset of the data.
## * Small multiples are a powerful tool for exploratory data
##   analysis: you can rapidly compare patterns
##   in different parts of the data and see whether
##   they are the same or different.

## * There are two types of faceting provided by ggplot2:
##   * facet_grid and
##   * facet_wrap.

## * Facet grid produces a 2d grid of panels defined by
##   variables which form the rows and columns, while facet
##   wrap produces a 1d ribbon of panels that is wrapped into
##   2d. You can access either faceting system from qplot().
## * A 2d faceting specification (e.g., x ~ y) will use
##   facet_grid, while a 1d specification (e.g., ~ x) will
##   use facet_wrap.


## Faceting
## Vertically
qplot(carat, data = diamonds, facets = color ~ .,
      geom = "histogram", binwidth = 0.1, xlim = c(0, 3))
## Same with ggplot()
ggplot(data = diamonds) +
  aes(carat) +
  facet_grid(color ~ .) +
  geom_histogram(binwidth = 0.1) +
  xlim(c(0, 3))

## Horizontally
qplot(carat, data = diamonds, facets = . ~ color,
      geom = "histogram", binwidth = 0.1, xlim = c(0, 3))
## Same with ggplot()
ggplot(data = diamonds) +
  aes(carat) +
  facet_grid(. ~ color) +
  geom_histogram(binwidth = 0.1) +
  xlim(c(0, 3))

## Both
qplot(carat, data = diamonds, facets = cut ~ color,
      geom = "histogram", binwidth = 0.1, xlim = c(0, 3))
## Same with ggplot()
ggplot(data = diamonds) +
  aes(carat) +
  facet_grid(cut ~ color) +
  geom_histogram(binwidth = 0.1) +
  xlim(c(0, 3))

### Margins
## Faceting a plot is like creating a contingency table.
## In contingency tables it is often useful to display
## marginal totals (totals over a row or column) as well as
## the individual cells.
qplot(carat, data = diamonds, facets = cut ~ color,
      margins = TRUE, geom = "histogram", binwidth = 0.1)
## Same with ggplot()
ggplot(data = diamonds) +
  aes(carat) +
  facet_grid(cut ~ color, margins = TRUE) +
  geom_histogram(binwidth = 0.1)



### Facet wrap
qplot(carat, data = diamonds, facets = ~ color,
      geom = "histogram", binwidth = 0.1)
## Same with ggplot()
ggplot(data = diamonds) +
  aes(carat) +
  facet_wrap(~ color) +
  geom_histogram(binwidth = 0.1)


## Your turn:
## Using ggplot in all cases:
## a) Find a subset of mpg that excludes cars with 5 cylinders
##    and rear wheel drive. Call the subset mpg2.
## b) With mpg2, do a horizontal facet grid by cylinder
##    of scatterplots of city mpg vs highway mpg.
## c) Do a vertical facet grid by class of histograms of
##    city mpg.
## d) Do a 2-dimensional facet grid by drive and cylinders of
##    of scatterplots of city mpg vs highway mpg.
## e) Include margins to the plot on d).
## f) Do a facet wrap by manufacturer of 
##    of scatterplots of city mpg vs highway mpg.



## Begin solution


### Controlling scales
## • scales = "fixed": x and y scales are fixed across all
##                     panels (default).
## • scales = "free": x and y scales vary across panels.
## • scales = "free_x": the x scale is free, and the y scale
##                      is fixed.
## • scales = "free_y": the y scale is free, and the x scale
##                      is fixed.
ggplot(data = diamonds) +
  aes(carat) +
  facet_grid(cut ~ color) +
  geom_histogram(binwidth = 0.1))
ggplot(data = diamonds) +
  aes(carat) +
  facet_grid(cut ~ color, scales = "free") +
  geom_histogram(binwidth = 0.1)

qplot(carat, data = diamonds, geom = "histogram",
      binwidth = 0.1) + facet_wrap(~ color)
qplot(carat, data = diamonds, geom = "histogram",
      binwidth = 0.1) + facet_wrap(~ color, scales = "free")





### Adding a smoother to a plot

## Simple linear regression
## method = "lm" fits a linear model. The default will fit
## a straight line to your data.
ggplot(dsmall) +
  aes(x = log(carat), y = log(price)) +
  geom_point() +
  geom_smooth(method = "lm")

## If you want to turn the confidence interval off,
## use se = FALSE.
ggplot(dsmall) +
  aes(x = log(carat), y = log(price)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

## Let's mix the smoother with facet_grid
ggplot(diamonds) +
  aes(x = log(carat), y = log(price)) +
  facet_grid(cut ~ color) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)


## Your turn
## Using the complete mpg data.frame
## a) Add a linear regression to the plot you found
##    in previous "your turn" d)
## b) Add a color to the smoother by mapping drive
##    train to it



## Begin solution
## End solution


## You can use formula = y ~ poly(x, 2) to specify a
## degree 2 polynomial.
ggplot(dsmall) +
  aes(x = carat, y = price) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2))


## Other smoothers.
## Note: Each of the following smoothers have specific theory
## behind them that will not be covered. You will find here
## only how to use them. If you decide to use any of them in
## your project, it is advisable you investigate its
## particulars as you may be requested to explain its use
## and relevance.

## Robust regression
## Introduction to Robust Linear Models (Wikipedia):
## https://en.wikipedia.org/wiki/Robust_regression

## method = "rlm" works like lm, but uses a robust fitting
## algorithm so that outliers don’t affect the fit as much.
## It’s part of the MASS package, so remember to load that
## package first.
library(MASS)
ggplot(dsmall) +
  aes(x = log(carat), y = log(price)) +
  geom_point() +
  geom_smooth(method = "rlm")


## "LOcal regrESSion"
## Introduction to LOESS (Wikipedia):
## https://en.wikipedia.org/wiki/Local_regression

## LOESS combines much of the simplicity of linear least
## squares regression with the flexibility of nonlinear
## regression. It does this by fitting simple models to
## localized subsets of the data to build up a function
## that describes the deterministic part of the variation
## in the data, point by point. In fact, one of the chief
## attractions of this method is that the data analyst is
## not required to specify a global function of any form
## to fit a model to the data, only to fit segments of
## the data.
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "loess")

## For less that 1000 obs, ggplot uses method="loess"
## by default
qplot(carat, price, data = dsmall, geom = c("point", "smooth"))
## Same with ggplot
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth()

## Use R help of "loess" to further investigate the
## reasoning behind "span" and other parameters.
## Wiggly
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "loess", span = 0.2) 
## Not so wiggly
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "loess", span = 1) 


## Smoothing splines
## Introduction to Smoothing splines (Wikipedia):
## https://en.wikipedia.org/wiki/Smoothing_spline

## You can load the splines package and use a
## natural spline: formula = y ~ ns(x, 2).
library(splines)
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ ns(x, 2))
## Note: the two corresponds to the degrees of freedom
## See R help for "ns" for details of parameters

## Generalized additive models (GAMs)
## Introduction to Generalized Additive Models (Wikipedia):
## https://en.wikipedia.org/wiki/Generalized_additive_model

## You could load the mgcv library and use method="gam",
## formula = y ∼ s(x) to fit a generalised additive model. 
## This is similar to using a spline with lm, but the
## degree of smoothness is estimated from the data.
library(mgcv)
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x))

## For large data, use the formula y ~ s(x, bs = "cs").
## See R help of "s" for description of parameters.
## and R help of "smooth.terms" for descriptions of choices
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))

## Note: This is used by default when there are more than
##       1,000 points.
ggplot(diamonds) +
  aes(carat, price) +
  geom_point() +
  geom_smooth()
ggplot(diamonds) +
  aes(carat, price) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))
