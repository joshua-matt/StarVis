library(tidyverse)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")

dists = filter(stars, dist < 25000 & dist > 0)
vels = mutate(dists, v=(x*vx+y*vy+z*vz)*10^5, d=dist/1000000)

ggplot(data=vels) + geom_point(mapping=aes(x=d,y=v),size=0.1,shape=16)
relation = lm(v~dist,data=vels)
print(relation)