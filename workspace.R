library(shiny)
library(tercen)
library(dplyr)
library(tidyr)
library(pheatmap)

ui <- shinyUI(fluidPage(
  
  titlePanel("Heatmap"),
  
  sidebarPanel(
    sliderInput("plotWidth", "Plot width (px)", 200, 2000, 500),
    sliderInput("plotHeight", "Plot width (px)", 200, 2000, 1200),
    sliderInput("rowFontSize", "Row labels font size", 5, 20, 7, step = 1),
    checkboxInput("logScale", "Log scale", value = FALSE),
    "NB: for negative values, the opposite of the log transformed absolute is computed"
  ),
  
  mainPanel(
    uiOutput("reacOut")
  )
  
))

server <- shinyServer(function(input, output, session) {
  
  dataInput <- reactive({
    getValues(session)
  })
  
  output$reacOut <- renderUI({
    plotOutput(
      "heatmap",
      height = input$plotHeight,
      width = input$plotWidth
    )
  }) 
  
  output$heatmap <- renderPlot({
    values <- dataInput()
    data <- values$data
    data_wide <- as.matrix(spread(data, .ci, .y)[, -1])
    
    if(input$logScale) {
      data_wide <- sign(data_wide) * log1p(abs(data_wide))
    } 
    
    rownames(data_wide) <- values$rown
    colnames(data_wide) <- values$coln    
    pheatmap(data_wide, fontsize_row = input$rowFontSize)
    
  })
  
})

getCtx <- function(session) {
  # retreive url query parameters provided by tercen
  # query <- parseQueryString(session$clientData$url_search)
  # token <- query[["token"]]
  # taskId <- query[["taskId"]]
  # 
  # 
  # # create a Tercen context object using the token
  # ctx <- tercenCtx(taskId = taskId, authToken = token)
  # 
  
  ctx <- tercenCtx(stepId = "9b7619c7-4d66-49fa-9bb3-2b06209e58e4",
                   workflowId = "f81d245ef22a2ff192ed2533a6002ec3")
  return(ctx)
}

getValues <- function(session){
  ctx <- getCtx(session)
  values <- list()

  values$data <- ctx %>% select(.y, .ri, .ci) %>%
    group_by(.ci, .ri) %>%
    summarise(.y = mean(.y)) # take the mean of multiple values per cell
  
  values$rown <- ctx$rselect()[[1]]
  values$coln <- ctx$cselect()[[1]]
  
  if(length(values$rown) == 1) stop("Multiple rows are required to make a clustered heatmap.")
  if(length(values$coln) == 1) stop("Multiple columns are required to make a clustered heatmap.")
  
  return(values)
}

runApp(shinyApp(ui, server))  
