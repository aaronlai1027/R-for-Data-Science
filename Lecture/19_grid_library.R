library(grid)
library(gridBase)
library(ggplot2)


grid.newpage()
vp <- viewport(width = 0.5, height = 0.5)
pushViewport(vp)
grid.rect()

grid.circle(x=0.5, y=0.5, r=0.25)

x <- c(0.2, 0.2, 0.4, 0.7)
y <- c(0.1, 0.4, 0.4, 0.2)
grid.bezier(x, y)  ## curve drawn relative to 4 control points

grid.polygon()
grid.polygon(x=c((0:4)/10, rep(.5, 5), (10:6)/10, rep(.5, 5)),
             y=c(rep(.5, 5), (10:6/10), rep(.5, 5), (0:4)/10),
             id=rep(1:5, 4),
             gp=gpar(fill=1:5))

library(lattice)
xyplot(mpg ~ disp, mtcars)
library(grid)
grid.ls()
current.vpTree()


qplot(uempmed, unemploy, data = economics, geom = "path")

grid.force()
grid.ls()
grid.edit("panel.background..rect.579", gp=gpar(col="red"))
grid.remove("panel.background..rect.538")




opar <- par(no.readonly=TRUE)
# gridFIG
grid.newpage()
plot.new()   ## Needed so both engines are active (I think...)
pushViewport(viewport(width=0.5, height=0.5))
grid.rect(gp=gpar(col="grey", lty="dashed"))
par(fig=gridFIG())
par(new=TRUE)
plot(1:10)
# multiple plots
# NOTE the use of par(mfg)
# gridOMI
par(opar)

grid.newpage()
plot.new()   ## Needed so both engines are active (I think...)
pushViewport(viewport(width=0.5, height=0.5))
grid.rect(gp=gpar(col="grey", lty="dashed"))
par(omi=gridOMI())
par(mfrow=c(2, 2), mfg=c(1, 1), mar=c(3, 3, 1, 0))
for (i in 1:4) {
  plot(i)
}
# gridPLT
par(opar)

grid.newpage()
plot.new()   ## Needed so both engines are active (I think...)
pushViewport(viewport(width=0.5, height=0.5))
grid.rect(gp=gpar(col="grey", lwd=5))
par(plt=gridPLT())
par(new=TRUE)
plot(1:10)
# gridFIG with par(omi) set
par(opar)

grid.newpage()
plot.new()   ## Needed so both engines are active (I think...)
par(omi=rep(1, 4))
pushViewport(viewport(width=0.5, height=0.5))
grid.rect(gp=gpar(col="grey", lwd=5))
par(fig=gridFIG())
par(new=TRUE)
plot(1:10)
# gridPLT with par(omi) set
par(opar)

grid.newpage()
plot.new()   ## Needed so both engines are active (I think...)
par(omi=rep(1, 4))
pushViewport(viewport(width=0.5, height=0.5))
grid.rect(gp=gpar(col="grey", lwd=5))
par(plt=gridPLT())
par(new=TRUE)
plot(1:10)
# gridPAR
par(opar)

grid.newpage()
plot.new()   ## Needed so both engines are active (I think...)
pushViewport(viewport(width=0.5, height=0.5,
                      gp=gpar(col="red", lwd=3, lty="dotted")))
grid.rect(gp=gpar(col="grey", lwd=5))
par(fig=gridFIG())
par(gridPAR())
par(new=TRUE)
plot(1:10, type="b")
