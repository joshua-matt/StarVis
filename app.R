library(shiny)
library(tidyverse)

# Load dataset of 120k nearby stars
stars <- read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")

# Back end
server <- function(input,output) {
  
  brightness <- function(mag, min, max, b0=0.1) { # Computes how brightly to display a star given the brightness range
    if (input$eq_bright) # If the user selects equal brightness
      return(0.8)        # return the same value for all stars
    return((1-b0)*mag/(min-max)+b0) # Linear brightness function where f(min)=1, f(max)=b0
  }
  
  
  output$map <- renderPlot({
    ### REPROCESS DATA ON USER ACTION ###
    
    # First mutate: Convert declination and right ascension from degrees to radians
    #               and apply the polar rotation given by the user
    # Second mutate: Project the celestial sphere to the plane, converting  
    #                to Cartesian coordinates
    angles <- stars %>% mutate(d=dec*3.14159/180,r=-(ra-(input$ang/15))*3.14159/12) %>% mutate(projx=cos(d)*cos(r),projy=cos(d)*sin(r))
    
    # Calculate surface temperature given the color of the star using Ballasteros' Formula (https://en.wikipedia.org/wiki/Color_index)
    processed <- mutate(angles, temp=4600*(1/(0.92*ci+1.7)+1/(0.92*ci+0.62))*1.8-459.67, # Get surface temperature in Fahrenheit
                        dist_l=dist*3.26156378)  # Get distance in lightyears
    
    # 
    #processed = filter(processed, ci<2)
    
    if (input$ns == "Northern Sky")
      stars_filter <- filter(processed, d>0) # Stars above equator have positive declination
    else
      stars_filter <- filter(processed, d<0)
    
    # Apply user filters
    stars_filter <- filter(stars_filter, 
                           mag<input$bright[2],
                           input$bright[1]<mag,
                           temp<input$temp[2],
                           input$temp[1]<temp,
                           dist_l<input$dist[2],
                           input$dist[1]<dist_l)
    
    if (input$sh_color) # Show star color
      colors = rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))
    else                # Make stars white
      colors = c("#FFFFFF")
    
    
    ### PLOT RENDERING ###
    if (input$plt == "Map") { # Map mode
      # Create map of sky with a scatterplot of the projected Cartesian coordinates
      ggplot(data=stars_filter) +
        geom_point(mapping=aes(x=projx,y=projy,color=ci, # Color stars according to color index
                               alpha=brightness(mag, input$bright[1], input$bright[2])),
                   size=input$sz*0.4, stroke=0,shape=16, show.legend=FALSE) + # Star display size
        scale_color_gradientn(colors=colors, limits=c(-0.5, 2)) + # Choose gradient and set absolute scale
        theme(panel.background = element_rect(fill="black"), # Black background
              aspect.ratio=1, # Square plot
              panel.grid = element_line(color="#000000"), # No gridlines
              axis.title=element_blank(), # Show only the plot, no text
              axis.ticks=element_blank(), 
              axis.text=element_blank(),
              plot.margin = margin(t=0,r=0,b=0,l=0), # No margins
              plot.background = element_rect(fill="black")) + # Black margins, just in case
        coord_cartesian(ylim=c(-1/input$zoom,1/input$zoom),xlim=c(-1/input$zoom,1/input$zoom)) # Determine viewport scale by user zoom
    } else { # Histogram mode
      # Set the histogram variable based on user selection
      if (input$hist_var == "Distance") {
        stars_filter = mutate(stars_filter, hist_var=dist_l)
        processed = mutate(processed,hist_var=dist_l)
      } else if (input$hist_var == "Temperature") {
        stars_filter = mutate(stars_filter, hist_var=temp)
        processed = mutate(processed,hist_var=temp)
      } else {
        stars_filter = mutate(stars_filter, hist_var=mag)
        processed = mutate(processed,hist_var=mag)
      } 
      
      # Create simple histogram
      ggplot(data=stars_filter) +
        geom_histogram(mapping = aes(x=hist_var)) + labs(x=input$hist_var) + 
        coord_cartesian(xlim=c(0,max(stars_filter$hist_var)))
    }
  } ,
  height=reactive(ifelse(!is.null(input$innerWidth),input$innerWidth*3/5,0)) # Make plot fill its container. Code from [1]
  )
}

# Front end
ui <- fillPage(
  tags$head(tags$script('$(document).on("shiny:connected", function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            $(window).resize(function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            ')), # Make plot fill its container. Code from [1]
  fillRow(flex=c(2,3), # 40/60 split for controls/plot
          ## CONTROLS PANEL ##
          div(style="height:100%;width:100%;background-color:#F5F5F5;", # Blend in with wellPanel color
              wellPanel(style="height=100%;padding:0;",
                        navbarPage(title="StarVis", # User controls split into tabs
                                   inverse=TRUE, # Cool dark theme
                                   
                                   ## INFO PANEL ##
                                   # General information, first thing user sees
                                   tabPanel("", icon=icon("info"),
                                            strong(h2("Welcome to StarVis!")),
                                            p("This is a tool for developing intuition about the basic properties of nearby stars."),
                                            p("To change which stars are visible, click the 'Filters' tab."),
                                            p("To edit viewport settings and switch between Map and Histogram modes, click the 'View' tab.")),
                                   
                                   ## FILTER PANEL ##
                                   # Control which stars are displayed
                                   tabPanel("Filter", icon=icon("filter"),
                                            sliderInput("bright", label="Apparent Brightness", min=-2, max= 10, step=0.5, value=c(-2,5), dragRange=TRUE),
                                            sliderInput("temp", label="Surface Temperature (\u00B0F)", min=5000, max=28000, step=100, value=c(5000,26000), dragRange=TRUE),
                                            sliderInput("dist", label="Distance (Lightyears)", min=0, max=3500, step=25, value=c(0,2500), dragRange=TRUE)),
                                   
                                   ## VIEW PANEL ##
                                   # Edit how the plots look
                                   tabPanel("View", icon=icon("eye"),
                                            splitLayout(
                                              div(style="overflow-x:hidden;",
                                                  sliderInput("ang", label="Polar Rotation (\u00B0)", min=-180,max=180,value=0)), 
                                              sliderInput("sz", label="Star Display Size", min=1, max=5, value=2, step=0.5)), # Scatterplot point size
                                            splitLayout(
                                              checkboxInput("sh_color", label="Show star color", value=TRUE),
                                              checkboxInput("eq_bright", label="Equalize brightness", value=FALSE)),
                                            sliderInput("zoom", "Map Zoom", min=1, max=20, value=1),
                                            splitLayout(
                                              radioButtons("ns", label="View:", choices=c("Northern Sky", "Southern Sky")),
                                              radioButtons("plt", label="Mode:", choices=c("Map", "Histogram"))),
                                            selectInput("hist_var", label="Histogram Variable", choices=c("Distance","Temperature","Brightness")))))),
          ## PLOT PANEL ##
          div(style="height:100%;width:100%;background-color:black;", plotOutput("map"))))

shinyApp(ui=ui, server=server)

# [1]: https://stackoverflow.com/questions/40538365/r-shiny-how-to-get-square-plot-to-use-full-width-of-panel