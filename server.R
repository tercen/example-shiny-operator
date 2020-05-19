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
    values <- dataInput()
    data <- values$data
    data_wide <- as.matrix(spread(data, .ci, .y)[, -1])
    
    rownames(data_wide) <- values$rown
    colnames(data_wide) <- values$coln    
    pheatmap(data_wide, fontsize_row = input$rowFontSize)
    
  })
  
})

getCtx <- function(session) {
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
  values <- list()

  values$data <- ctx %>% select(.y , .ri, .ci)
  values$rown <- ctx$rselect()[[1]]
  values$coln <- ctx$cselect()[[1]]
  
  return(values)
}
