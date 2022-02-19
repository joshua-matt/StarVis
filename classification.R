library(tidyverse)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")

### PLOT: Bar chart of spectral types
## Maybe categorize only by letters?
ggplot(data=stars) + geom_bar(mapping=aes(x=spect))

### PLOT: Bar chart of spectral types imposed on HR diagram