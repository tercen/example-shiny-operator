library(shiny)
library(tercen)
library(dplyr)
library(tidyr)
library(pheatmap)

shinyServer(function(input, output, session) {
  
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
    data <- dataInput()
    data_wide <- as.matrix(spread(data, .ci, .y)[, -1])
    
    rownames(data_wide) <- ctx$rselect()[[1]]
    colnames(data_wide) <-  ctx$cselect()[[1]]    
    pheatmap(data_wide, fontsize_row = input$rowFontSize)
    
  })
  
})

getCtx <- function(session){
  # retreive url query parameters provided by tercen
  query <- parseQueryString(session$clientData$url_search)
  token <- query[["token"]]
  taskId <- query[["taskId"]]
  
  # create a Tercen context object using the token
  ctx <- tercenCtx(taskId = taskId, authToken = token)
  return(ctx)
}

getValues <- function(session){
  ctx <- getCtx(session)
  data <- ctx %>% select(.y , .ri, .ci)
  return(data)
}
