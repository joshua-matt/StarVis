library(tidyverse)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
dists = filter(stars, dist < 25000 & dist > 0)
main_seq = filter(stars, ci < 2)
main_seq_dist = filter(dists, ci < 2)

### PLOT: HR diagram including bright stars without distance entry
#ggplot(data=main_seq) + geom_point(mapping = aes(x=ci,y=-1*absmag,color=ci),size=0.1,stroke=0,shape=16,alpha=0.2) + scale_color_gradientn(colors=rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))) + theme(panel.background = element_rect(fill="black"), aspect.ratio=4/3, panel.grid.major = element_line(color="#333333"), panel.grid.minor=element_line(color="#333333"))

### PLOT: HR diagram excluding bright stars without distance entry
#ggplot(data=main_seq_dist) + geom_point(mapping = aes(x=ci,y=-1*absmag,color=ci),size=0.1,stroke=0,shape=16,alpha=0.2) + scale_color_gradientn(colors=rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))) + theme(panel.background = element_rect(fill="black"), aspect.ratio=4/3, panel.grid.major = element_line(color="#333333"), panel.grid.minor=element_line(color="#333333"))

main_seq_bright = filter(main_seq, -1*absmag>5)

### PLOT: HR diagram of only bright stars without distance entry
#ggplot(data=main_seq_bright) + geom_point(mapping = aes(x=ci,y=-1*absmag,color=ci),size=0.1,stroke=0,shape=16,alpha=0.4) + scale_color_gradientn(colors=rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))) + theme(panel.background = element_rect(fill="black"), aspect.ratio=4/3, panel.grid.major = element_line(color="#333333"), panel.grid.minor=element_line(color="#333333"))

### PLOT: ra vs. dec of bright stars
## Questions: what is the weird curve traced out in the middle? Looks like boundary of day/night when projected onto map
#ggplot(data=main_seq_bright) + geom_point(mapping = aes(x=ra,y=dec,color=ci),size=0.1,stroke=0,shape=16,alpha=0.4,color="#FFFFFF") + theme(panel.background = element_rect(fill="black"), aspect.ratio=4/3, panel.grid.major = element_line(color="#333333"), panel.grid.minor=element_line(color="#333333"))