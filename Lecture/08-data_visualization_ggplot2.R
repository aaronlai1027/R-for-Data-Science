#### Lecture 8: Tuesday February 6

## Data visualization. ggplot2.
## The grammar of graphics.
## Aesthetics.
## Geoms.

## Resources for ggplot2

## Reads more like a manual:
## http://www.cookbook-r.com/

## Definitive manual:
## http://docs.ggplot2.org/current/

## Stack Exchange has > 170,000 hits for ggplot2:
## http://stackexchange.com/search?q=%5Bggplot2%5D

## Credits:
## Hadley Wickham
## ggplot2: Elegant Graphics for Data Analysis
## Springer, 2009
## Several paragraphs are copied verbatim from Hadley's book
## install.packages("ggplot2")
library(ggplot2)

## * In brief, the grammar tells us that a statistical graphic
##   is a mapping from data to aesthetic attributes
##   (color, shape, size) of geometric objects (points, lines,
##   bars).

## * The plot may also contain statistical transformations
##   of the data and is drawn on a specific coordinate system.

## * Faceting can be used to generate the same plot for different
##   subsets of the dataset. It is the combination of these
##   independent components that make up a graphic.

## * Terminology of the grammar of graphics:
##   * The *data* that you want to visualise and a set of
##     *aesthetic mappings* describing how variables in the data
##     are mapped to aesthetic attributes that you can perceive.
##   * Geometric objects, *geoms* for short, represent what you
##     actually see on the plot: points, lines, polygons, etc.
##   * Statistical transformations, *stats* for short, summarise
##     data in many useful ways. For example, binning and
##     counting observations to create a histogram, or
##     summarising a 2d relationship with a linear model.
##     Stats are optional, but very useful.
##   * The *scales* map values in the data space to values in an
##     aesthetic space, whether it be color, or size, or shape.
##     Scales draw a legend or axes, which provide an inverse
##     mapping to make it possible to read the original data
##     values from the graph.
##   * A coordinate system, *coord* for short, describes how data
##     coordinates are mapped to the plane of the graphic. It
##     also provides axes and gridlines to make it possible to
##     read the graph. We normally use a Cartesian coordinate
##     system, but a number of others are available, including
##     polar coordinates and map projections.
##   * A faceting specification describes how to break up the data
##     into subsets and how to display those subsets as small
##     multiples. This is also known as conditioning or
##     latticing/trellising.

### Diamonds datasets
data(diamonds)
dim(diamonds)
## About 54.000 diamonds
names(diamonds)
## 4 C's of diamond quality: carat, cut, color and clarity;
## and five physical measurements, depth, table, x, y and z.
## Carat is a unit of mass equal to 200mg, or 0.2 g
str(diamonds)

summary(diamonds)

View(diamonds)

## We will extract a sample of 100 diamonds, and will
## set seed to make it reproducible
set.seed(1410)
## Get a sample of 100 diamonds
dsmall <- diamonds[sample(nrow(diamonds), 100), ]

### Basic use of ggplot. Using qplot() that is close to plot()

qplot(x = carat, y = price, data = diamonds)
## Strong correlation. Outliers. Vertical striation.
## Relation looks exponential. Transform variables.

qplot(x = log(carat), y = log(price), data = diamonds)
## Relation looks linear. Too much overplotting to
## draw firm conclusions.

## Relation between volume of diamonds (approx x y z)
## and weight (carat)?
qplot(x = carat, y = x*y*z, data = diamonds)
## Seems to work, but large outliers too.

## Your turn:
## Use mpg data
data(mpg)
## Explore the structure of the data
str(mpg)
## Use the help to learn about the variables.
## Do a scatterplot of highway miles per gallon on
## city mile per gallon.



## Begin solution
## End solution


### color, size, shape and other aesthetic attributes

## * color, size and shape are all examples of aesthetic
##   attributes, visual properties that affect the way
##   observations are displayed.
## * For every aesthetic attribute, there is a function,
##   called a scale, which maps data values to valid values for
##   that aesthetic.
## * It is this scale that controls the
##   appearance of the points and associated legend. For
##   example, in the above plots, the color scale maps J
##   to purple and F to green.

## Mapping a variable to the color aesthetic
qplot(x = carat, y = price, data = dsmall, color = color)
qplot(x = carat, y = price, data = dsmall, color = depth)

## Mapping a variable to the shape aesthetic (cut quality)
qplot(x = carat, y = price, data = dsmall, shape = cut)

## We can do the same using ggplot(), but you need to be
## explicit as no defaults are considered.
ggplot(data = dsmall, aes(x = carat, y = price, shape = cut)) +
  geom_point()
## or
ggplot(data = dsmall) +
  aes(x = carat, y = price, shape = cut) +
  geom_point()

## Mapping a variable to the size aesthetic
qplot(x = carat, y = price, data = dsmall, size = carat)


## You can force a specific color, using I()
qplot(x = carat, y = price, data = dsmall,
      color = I("red"))

## Also a size.
qplot(x = carat, y = price, data = dsmall, size = I(6))
## Same with ggplot
ggplot(data = dsmall) +
  aes(x = carat, y = price) +
  geom_point(size = I(6))
## or
ggplot(data = dsmall) +
  aes(x = carat, y = price) +
  geom_point(size = 6)

## Your turn:
## Map color to manufacturer and shape to drive.
## Do both qplot as well as ggplot versions.



## Begin solution
## End solution

## To alleviate overplotting, semi-transparent points
## may be used.
## For that end, use the alpha aesthetic, that takes
## values from 0 (transparent) to 1 (opaque).

qplot(x = carat, y = price, data = diamonds, alpha = I(1/10))
qplot(x = carat, y = price, data = diamonds, alpha = I(1/100))
qplot(carat, price, data = diamonds, alpha = I(1/200))

## color and shape work better with categorical variables.
## Size with continuous variables.

### Plot geoms

## Geoms (geometric objects) describe the type of object
## used to display the data. Some geoms have an associated
## statistical transformation (histogram is a binning
## statistics plus a bar geom). Examples:

## Jittered points
qplot(color, price/carat, data = diamonds,
      geom = "jitter")

## Semi-transparent jittered points
qplot(color, price/carat, data = diamonds, geom = "jitter",
      alpha = I(1/5))
qplot(color, price/carat, data = diamonds, geom = "jitter",
      alpha=I(1/50))
qplot(color, price/carat, data = diamonds, geom = "jitter",
      alpha=I(1/200))

## Boxplots
qplot(color, price / carat, data = diamonds,
      geom = "boxplot")
ggplot(data = diamonds) +
  aes(x = color, y = price / carat) +
  geom_boxplot()

## Your turn:
## Create boxplots by manufacturer of highway miles
## per gallon.
## Do both qplot as well as ggplot versions.



## Begin solution
## Note x-axis labels all running over each other. We will
## address this lately.
## End solution

