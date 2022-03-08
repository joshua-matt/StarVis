library(shiny)
library(tidyverse)
library(grid)
# 
# stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
# # dists = filter(stars, dist < 25000)
# # far = filter(stars,dist > 25000)
# # bright = filter(dists,absmag < 1)
# # dim = filter(dists,absmag>1)
# #
# # sidebarLayout(
# #   sidebarPanel(
# #     sliderInput("ang", label="Polar Rotation", min=-180,max=180,value=0),
# #     sliderInput("sz", label="Star Size", min=1, max=10,value=3),
# #     sliderInput("bright", label="Brightness Threshold", min=-2, max=10, step=0.5, value=c(-2,5), dragRange=TRUE),
# #     checkboxInput("sh_color", label="Show star color", value=TRUE),
# #     checkboxInput("eq_bright", label="Equalize brightness", value=FALSE)),
# #
# #   mainPanel()#plotOutput("map"))
# # )
# 
# ui = fluidPage(
#   fluidRow(
#     # column(4,
#     #        wellPanel(
#     #          tabsetPanel(
#     #            tabPanel("Filters",
#     #                     br(),
#     #                     sliderInput("bright", label="Brightness Threshold", min=-2, max=10, step=0.5, value=c(-2,5), dragRange=TRUE)),
#     #            tabPanel("Visual",
#     #                     br(),
#     #                     sliderInput("ang", label="Polar Rotation", min=-180,max=180,value=0),
#     #                     sliderInput("sz", label="Star Size", min=1, max=10,value=3),
#     #                     checkboxInput("sh_color", label="Show star color", value=TRUE),
#     #                     checkboxInput("eq_bright", label="Equalize brightness", value=FALSE))
#     #          )
#     #        )),
#     column(12,
#            plotOutput("map")))
# )
# 
stars = read.csv("C:/Users/divin/OneDrive/Documents/School/21-22/Spring/324/Individual Project/hyg_original.csv")
# #select(stars,ra,dec)
# angles = mutate(stars,d=dec*3.14159/180,r=-ra*3.14159/12)
# coords = mutate(angles,projx=cos(d)*cos(r),projy=cos(d)*sin(r))
# north_coords = filter(coords,d>0,ci<2)
# south_coords = filter(coords,d<=0,ci<2)
# 
# north_bright = filter(north_coords, mag<5,-2<mag)
# south_bright = filter(south_coords, mag<5, -1<mag)
# 
# ## TODO FEATURES
# # Choose location of north pole
# # More brightness options (Apparent Magnitude, Absolute Magnitude, Equal brightness)
# # X Remove tick marks
# # Make plot bigger
# # Speed up rendering (find which parts of rendering/processing are slowest)
# # Snazzier color scheme
# # Information about visualization
# # Color saturation slider (rather than 0-1)
# # More attractive/flexible layout
# 
# 

# Make plot fill container: https://stackoverflow.com/questions/40538365/r-shiny-how-to-get-square-plot-to-use-full-width-of-panel
# Remove plot margins: https://stackoverflow.com/questions/31254533/when-using-ggplot-in-r-how-do-i-remove-margins-surrounding-the-plot-area
server = function(input,output) {
  
  brightness <- function(mag, min, max, b0=0.1) {
    if (input$eq_bright)
      return(1)
    return((1-b0)*mag/(min-max)+b0)
  }
  
  output$map <- renderPlot({
    angles = mutate(stars,d=dec*3.14159/180,r=-(ra-(input$ang/15))*3.14159/12)
    coords = mutate(angles,projx=cos(d)*cos(r),projy=cos(d)*sin(r))
    north_coords = filter(coords,d>0,ci<2)
    #north_coords = filter(coords,d<0,ci<2)
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
            axis.title=element_blank(), axis.ticks=element_blank(), axis.text=element_blank(),
            plot.margin = margin(t=0,r=0,b=0,l=0), plot.background = element_rect(fill="black")) +
      coord_cartesian(ylim=c(-1,1),xlim=c(-1,1))
  } ,
  height=reactive(ifelse(!is.null(input$innerWidth),input$innerWidth*3/5,1))
  )
}

ui <- fillPage(
  tags$head(tags$script('$(document).on("shiny:connected", function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            $(window).resize(function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            ')),
  fillRow(flex=c(2,3),
          div(style="height:100%;width:100%;background-color:white;",
              wellPanel(
                tabsetPanel(
                  
                  tabPanel("", icon=icon("filter"),
                           br(),
                           sliderInput("bright", label="Brightness Threshold", min=-2, max=10, step=0.5, value=c(-2,5), dragRange=TRUE)),
                  tabPanel("", icon=icon("map"),
                           br(),
                           sliderInput("ang", label="Polar Rotation", min=-180,max=180,value=0)),
                  tabPanel("", icon=icon("eye"),
                           br(),
                           
                           sliderInput("sz", label="Star Size", min=1, max=10,value=3),
                           checkboxInput("sh_color", label="Show star color", value=TRUE),
                           checkboxInput("eq_bright", label="Equalize brightness", value=FALSE))
                ))),
          div(style="height:100%;width:100%;background-color:black;", plotOutput("map"))
  )
)

shinyApp(ui=ui, server=server)