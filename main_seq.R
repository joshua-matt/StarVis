library(tidyverse)
library(dplyr)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")

dists = filter(stars, dist < 25000 & dist > 0)
main_seq = filter(stars, ci < 2)

ggplot(data=main_seq) + geom_point(mapping = aes(x=ci,y=-1*absmag,color=ci),size=0.1,stroke=0,shape=16) + scale_color_gradientn(colors=rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))) + theme(panel.background = element_rect(fill="black"), aspect.ratio=4/3, panel.grid.major = element_line(color="#333333"), panel.grid.minor=element_line(color="#333333"))