## Paul Murrell
library(grid)
library(gridBase)

## When you run
grid.newpage()
## the previous plot is erased, and the whole plotting
## area is the active viewport.
## A viewport is a rectangular area where you are interested in
## performing output. It is defined relative to the
## active area (the whole plotting region for now).

## For example, let's define a viewport positioned
## in the middle of the whole plotting area, taking
## all the available space.
vp <- viewport(x = 0.5, y = 0.5)

## Note: grid.show.viewport is used to verify visually that the
## viewport has been defined successfully, and looks as expected.
## Once you are happy with the result, you should comment or delete it.
## It should not be part of your final plot.
grid.show.viewport(vp)

## Note: "npc". Normalised Parent Coordinates (the default).

## you can specify the width
vp <- viewport(x = 0.5, y = 0.5, width = 0.5)
grid.show.viewport(vp)

## and the height
vp <- viewport(x = 0.7, y = 0.5, width = 0.6, height = 0.4)
grid.show.viewport(vp)

## ggplot2 uses the grid library to create its plots
library(ggplot2)
qplot(x = cty, y = hwy, data = mpg)

## Suppose that, instead of using the whole available space,
## we want to plot it in the viewport defined above:
grid.newpage()
## You need to print the plot, specifying in which viewport:
print(qplot(x = cty, y = hwy, data = mpg), vp = vp)


## You can even specify the angle
vp <- viewport(x = 0.5, y = 0.5, width = 0.5, height = 0.25, angle = 45)
grid.show.viewport(vp)

vp <- viewport(x = 0.3, y = 0.7, width = 0.5, height = 0.25, angle = 45)
grid.show.viewport(vp)

## Justification (it was centered by default)
vp <- viewport(x = 0.5, y = 0.5, width = 0.4, height = 0.25,
               just = c("left", "bottom"), angle = 45)
grid.show.viewport(vp)

vp <- viewport(x = 0.5, y = 0.5, width = 0.5, height = 0.25,
               just = c("left", "top"), angle = 45)
grid.show.viewport(vp)

vp <- viewport(x = 0.5, y = 0.5, width = 0.5, height = 0.25,
               just = c("right", "bottom"), angle = 45)
grid.show.viewport(vp)



## Your turn: given the three plots:
(a <- qplot(date, unemploy, data = economics,
            geom = "line"))
(b <- qplot(uempmed, unemploy, data = economics) +
  geom_smooth(se = F))
(c <- qplot(uempmed, unemploy, data = economics,
            geom="path"))

## devise a strategy to be able to plot them in *one* figure
## such that 'a' is plotted on the top half, while 'b' and 'c'
## are plotted in the bottom, using half of the space each.



 
## Begin solution

vp1 <- viewport(x = 0, y = 1, width = 1, height = 0.5,
               just = c("left", "top"))
grid.show.viewport(vp1)

vp2 <- viewport(x = 0, y = 0.5, width = 0.5, height = 0.5,
                just = c("left", "top"))
grid.show.viewport(vp2)

vp3 <- viewport(x = 0.5, y = 0.5, width = 0.5, height = 0.5,
                just = c("left", "top"))
grid.show.viewport(vp3)

grid.newpage()
print(a, vp=vp1)
print(b, vp=vp2)
print(c, vp=vp3)

## End solution


## The viewports can be defined in any place, 
## givin a chance to embed one plot on another

## Your turn. Print 'c' as an embedded plot of 'b'



## Begin solution
embvp <- viewport(x = 0.5, y = 0.4, width = 0.4, height = 0.3,
                  just = c("left", "top"))
grid.show.viewport(embvp)

grid.newpage()
b
print(c,vp=embvp)
## End solution



## Pushing and popping viewports.
## When you work with graphics primitives (points, text, ...),
## they are plotted relative to the active viewport. Then
## the strategy is to push viewports, so they become active
## and pop them when you are done. An example will clarify this
grid.newpage()
## The above creates a viewport, that contains the whole
## plotting region.

## We will create two viewports, whose definition is relative
## to the active viewport:
vp1 <- viewport(x = 0, y = 0.5, w = 0.5, h = 0.5,
                just = c("left", "bottom"))
vp2 <- viewport(x = 0.5, y = 0, w = 0.5, h = 0.5,
                just = c("left", "bottom"))
## grid.show.viewport(vp1)
## grid.show.viewport(vp2)

## Pushing the first viewport
pushViewport(vp1)
## This means that now 'vp1' is active, and
## all the plotting primitives will display relative to it.
## For example, drawing a rectangle around the vp1 viewport:
grid.rect(gp = gpar(col = "blue"), width = 1/3)
## or plotting some text:
grid.text("Some text in graphics region 1", y=0.8)
grid.text("Some more text in graphics region 1", x=0.9, y=0.02)
## You are not limited to inside the viewport.
## Placing some text outside
grid.text("Text outside region 1", x=0.6, y=-0.3)
## The origin is relative to the viewport
grid.text("Origin", x=0, y=0, just = c("left", "bottom"))
## popping the viewport, coming back to the root viewport
popViewport()
## If we plot some text, will be relative to the whole region
## (root viewport)
grid.text("Origin", x=0, y=0, just = c("left", "bottom"))
## Pushing the second viewport
pushViewport(vp2)
grid.rect(gp=gpar(col="red", lty = "dashed"))
grid.text("Some text in graphics region 2", y=0.8)
popViewport()
## Pushing again the first viewport
pushViewport(vp1)
grid.text("More text in region 1", y=0.2)
popViewport()




