library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Box Plot"),
  mainPanel(plotOutput("distPlot"))
)
)