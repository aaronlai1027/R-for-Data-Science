#### Class 10: Thursday February 15

## Grouping.
## Position adjustment.
## Layers.
## Multiple plots.
## Non-Cartesian coordinate systems.
## Modifying defaults.
## Themes.
## Maps.

library(ggplot2)


### Diamonds datasets
data(diamonds)

set.seed(1410)
## Get a sample of 100 diamonds
dsmall <- diamonds[sample(nrow(diamonds), 100), ]


### Grouping

## Oxboys is found in library nlme
library(nlme)
data(Oxboys)
## These data are described in Goldstein (1987) as data
## on the height of a selection of boys from Oxford,
## England versus a standardized age.
## This data frame contains the following columns:
## Subject: an ordered factor giving a unique identifier
##          for each boy in the experiment
## age: a numeric vector giving the standardized age
##     (dimensionless)
## height: a numeric vector giving the height of the boy
##        (cm)
## Occasion: an ordered factor - the result of converting
##           age from a continuous variable to a count so
##           these slightly unbalanced data can be
##           analyzed as balanced.
head(Oxboys)
## It records the heights
## (height) and centered ages (age) of 26 boys (Subject),
## measured on nine occasions (Occasion).
str(Oxboys)


ggplot(Oxboys) +
  aes(age, height) +
  geom_point()

## The following does not make sense as a plot.
ggplot(Oxboys) +
  aes(age, height) +
  geom_point() +
  geom_line()
## By grouping we achieve a better representation.
ggplot(Oxboys) +
  aes(age, height, group = Subject) +
  geom_point() +
  geom_line()


#### Different groups on different layers.

## The following creates a smooth line for each boy.
ggplot(Oxboys) +
  aes(age, height, group = Subject) +
  geom_line() +
  geom_smooth(method = "lm", se = FALSE)
## The following creates a smooth line for *all* the boys
## (group = 1)
ggplot(Oxboys) +
  aes(age, height, group = Subject) +
  geom_line() +
  geom_smooth(aes(group = 1), method = "lm",
              size = 2, se = FALSE)

#### Overriding the default grouping.
ggplot(Oxboys) +
  aes(Occasion, height) +
  geom_boxplot()
## grouping was not necessary, as Occasion was a discrete 
## variable, and ggplot grouped by default.

## To overlay individual trajectories, we need to override
## the default grouping.
ggplot(Oxboys) +
  aes(Occasion, height) +
  geom_boxplot() +
  geom_line(aes(group = Subject), color = "#3366FF")


### Fuel economy data.
data(mpg)
head(mpg)
##  cty and hwy record miles per gallon (mpg) for city
## and highway driving, respectively, and displ is the
## engine displacement in litres.
## It records make, model, class, engine size, transmission
## and fuel economy for a selection of US cars in 1999 and
## 2008. It contains the 38 models that were updated every
## year, an indicator that the car was a popular model.

## Adding a regression line by group:
ggplot(mpg) +
  aes(displ, hwy, color = factor(cyl)) +
  geom_point() +
  geom_smooth(method = "lm")

## Your turn:
## Devise a method to get only one regression line for
## all the data and still have colors mapped.



## Begin solution
## End solution


### Position adjustments
## To apply minor tweaks to the position of elements
## within a layer.

## stack: Stack overlapping objects on top of one another
ggplot(data = diamonds) + 
  aes(x = clarity, fill = cut) +
  geom_bar(position = "stack")
## Note: stack is the default for geom_bar

## fill: Stack overlapping objects and standardise to
##       have equal height
ggplot(data = diamonds) + 
  aes(x = clarity, fill = cut) +
  geom_bar(position = "fill")

## dodge: Adjust position by dodging overlaps to the side
ggplot(data = diamonds) + 
  aes(x = clarity, fill = cut) +
  geom_bar(position = "dodge")

## The following is not useful for bars, but may be for
## other geoms.

## identity: Don’t adjust position
ggplot(data = diamonds) + 
  aes(x = clarity, fill = cut) +
  geom_bar(position = "identity")

