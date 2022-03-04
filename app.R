library(shiny)
library(tidyverse)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
dists = filter(stars, dist < 25000)
far = filter(stars,dist > 25000)
bright = filter(dists,absmag < 1)
dim = filter(dists,absmag>1)

# 
# # Define UI for app that draws a histogram ----
# ui <- fluidPage(
#   
#   # App title ----
#   titlePanel("StarVis"),
#   
#   # Sidebar layout with input and output definitions ----
#   sidebarLayout(
#     
#     # Sidebar panel for inputs ----
#     sidebarPanel(
#       
#       # Input: Slider for the number of bins ----
#       sliderInput(inputId = "bins",
#                   label = "Number of bins:",
#                   min = 5,
#                   max = 100,
#                   value = 30)
#       
#     ),
#     
#     # Main panel for displaying outputs ----
#     mainPanel(
#       
#       # Output: Histogram ----
#       plotOutput(outputId = "distPlot", width="100%"),
#       plotOutput(outputId = "brightDistPlot", width="100%")
#     )
#   )
# )
#   
# # Define server logic required to draw a histogram ----
# server <- function(input, output) {
#   
#   # Histogram of the Old Faithful Geyser Data ----
#   # with requested number of bins
#   # This expression that generates a histogram is wrapped in a call
#   # to renderPlot to indicate that:
#   #
#   # 1. It is "reactive" and therefore should be automatically
#   #    re-executed when inputs (input$bins) change
#   # 2. Its output type is a plot
#   output$distPlot <- renderPlot({
#     
#     x    <- dim$dist
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
#     
#     hist(x, breaks = bins, col = "#75AADB", border = "blue",
#          xlab = "Distance",
#          main = "Distribution of Stellar Distance")
#     
#   })
#   
#   output$brightDistPlot <- renderPlot({
#     
#     x    <- bright$dist
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
#     
#     hist(x, breaks = bins, col = "#75AADB", border = "red",
#          xlab = "Distance",
#          main = "Distribution of Stellar Distance")
#     
#   })
#   
# }
#   

ui = navbarPage(title="StarVis",
                tabPanel("Histograms", 
                         h1("Test App"),
                         sliderInput("bins", label="Number of bins", min=5, max=100, value=30),
                         # splitLayout(
                         #   plotOutput("bright"),
                         #   plotOutput("dim")
                         # )
                         plotOutput("hist")),
                tabPanel("HR Diagram", "big chungo"),
                tabPanel("Star Map",
                         sidebarLayout(sidebarPanel(sliderInput("ang", label="Polar Rotation", min=-180,max=180,value=0),
                                                    sliderInput("sz", label="Star Size", min=1, max=10,value=3),
                                                    sliderInput("bright", label="Star Brightness", min=-2, max=10, step=0.5, value=c(-2,5), dragRange=TRUE),
                                                    checkboxInput("sh_color", label="Show star color", value=TRUE),
                                                    checkboxInput("eq_bright", label="Equalize brightness", value=FALSE)),
                                       mainPanel(plotOutput("map"))
                                       )
                         )
               
)

stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
#select(stars,ra,dec)
angles = mutate(stars,d=dec*3.14159/180,r=-ra*3.14159/12)
coords = mutate(angles,projx=cos(d)*cos(r),projy=cos(d)*sin(r))
north_coords = filter(coords,d>0,ci<2)
south_coords = filter(coords,d<=0,ci<2)
#### Want to use ra, dec, ci, mag to plot sky



size <- function(mag) {
  return(if (mag > 3) 0.1 else -mag+3)
}

north_bright = filter(north_coords, mag<5,-2<mag)
south_bright = filter(south_coords, mag<5, -1<mag)

server = function(input, output) {
  brightness <- function(mag, min, max, b0=0.1) {
    if (input$eq_bright)
      return(0.8)
    return((1-b0)*mag/(min-max)+b0)
  }
  # output$bright = renderPlot({
  #       x    <- bright$dist
  #       bins <- seq(min(x), max(x), length.out = input$bins + 1)
  # 
  #       hist(x, breaks = bins, col = "#FF0000",
  #            xlab = "Distance",
  #            main = "Bright Star Distances")
  # 
  #     })
  # output$dim = renderPlot({
  #   x    <- dim$dist
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  # 
  #   hist(x, breaks = bins, col = "#00FF00",
  #        xlab = "Distance",
  #        main = "Dim Star Distances")
  # 
  # })
  #output$hist = renderPlot({
  #  data = bind_rows(lst(bright,dim))
  #  ggplot() + geom_histogram(data=dim, mapping=aes(x=dist), bins=input$bins, color="blue") + geom_histogram(data=bright, mapping=aes(x=dist), bins=input$bins, color="red") 
  #})
  output$hist = renderPlot({
    ggplot(data=dists) + geom_histogram(mapping=aes(x=dist, fill=absmag < 1), bins=input$bins)
  })
  
  output$map = renderPlot({ ### MAKR ERENDERING FASTER!!!!!
    angles = mutate(stars,d=dec*3.14159/180,r=-(ra-(input$ang/15))*3.14159/12)
    coords = mutate(angles,projx=cos(d)*cos(r),projy=cos(d)*sin(r))
    north_coords = filter(coords,d>0,ci<2)
    north_bright = filter(north_coords, mag<input$bright[2],input$bright[1]<mag)
    
    if (input$sh_color)
      colors = rev(c("#F82800","#FFB942","#FFFFFF","#CAD6FF"))
    else
      colors = c("#FFFFFF")
    
    ggplot(data=north_bright) + 
      geom_point(mapping=aes(x=projx,y=projy,color=ci,
                             alpha=brightness(mag, input$bright[1], input$bright[2])),
                 size=input$sz*0.2, stroke=0,shape=16, show.legend=FALSE) + 
      scale_color_gradientn(colors=colors) + 
      theme(panel.background = element_rect(fill="black"), aspect.ratio=1, 
            panel.grid.major = element_line(color="#000000"), 
            panel.grid.minor=element_line(color="#000000"),
            axis.title.x=element_blank(), axis.ticks.x=element_blank(),
            axis.title.y=element_blank(), axis.ticks.y=element_blank())
  })
}

shinyApp(ui=ui, server=server)