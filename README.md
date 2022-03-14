# StarVis
This repository is for a data visualization project studying a database of 120,000 stars. I use the [HYG 3.0](https://drive.google.com/file/d/1HSYwR0N8DmJ10MELgu2ruB4kY-72MZbP/view?usp=sharing) dataset, which can be read more about [here](http://www.astronexus.com/hyg).

## Purpose
The purpose of this tool is to allow astronomers of any level to study the night sky according to some basic properties of stars: brightness, temperature, and distance. The main contribution of this software is the Map mode, which lets users filter out stars in the night sky to create a custom star map. The Map mode is supplemented by a Histogram mode, which lets users see the distributions of the three given properties over their filtered night sky.

## Data
As stated above, this project uses the [HYG 3.0](https://drive.google.com/file/d/1HSYwR0N8DmJ10MELgu2ruB4kY-72MZbP/view?usp=sharing) dataset. HYG is the amalgamation of three stellar datasets: the Hipparcos catalog, which provides positional information, the Yale Bright Star catalog, which provides information about star names and colors, and the Gliese catalog, which covers nearly all stars within 75 lightyears. The variables of the dataset used in StarVis are
	- _ra_ (the horizontal position of the star on the celestial sphere),
	- _dec_ (the vertical position of the star on the celestial sphere),
	- _mag_ (how bright the star looks from Earth),
	- _absmag_ (how much light the star gives off),
	- [_ci_](https://en.wikipedia.org/wiki/Color_index) (the color of the star),
	- _dist_ (how many parsecs away the star is).
	
## Process
The dataset already came in a .csv format, so no tidying was necessary. However, within the code, new variables are computed to accommadate more familiar units of measurement and, in one case, to infer one quantity (temperature) from another quantity (_ci_).

This project began with the creation of a [Hertzsprung-Russell diagram](https://en.wikipedia.org/wiki/Hertzsprung%E2%80%93Russell_diagram) to serve as a gut check that I had the correct data and understood its context. This diagram is a scatterplot of _ci_ vs _absmag_ and reveals many distinct stages of stellar evolution. I then explored other relationships in the data, such as that between _ra_ and _dec_ or _dist_ and velocity away from earth. The files containing these exploratory visualizations may be found in the `exploratory` folder. I eventually settled on the idea of reconstructing a map of the sky, simply because it seemed interesting and satisfying.
	
## Questions and Insights

### Questions
In this project, my primary question was: what features of the night sky become prominent under different filters? What do these tell us about the local structure of the universe?

### Insights
The main insight given through brief use of this software are that, within the dataset, the more distant parts of the sky consist primarily of uniformly-distributed cooler red-orange stars and the concentrated band of hotter white-blue stars given by the galactic disc of the Milky Way. This conclusion is numerically supported by viewing the histogram corresponding to this filter: the histogram of temperature is bimodal. The greater intuition afforded by Map mode lets us easily interpret and understand the context of this histogram.

## Improvements
Many features of StarVis were left out due to time constraints. These include the ability to rotate the celestial sphere and center the viewport on any star in the sky for more flexible viewing and the incorporation of _absmag_ into filtering. Additionally, some aspects of the UI could be smoother, such as the layout of the viewing page and the speed of map rendering.






## Time log:
### 2/8
25mins - exploratory analysis on color vs brightness

10mins - exploratory analysis on ra vs dec

20mins - trying to come up with function for projecting celestial sphere to a plane

40mins - refining visualization of northern sky

### 2/9
80mins - figuring out how to determine the alpha for each star given its magnitude

### 2/15
35mins - figuring out plots for distance vs velocity away from sun

	- then learned that within local group, expansion of universe is not measurable ;_;

### 2/16
20mins - looking into spectra, stellar temperatures

### 2/17
10mins - investigate magnitude vs distance

15mins - explore distribution of brightness, distance

### 2/22
75mins - moving to Shiny, plotting multiple histos on one axis

### 2/24
50mins - making skymap interactive

### 3/3
30mins - fixing brightness function

### 3/4
50mins - adding more customization, cleaning up display

### 3/10
120mins - determining ui layout, implementing large plot

### 3/12
180mins - making ui elements fit together nicely, adding extra map filters

### 3/13
60mins - interactive histograms

### 3/14
60mins - commenting code