## jitter: Jitter points to avoid overplotting
ggplot(data = diamonds) + 
  aes(x = clarity, fill = cut) +
  geom_bar(position = "jitter")

## Your turn
## Using mpg2, replicate the plot shown in the screen
## Note: the title of the legend has been modified
##       by using
##       guides(fill=guide_legend(title="year"))
##       It could be removed by using
##       guides(fill=guide_legend(title=NULL))



## Begin solution
## End solution


## You can assign a qplot or ggplot to a object name
## to be rendered later.
## No layer specified.
p <- ggplot(diamonds) +
  aes(carat, price, color = cut)
p

### Layers
## Adding a layer (scatterplot)
p + layer(geom = "point",
          stat = "identity",
          position = "identity")
## Note: the above is the same as
p + geom_point()

## layer(geom = NULL, stat = NULL, data = NULL,
##       mapping = NULL, position = NULL,
##       params = list(), inherit.aes = TRUE,
##       subset = NULL, show.legend = NA)

## Histogram (combination of bars and binning)
p <- ggplot(diamonds) + aes(x = carat)
p + layer(geom = "bar", stat = "bin",
          position = "dodge",
          params = list(fill = "steelblue",
                        binwidth = .5))

## Note: the above is the same as
p <- ggplot(diamonds, aes(x = carat))
p + geom_histogram(binwidth = .5, fill = "steelblue")

### List of Geoms

## abline      Line, specified by slope and intercept
## area        Area plots
## bar         Bars, rectangles with bases on y-axis
## blank       Blank, draws nothing
## boxplot     Box-and-whisker plot
## contour     Display contours of a 3d surface in 2d
## crossbar    Hollow bar with middle indicated
##             by horizontal line
## density     Display a smooth density estimate
## density_2d  Contours from a 2d density estimate
## errorbar    Error bars
## histogram   Histogram
## hline       Line, horizontal
## interval    Base for all interval (range) geoms
## jitter      Points, jittered to reduce overplotting
## line        Connect observations, in order of x value
## linerange   An interval represented by a vertical line
## path        Connect observations, in original order
## point       Points, as for a scatterplot
## pointrange  An interval represented by a vertical line,
##             with a point in the middle
## polygon     Polygon, a filled path
## quantile    Add quantile lines from a quantile
##             regression
## ribbon      Ribbons, y range with continuous x values
## rug         Marginal rug plots
## segment     Single line segments
## smooth      Add a smoothed condition mean
## step        Connect observations by stairs
## text        Textual annotations
## tile        Tile plot as densely as possible,
##             assuming that every tile is the same size
## vline       Line, vertical

### List of Stats

## bin         Bin data
## boxplot     Calculate components of box-and-whisker plot
## contour     Contours of 3d data
## density     Density estimation, 1d
## density_2d  Density estimation, 2d
## function    Superimpose a function
## identity    Don’t transform data
## qq          Calculation for quantile-quantile plot
## quantile    Continuous quantiles
## smooth      Add a smoother
## spoke       Convert angle and radius to xend and yend
## step        Create stair steps
## sum         Sum unique values. Useful for overplotting
##             on scatterplots
## summary     Summarise y values at every unique x
## unique      Remove duplicates

## Some stats produce variables that can be used.
## For example stat_bin produces:
## count, density, and x (center of the bin)
ggplot(diamonds, aes(carat)) +
  geom_histogram(aes(y = ..density..), binwidth = 0.1)
## These variables need to be sorrounded with .. to avoid
## possible collision with variables in the data.frame
## with the same names, and makes clear that the variable
## was generated with the stat.


## A layer can be saved as an object, and then used
## in different plots, adapting to each of them.
regr <- geom_smooth(method = "lm", se = FALSE,
                    color = "steelblue", size = 2)
## See the object layer
regr

## Apply it to a plot
qplot(carat, price, data = dsmall) +
  regr
## Same with ggplot
ggplot(dsmall) +
  aes(carat, price) +
  geom_point() +
  regr

