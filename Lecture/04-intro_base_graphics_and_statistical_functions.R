#### Class 4: Tuesday September 7

## Intro Base graphics.
## Intro statistical functions.


## Probability distributions
x <- seq(-4, 4, length.out = 200) 
## Density of the Standard Normal Distribution
plot(x, dnorm(x), type = "l")
## Cumulative probability distribution of the SND
plot(x, pnorm(x), type = "l")

p <- seq(0, 1, length.out = 200)
## Quantiles of the SND
plot(p, qnorm(p), type = "l")

## Random variates from a SND
r <- rnorm(100)
r[1:10]
## Empirical distribution
hist(r, freq = FALSE, breaks = "Scott")
## Superimpose the density
lines(x, dnorm(x), type="l")

## Boxplot
boxplot(x)

## Quantile-quantile plot
qqnorm(r); qqline(r)

stem(r)


## Tests for normality
## Shapiro test
shapiro.test(x)
## Shapiro test is too sensible to departure
## from normality as the number of data points increases.
## (Even when sampling from a Normal distribution...)
shapiro.test(x[1:10])
shapiro.test(x[1:20])
shapiro.test(x[1:30])
shapiro.test(x[1:40])
shapiro.test(x[1:50])
shapiro.test(x[1:60]) # Here you reject
## In conclusion, this test does not
## look too reliable in practice.

## Kolmogorv-Smirnoff test 
ks.test(x, "pnorm", mean = mean(x), sd = sd(x))

## Let's do a qqplot of a gamma random sample
qqnorm(r <- rgamma(1000, shape = 1)); qqline(x)



## Tests for normality (that should fail)
shapiro.test(r)
ks.test(r, "pnorm", mean = mean(r), sd = sd(r))

## Test for conformance to a gamma distribution
mg <- mean(r)
vg <- var(r)
ks.test(r, "pgamma", shape = mg^2/vg, scale = vg/mg)


## Comparison of two groups of data
A <- c(45.8, 82.9, 103.1, 17.4, 86.7, 88.7, 61.6,
       62.3, 61.9, 53.7, 64.1, 51.0, 56.6, 77.6,
       100.0, 73.2, 63.2, 53.2, 55.1, 136.4, 79.4,
       63.7, 65.0, 87.5, 58.7)
B <- c(35.8, 86.4, 46.4, 71.6, 48.6, 99.6, 60.10,
       54.3, 59.5, 31.3, 42.8, 17.5, 38.5, 64.6,
       60.4, 108.2, 45.3, 50.6, 65.0, 47.1, 47.8,
       44.3, 40.7, 58.9, 59.6, 26.8, 57.4, 44.3,
       46.6, 67.9)
summary(A)
hist(A, breaks = "Scott")
rug(A)
boxplot(A)
rug(A, side = 2)
shapiro.test(A)
ks.test(A, "pnorm", mean = mean(A), sd = sd(A))

summary(B)
hist(B)
rug(B)
boxplot(B)
rug(B, side = 2)
shapiro.test(B)
ks.test(B, "pnorm", mean = mean(B), sd = sd(B))

## Boxplot of both groups in one plot
boxplot(A, B)
rug(A, side = 2)
rug(B, side = 4)

## t-test (default Welch test for unequal variances)
t.test(A, B)
## test for equality of variances
var.test(A, B)
## t-test (for equal variances)
t.test(A, B, var.equal = TRUE)


## Note: data was generated this way:
## set.seed(1234)
## A <- round(rnorm(25, mean=76, sd=25), 1)
## B <- round(rnorm(30, mean=72, sd=25), 1)

## Your turn
## Perform the above analysis on the following data:
A <- c(79.98, 80.04, 80.02, 80.04, 80.03, 80.03, 80.04, 79.97,
       80.05, 80.03, 80.02, 80.00, 80.02)
B <- c(80.02, 79.94, 79.98, 79.97, 79.97, 80.03, 79.95, 79.97)
## Discuss the adequacy of the methodology in this case.

## Begin solution
## End solution


## If you have doubts about the adequacy of assuming
## normally distributed data, you can perform
## a non-parametric test.
wilcox.test(A, B)

## Of course a non-parametric test does not protect
## you if the data do not come from a random sample
## (the assumption of independence always needs to hold)

## Simple regression
## Data set used by Pearson to investigate regression.
## install.packages("UsingR")
library(UsingR)
data(father.son)
str(father.son)
head(father.son)

## Scatterplot of fathers (on x axis) and sons (on y axis)
plot(father.son$fheight, father.son$sheight)

## Perform a linear model analysis (regression)
(lmfs <- lm(sheight ~ fheight, data = father.son))
str(lmfs)


## Your turn
## 1) Extract the coefficients of the regression line
## from lmfs, and add the regression line (in red)
## to the scatterplot.
## Hint: use function "abline" (see help)
## 2) plot the father heights on x
##    and the residuals in y. Add a horizontal line
##    at 0.

## Begin solution
## End solution

## The regression line can be plotted directly using
plot(father.son$fheight, father.son$sheight)
abline(lmfs)

## Summary function
(slmfs <- summary(lmfs))
str(slmfs)

## Your turn
## extract the fstatistic from slmfs
## and perform the calculation to obtain
## the p-value of the anova of the regression
## i.e., the line that says
## F-statistic: 361.2 on 1 and 1076 DF,  p-value: < 2.2e-16
## Hint: use the function "pf" that gives you the
##       cumulative probability of an F distribution.

## Begin solution
## End solution

## Alternative, you can find the anova table
## of the regression
(anlmfs <- anova(lmfs))
str(anlmfs)

## Your turn
## Extract the p-value directly from anlmfs

## Begin solution
## End solution
