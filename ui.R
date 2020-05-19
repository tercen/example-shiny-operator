library(shiny)

shinyUI(fluidPage(
  titlePanel("Heatmap"),
  mainPanel(plotOutput("heatmap"))
))