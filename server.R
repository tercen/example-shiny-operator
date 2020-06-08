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
  
  values$data <- ctx %>% select(.y, .ri, .ci) %>%
    group_by(.ci, .ri) %>%
    summarise(.y = mean(.y)) # take the mean of multiple values per cell
  
  values$rown <- ctx$rselect()[[1]]
  values$coln <- ctx$cselect()[[1]]
  
  if(length(values$rown) == 1) stop("Multiple rows are required to make a clustered heatmap.")
  if(length(values$coln) == 1) stop("Multiple columns are required to make a clustered heatmap.")
  
  return(values)
}