## Your turn
## Apply reg to different plots performed
## in mpg dataset



## Begin solution
## End solution


### Annotating a plot

str(economics)
head(economics)
rm(presidential)
str(presidential)
head(presidential)

## Base plot
(unemp <- qplot(x = date, y = unemploy, data = economics,
                geom="line",
                xlab = "", ylab = "No. unemployed (1000s)"))

(presidential <- presidential[-(1:3), ])
yrng <- range(economics$unemploy)
xrng <- range(economics$date)

## Fill with color
unemp + geom_rect(aes(x = NULL, y = NULL,
                      xmin = start, xmax = end,
                      fill = party),
                  ymin = yrng[1], ymax = yrng[2],
                  data = presidential) +
  scale_fill_manual(values = alpha(c("blue", "red"), 0.2))

## Add names
last_plot() + 
  geom_text(aes(x = start, y = yrng[1], label = name),
            data = presidential, size = 3, hjust = 0, vjust = 0)

## Write a caption
caption <- paste(strwrap("Variation of unemployment
                         rates in the US for different presidents", 40),
                 collapse = "\n")
last_plot() + geom_text(aes(x, y, label = caption),
                        data=data.frame(x = xrng[2],
                                        y = yrng[2]),
                        hjust = 1, vjust = 1, size = 4)

## Show highest
highest <- subset(economics, unemploy == max(unemploy))
last_plot() + geom_point(data = highest,
                         size = 3, color = alpha("red", 0.5))


## Your turn
## This will be a guided data science analysis of some aspects
## of the movies dataset, requiring subsetting, cleaning,
## transformation, and summarizing of raw data,
## as well as visualization using
## both base graphics and ggplot2.
## Load data movies
library(ggplot2movies)
data(movies)
## 1) Find median rating per year and plot
##    first with base graphics and then with ggplot.
## 2) Find distribution (count/proportion)
##    of movie types. Plot first with base graphics
##    (hint: use barplot) and then with ggplot.
## 3) For rated movies, find distribution (count/proportion)
##    of movie MPAA rating of movie types. Plot first
##    with base graphics and then with ggplot.
##    Calculate which percentage of movies are rated.
## 4) Plot log median budget per year. Plot first
##    with base graphics and then with ggplot.
## 5) How well is length correlated with log budget?
##    Plot first with base graphics and then with ggplot.



## Begin solution
## End solution


### Summary functions

## Summary function for geoms expecting
## one-dimensional data
## You can create your own summary function
## and have ggplot call it.
## Suppose we want to show the trimmed mean
midm <- function(x) mean(x, trim=0.25)

ggplot(movies) +
  aes(round(rating), log10(votes)) +
  stat_summary(aes(color = "trimmed"),
               fun.y = midm, geom = "point") +
  stat_summary(aes(color = "raw"),
               fun.y = mean, geom = "point") +
  scale_color_hue("Mean")


## Summary function for geoms expecting
## two-dimensional data
iqr <- function(x, ...) {
  qs <- quantile(as.numeric(x),
                 c(0.25, 0.75),
                 na.rm = TRUE)
  names(qs) <- c("ymin", "ymax")
  qs
}

ggplot(movies) +
  aes(year, rating) +
  stat_summary(fun.data = iqr, geom = "ribbon")


### Multiple plots on the same figure
## Suppose we want to plot the following
## three plots in the same figure
(a <- qplot(date, unemploy, data = economics,
            geom = "line"))
(b <- qplot(uempmed, unemploy, data = economics) +
    geom_smooth(se = FALSE))
(c <- qplot(uempmed, unemploy, data = economics,
            geom = "path"))

### Subplots
## ggplot2 uses the grid graphics system.
## We have not seen it, but it offers a very potent
## alternative to base graphics.
## We cannot use layout as in the base system,
## but we can find a solution using viewports.

library(grid)

### Rectangular grids. Use grid.layout
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))
print(a, vp = viewport(layout.pos.row = 1,
                       layout.pos.col = 1:2))
