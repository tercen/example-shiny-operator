# Shiny app

A simple histrogram using rtercen client.

```R
library(shiny)
library(rtercen)
 
# devtools::install_github("tercen/rtercen")
  
shinyServer(function(input, output, session) {
  
  dataInput = reactive({getValues(session)})

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- dataInput()
  
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})

getValues = function(session){
  # retreive url query parameters provided by tercen
  query = parseQueryString(session$clientData$url_search)
  
  token = query[["token"]]
  workflowId = query[["workflowId"]]
  stepId = query[["stepId"]]
  
  # create a Tercen client object using the token
  client = rtercen::TercenClient$new(authToken=token)
  # get the cube query defined by your workflow
  query = client$getCubeQuery(workflowId, stepId)
  # execute the query and get the data
  cube = query$execute()
  
  x = cube$sourceTable$getColumn("values")$getValues()$getData()
  return(x)
}

```

# Deployment
## shinyapps.io

Visit https://www.shinyapps.io/

## tercen.com

[Next to come](https://tercen.com) ...

## How to link a shiny app into a Tercen workflow ?

An External View step can be used.





