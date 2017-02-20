library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Tercen shiny operator"),
 
  mainPanel(
    textOutput("status")
  )
))