print(b, vp = viewport(layout.pos.row = 2,
                       layout.pos.col = 1))
print(c, vp = viewport(layout.pos.row = 2,
                       layout.pos.col = 2))

## By default grid.layout() makes each cell
## the same size, but you can
## use the widths and heights arguments to make
## them of different sizes.
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2,
                                           widths=c(3, 2),
                                           heights=c(3, 4))))
print(a, vp = viewport(layout.pos.row = 1,
                       layout.pos.col = 1:2))
print(b, vp = viewport(layout.pos.row = 2,
                       layout.pos.col = 1))
print(c, vp = viewport(layout.pos.row = 2,
                       layout.pos.col = 2))


## The following more advance technique is
## to embed one plot inside another.
subvp <- viewport(width = 0.4, height = 0.4, x = 0.75,
                  y = 0.35)
b
print(c, vp = subvp)
## We have found a solution, but we need
## We can make a few tweaks to the
## appearance: the text should be smaller,
## we want to remove the axis labels and
## shrink the plot margins.
csmall <- c +
  theme_gray(9) +
  labs(x = NULL, y = NULL) +
  theme(plot.margin = unit(rep(0, 4), "lines"))
b
print(csmall, vp = subvp)


### Non-Cartesian coordinate systems

## Polar coordinates.

## Stacked barchart
(pie <- ggplot(mtcars, aes(x = factor(1),
                           fill = factor(cyl))) +
    geom_bar(width = 1, position = "dodge"))
## Pie chart
pie + coord_polar(theta = "y")
## The bullseye chart
pie + coord_polar()



#### ********* Modifying defaults ******* ####

### Built-in themes
theme_set(theme_gray())

hgram <- qplot(rating, data = movies, binwidth = 1)
## Themes affect the plot when they are drawn,
## not when they are created
hgram
previous_theme <- theme_set(theme_bw())
hgram
## You can override the theme for a single plot by adding
## the theme to the plot. Here we apply the original theme
hgram + previous_theme
## Permanently restore the original theme
theme_set(previous_theme)


### Theme elements and element functions

## axis.line         segment  line along axis
## axis.text.x       text     x axis label
## axis.text.y       text     y axis label
## axis.ticks        segment  axis tick marks
## axis.title.x      text     horizontal tick labels
## axis.title.y      text     vertical tick labels 

## legend.background rect     background of legend
## legend.key        rect     background underneath legend
##                            keys
## legend.text       text     legend labels
## legend.title      text     legend name

## panel.background  rect     background of panel
## panel.border      rect     border around panel
## panel.grid.major  line     major grid lines
## panel.grid.minor  line     minor grid lines
## plot.background   rect     background of the entire
##                            plot
## plot.title        text     plot title

## strip.background  rect     background of facet labels
## strip.text.x      text     text for horizontal strips
## strip.text.y      text     text for vertical strips

## element_text()
(hgramt <- hgram + labs(title = "This is a histogram"))

hgramt + theme(plot.title = element_text(size = 20))
hgramt + theme(plot.title = element_text(size = 20, color = "red"))
hgramt + theme(plot.title = element_text(size = 20, hjust = 0))
hgramt + theme(plot.title = element_text(size = 20, hjust = 0.5))
hgramt + theme(plot.title = element_text(size = 20, hjust = 1))
hgramt + theme(plot.title = element_text(size = 20, face = "bold"))
hgramt + theme(plot.title = element_text(size = 20, angle = 180))


## element_line()
hgram + theme(panel.grid.major = element_line(color = "red"))
hgram + theme(panel.grid.major = element_line(size = 2))
hgram + theme(panel.grid.major = 
                element_line(linetype = "dotted"))
hgram + theme(axis.line = element_line())
hgram + theme(axis.line = element_line(color = "red"))
hgram + theme(axis.line = element_line(size = 0.5,
                                       linetype = "dashed"))

## element_rect()
hgram + theme(plot.background = element_rect(fill = "grey80",
                                             color = NA))
