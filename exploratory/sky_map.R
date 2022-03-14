library(tidyverse)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
#select(stars,ra,dec)
angles = mutate(stars,d=dec*3.14159/180,r=-ra*3.14159/12)
coords = mutate(angles,projx=cos(d)*cos(r),projy=cos(d)*sin(r))
north_coords = filter(coords,d>0,ci<2)
south_coords = filter(coords,d<=0,ci<2)
#### Want to use ra, dec, ci, mag to plot sky


#brightness <- function(mag) {
#  return(1/(1+exp(log(99*9)*mag/7+(2/7)*log(99*9)-log(9))))
#}

brightness <- function(mag) {
  return(1.15^(-mag-1.46))
} # difficulty seeing southern stars makes me think there's a star entered incorrectly
north_bright = filter(north_coords, mag<5,-2<mag)
south_bright = filter(south_coords, mag<5, -1<mag)
#north_circum = filter(north_bright, abs(projx)<0.5 & abs(projy)<0.5)

ggplot(data=north_bright) + geom_point(mapping=aes(x=projx,y=projy,color=ci,alpha=brightness(mag)),stroke=0,shape=16,size=0.5) + scale_color_gradientn(colors=rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))) + theme(panel.background = element_rect(fill="black"), aspect.ratio=1, panel.grid.major = element_line(color="#000000"), panel.grid.minor=element_line(color="#000000"))

