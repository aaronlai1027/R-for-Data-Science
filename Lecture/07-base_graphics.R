#### Class 7: Thursday February 1

## Base graphics.
## Use of par() (`mfrow`, `mar`, `mai`, `mgp`, `tck`).
## Use of `layout()`.
## Exporting plots to different file formats.

## Base graphics
## Author of base graphics: Ross Ihaka

## We already know how to display individual plots.
a <- rnorm(500)
plot(a)
hist(a)
boxplot(a)

## What can we do if we want to display more than
## one plot together.

## First we need to introduce par().
## par() is used to query or set graphical parameters.
## There are lots of parameters, with default values:
par()
length(par())  ## Number of parameters

## You can ask for specific parameters, such as mfrow
## that determines the number of plots plotted together. 
par("mfrow")
## This means one row and one column, that only
## accomodates one plot.

## Let's modify it to two rows and one column
par(mfrow = c(2, 1))
plot(a)
hist(a)
## Now to one row and two columns
par(mfrow = c(1, 2))
plot(a)
hist(a)

## What if we want to modify margins?
## We can use mar (or mai)
## mar: A numerical vector of the form
##      c(bottom, left, top, right)
##      which gives the number of lines of margin
##      to be specified on the four sides of the plot.
##      The default is c(5, 4, 4, 2) + 0.1.
par(mar=c(2, 2, 2, 1))
plot(a)
hist(a)

## mai: Same as mar but in inches.
## par(mai = c(1.02, 0.82, 0.82, 0.42))  ## Default

## mgp: The margin line (in mex units) for the:
##  1: axis title,
##  2: axis labels and
##  3: axis line.
##  Note that mgp[1] affects title whereas mgp[2:3]
##  affect axis. The default is c(3, 1, 0).
par(mgp=c(1.1, 0.15, 0))
plot(a)
hist(a)

## Note on mex from help:
## "mex is a character size expansion factor which
## is used to describe coordinates in the margins of plots.
## Note that this does not change the font size,
## rather specifies the size of font (as a multiple of csi)
## used to convert between mar and mai, and between
## oma and omi."

## tck: The length of tick marks as a fraction of the
## smaller of the width or height of the plotting region.
## If tck >= 0.5 it is interpreted as a fraction of the
## relevant side, so if tck = 1 grid lines are drawn.
## The default setting (tck = NA) is to use tcl = -0.05.
par(tck = -0.01)
plot(a)
hist(a)

## You can set more than one parameter at the same time
par(mar = c(2, 2, 2, 1),
    mgp = c(1.1, 0.15, 0),
    tck = -0.01)
plot(a)
hist(a)

## Your turn
## Take some time to explore changing
## values for mar, mgp, and tck.

## Now, what happens if we want to show
## the three plots together
plot(a)
hist(a)
boxplot(a)
## Not good
## We can change mfrow
par(mfrow = c(2, 2))
plot(a)
hist(a)
boxplot(a)
## Not good either
par(mfrow = c(3, 1))
plot(a)
hist(a)
boxplot(a)
## Perhaps
par(mfrow = c(1,3))
plot(a)
hist(a)
boxplot(a)

## We can get a greater control if we use layout()
## Syntax:
## layout(mat,
##       widths = rep.int(1, ncol(mat)),
##       heights = rep.int(1, nrow(mat)),
##       respect = FALSE)
layout(mat = matrix(c(2, 2,
                      1, 3), 2,byrow = TRUE))
## The matrix represents how the plots
## are distributed. Each number is the
## plot (1 the first plot, 2 the second
## and 3 the third). In this case it means
## you want the second plot in the top row,
## the first plot in the second row first
## column, and the third plot in the second
## row second column
## You can use
layout.show(n = 3)
## if you need to visualize where the plots
## will be placed.

plot(a)
hist(a)
boxplot(a)

## You can change the aspect ratio using
## widths and heights.
## Changing widths
layout(mat = matrix(c(2, 2,
                      1, 3), 2,byrow = TRUE),
       widths = c(2, 1))
plot(a)
hist(a)
boxplot(a)
## The interpretation is that 2/3 of the
## space will be used by the first
## and 1/3 by the second.

## Changing heights
layout(mat = matrix(c(2, 2,
                      1, 3), 2,byrow = TRUE),
       heights = c(3, 2))
plot(a)
hist(a)
boxplot(a)

## Changing both
layout(mat = matrix(c(2, 2,
                      1, 3), 2,byrow = TRUE),
       widths = c(2, 1),
       heights = c(3, 2))
plot(a)
hist(a)
boxplot(a)


## respect=TRUE will assure that each unit
## column-width is the same physical
## measurement on the device as a unit
## row-height.
layout(mat = matrix(c(2, 2,
                      1, 3), 2, byrow = TRUE),
       widths = c(2, 1),
       heights = c(3, 2),
       respect = TRUE)
plot(a)
hist(a)
boxplot(a)

## respect can also take a matrix
## with 0 or 1 and the same
## structure as mat. In this 
## case will only be applied to
## the boxplot (but will change
## the width of the scatterplot
## as a result)
layout(mat = matrix(c(2, 2,
                      1, 3), 2, byrow = TRUE),
       widths = c(2, 1),
       heights = c(3, 2),
       respect = matrix(c(0, 0,
                          0, 1), 2, byrow = TRUE))
plot(a)
hist(a)
boxplot(a)


## Graphic querying functions

## Normal screen device
options('device')
## Current device
dev.cur()
## Note: this is created by rstudio
## Available devices
capabilities()

## Create an external screen
## X11(width = 10, height = 6)     ## for Linux
## windows(width = 10, height = 6) ## for Windows
## quartz(width = 10, height = 6)  ## for Mac
plot(a)
## The plot was sent to the external screen
## Note: The values we changed with par
## and the layout are the defaults. You need
## to resend those commands for each open
## device. 

## Creating a pdf to send the plot.
## Note: with default values of par
## and default. You can change the
## aspect ratio with width and height
## (default: 8, 8)
pdf(file = "test.pdf", width = 10, height = 6)
hist(a)
dev.off()
## dev.off() closes the device

## Modifying default values.
pdf(file = "test.pdf", width = 10, height = 6)
par(mar = c(2, 2, 2, 1),
    mgp = c(1.1, 0.15, 0),
    tck = -0.01)
layout(mat = matrix(c(2, 2,
                      1, 3), 2,byrow = TRUE),
       widths = c(2, 1),
       heights = c(3, 2),
       respect = FALSE)
plot(a)
hist(a)
boxplot(a)
dev.off()

## You can use pointsize (default 12) to
## change the sizes of text and elements
## in the plot.
pdf(file = "test.pdf", width = 10, height = 6,
    pointsize = 20)
par(mar = c(2, 2, 2, 1),
    mgp = c(1.1, 0.15, 0),
    tck = -0.01)
layout(mat = matrix(c(2, 2,
                      1, 3), 2, byrow = TRUE),
       widths = c(2, 1),
       heights = c(3, 2),
       respect = FALSE)
plot(a)
hist(a)
boxplot(a)
dev.off()

## For web, it may be better to produce a png.
## Note: units in pixels (default 480 480)
png(file = "test.png", width = 800, height = 600)
hist(a)
dev.off()
## Again, use pointsize to modify
## sizes of elements
png(file = "test.png", width = 800, height = 600,
    pointsize = 30)
hist(a)
dev.off()

## You can also produce a jpeg
jpeg(file = "test.jpeg", width = 800, height = 600)
hist(a)
dev.off()

## Library lattice, using grid graphic system, from which
## ggplot2 got inspired.
library(lattice)
demo(lattice)