hgram + theme(plot.background = element_rect(size = 5, color = "red"))
hgram + theme(plot.background = element_rect(color = "red",size = 5,
                                             fill = "grey80"))
hgram + theme(panel.background = element_rect())
hgram + theme(panel.background = element_rect(color = NA))
hgram + theme(panel.background =
                element_rect(linetype = "dotted",
                             size = 5, color = "red"))
hgram + theme(panel.background =
                element_rect(linetype = "dotted", color = "black"))


## theme_blank()
hgramt
last_plot() + theme(panel.grid.minor = element_blank())
last_plot() + theme(panel.grid.major = element_blank())
last_plot() + theme(panel.background = element_blank())
last_plot() + theme(axis.title.x = element_blank(),
                    axis.title.y = element_blank())
last_plot() + theme(axis.line = element_line())


## Custom theme
old_theme <- theme_update(
  plot.background = element_rect(fill = "#3366FF"),
  panel.background = element_rect(fill = "#003DF5"),
  axis.text.x = element_text(color = "#CCFF33"),
  axis.text.y = element_text(color = "#CCFF33", hjust = 1),
  axis.title.x = element_text(color = "#CCFF33",
                              face = "bold"),
  axis.title.y = element_text(color = "#CCFF33",
                              face = "bold", angle = 90)
)
qplot(cut, data = diamonds, geom = "bar")
qplot(cty, hwy, data = mpg)
theme_set(old_theme)


### Customising geoms

### Geoms and stats
update_geom_defaults("point", aes(color = "darkblue"))
qplot(mpg, wt, data = mtcars)
update_stat_defaults("bin", aes(y = ..density..))
qplot(rating, data = movies, geom = "histogram",
      binwidth = 1)


### Drawing maps

library(maps)
data(us.cities)
big_cities <- subset(us.cities, pop > 500000)
qplot(long, lat, data = big_cities) +
  borders("state", size = 0.5)
## or
ggplot(big_cities) +
  aes(long, lat) +
  geom_point() +
  borders("state", size = 0.5)

ggplot(big_cities) +
  aes(long, lat) +
  geom_point() +
  borders("county", size = 0.5)

## Cities in Texas by county.
tx_cities <- subset(us.cities, country.etc == "TX")
ggplot(tx_cities) +
  aes(long, lat) +
  borders("county", "texas", color = "grey70") +
  geom_point(color = alpha("black", 0.5))

## Choropleth maps are a little trickier and a lot
## less automated because it is challenging to match
## the identifiers in your data to the identifiers
## in the map data. The following example shows how
## to use map_data() to convert a map into a data frame,
## which can then be merge()d with your data
## to produce a choropleth map.
library(maps)
states <- map_data("state")
arrests <- USArrests
names(arrests) <- tolower(names(arrests))
arrests$region <- tolower(rownames(USArrests))
choro <- merge(states, arrests, by = "region")
## Reorder the rows because order matters when drawing
## polygons and merge destroys the original ordering
choro <- choro[order(choro$order), ]
## Number of assaults
qplot(long, lat, data = choro, group = group,
      fill = assault, geom = "polygon")
## or
ggplot(choro) +
  aes(long, lat, group = group) +
  geom_polygon(aes(fill = assault))
## Ratio of assaults to murders
qplot(long, lat, data = choro, group = group,
      fill = assault/murder, geom = "polygon")
## or
ggplot(choro) +
  aes(long, lat, group = group) +
  geom_polygon(aes(fill = assault/murder))

## The map_data() function is also useful if you’d
## like to process the map data in some way. In the
## following example we compute the (approximate)
## centre of each county in Iowa and then use those
## centres to label the map.
ia <- map_data("county", "iowa")
mid_range <- function(x) mean(range(x, na.rm = TRUE))
library(plyr)
centres <- ddply(ia, .(subregion), colwise(mid_range,
                                           .(lat, long)))

ggplot(ia, aes(long, lat)) +
  geom_polygon(aes(group = group), fill = NA,
               color = "grey60") +
  geom_text(aes(label = subregion), data = centres,
            size = 2, angle = 45)