## Nesting the same viewport.
## The same viewport can be reused, pushing
## it several times. Each time its definition is interpreted
## relative to the active viewport (that can be itself!)
vp <- viewport(width = 0.5, height = 0.5)
grid.newpage()
pushViewport(vp)
grid.rect(gp = gpar(col = "grey"))
grid.text("quarter of the page", y = 0.85)
pushViewport(vp)
grid.rect()
grid.text("quarter of\nprevious viewport", y = 0.9)
pushViewport(vp)
grid.rect()
grid.text("quarter of\nprevious\nviewport")
## We are popping the 3 viewports together
popViewport(3)

## Axes and coordinates
grid.newpage()
pushViewport(viewport(y = unit(3, "lines"), width = 0.8,
                      height = 0.8, just = "bottom", xscale = c(0, 500)))
grid.rect(gp = gpar(col = "grey"))
grid.xaxis()
grid.yaxis()
pushViewport(viewport(x=unit(250, "native"),
                      y=unit(0.7, "npc"),
                      width=unit(1, "strwidth",
                                 "This is my unit size for the width!"),
                      height = unit(2, "inches"),
                      yscale=c(300, 1000)))
grid.rect()
grid.xaxis()
grid.yaxis(at=c(300, 800, 1000))
grid.text("This is my unit size for the width!")
popViewport(2)

## Creating a first plot
grid.newpage()
## Suppose we want to create the following base plot
x <- seq(0, 10, l = 50)
y <- x^2
plot(x, y, main = "Plot of y on x")
 
## from scratch. You will need to do something like:
grid.newpage()
## Create a Viewport with a Standard Plot Layout
## margins: A numeric vector interpreted in the same way as par(mar)
##          in base graphics.
pushViewport(plotViewport(margins = c(5.1, 4.1, 4.1, 2.1)))
## Create a Viewport with Scales based on Data
pushViewport(dataViewport(x, y))
grid.rect()
grid.xaxis()
grid.yaxis()
grid.points(x, y, pch=1, size=unit(0.025, "npc"))
grid.text("x", x = unit(-3, "lines"), rot = 90)
grid.text("y", y = unit(-3, "lines"))
grid.text("Plot of y on x", y = 1.15,
          gp = gpar(fontface = "bold", cex = 1.2))
popViewport(2)


## More advance example. We will create a function
## that plots a stacked barplot, that receives
(barData <- SummeryT1)
(boxColors <- 1:6)
## as parameters

SummeryT1 <- matrix(1:30,ncol=5)
SummeryT1[,1] <- SummeryT[,2]/sum(SummeryT[,2])
SummeryT1[,2] <- SummeryT[,3]/sum(SummeryT[,3])
SummeryT1[,3] <- SummeryT[,4]/sum(SummeryT[,4])
SummeryT1[,4] <- SummeryT[,5]/sum(SummeryT[,5])
SummeryT1[,5] <- SummeryT[,6]/sum(SummeryT[,6])

bp <- function(barData, boxColors) {
  nmeasures <- nrow(barData)
  nbars <- ncol(barData)
  barTotals <- rbind(rep(0, nbars),
                     apply(barData, 2, cumsum))
  barYscale <- c(0, max(barTotals) * 1.05)
  pushViewport(plotViewport(c(5.1, 4.1, 4.1, 2.1),
                            yscale=barYscale,
                            layout=grid.layout(1, nbars)))
  grid.rect()
  grid.yaxis()
  i <- 2
  for (i in 1:nbars) {
    pushViewport(viewport(layout.pos.col = i,
                          yscale = barYscale))
    grid.rect(x = rep(0.5, nmeasures),
              y = unit(barTotals[1:nmeasures,i], "native"),
              height = unit(diff(barTotals[,i]), "native"),
              width = 0.8, just = "bottom",
              gp = gpar(fill = boxColors))
    grid.text(i, y = unit(-1, "lines"))
    popViewport()
  }
  popViewport()
}

## Calling the function
grid.newpage()
bp(barData, boxColors)


## Plots in rectangular grids
## When you want your plots in rectangular grids, you can
## use grid.layout. For example, for a grid of 4 rows
## and 5 columns:
grid.newpage()
ly = grid.layout(4, 5)
grid.show.layout(ly)  ## Remember this is only for verification

## Let's start from a new plot, so we erase the above
grid.newpage()
## Create the grid
pushViewport(viewport(layout = grid.layout(4, 5)))
## Make active the cell in row 3 and columns 2 and 3
pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 2:3))
## Show a rectangle
grid.rect(gp = gpar(lwd = 3))
## and some text
grid.text("Row 3, columns 2 and 3")
grid.xaxis()
grid.yaxis()
popViewport()
pushViewport(viewport(layout.pos.row = 1:2, layout.pos.col = 3:4))
grid.rect(gp = gpar(lwd = 3))
grid.text("Rows 1 and 2,\n columns 3 and 4")
popViewport()


## Your turn: using grid.layout, repeat the plot
## that had 'a' on top, and 'b' and 'c' on the bottom


## Begin solution
## End solution

 
## The grid can have cells of different sizes.
## You can specify them
## 1) by using units
grid.newpage()
pushViewport(viewport(layout=grid.layout(2, 2,
                                         widths = unit(c(3/5, 2/5), "npc"),
                                         heights = unit(c(3/7, 4/7), "npc"))))

## or directly their weigths:
grid.newpage()
pushViewport(viewport(layout=grid.layout(2, 2,
                                         widths=c(3, 2),
                                         heights=c(3, 4))))

