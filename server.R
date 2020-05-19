library(shiny)
library(tercen)
library(dplyr)
library(tidyr)

shinyServer(function(input, output, session) {
  
  dataInput = reactive({getValues(session)})
  
  output$heatmap <- renderPlot({
    
    data <- dataInput()
    data_wide <- spread(data, .ci, .y)[, -1]

    heatmap(as.matrix(data_wide))
    
  })

})



getCtx = function(session){
  # retreive url query parameters provided by tercen
  query = parseQueryString(session$clientData$url_search)
  token = query[["token"]]
  taskId = query[["taskId"]]

  # create a Tercen context object using the token
  ctx = tercenCtx(taskId = taskId, authToken = token)
  
  # ctx = tercenCtx(workflowId = "3b732c1081004d8ad810464ee10076d9", stepId =  "0d5c2e44-ad52-4382-b60c-f745382bd47c")
  
  return(ctx)
}

getValues = function(session){
  ctx = getCtx(session)
  data = ctx %>% select(.y , .ci , .ri)
  return(data)
}