library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Heatmap"),
  
  sidebarPanel(
    sliderInput("plotWidth", "Plot width (px)", 200, 2000, 500),
    sliderInput("plotHeight", "Plot width (px)", 200, 2000, 1200),
    sliderInput("rowFontSize", "Row labels font size", 5, 20, 7, step = 1)
  ),
  
  mainPanel(
    uiOutput("reacOut")
  )
  
))