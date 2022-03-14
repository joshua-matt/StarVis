library(tidyverse)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
temps = mutate(stars, t=4600*(1/(0.92*ci+1.7)+1/(0.92*ci+0.62)))

head(temps)

### Not interesting, just a transformation of the main sequence plot
#ggplot(data=temps) + geom_point(mapping=aes(x=absmag,y=t), size=0.1,size=16)
