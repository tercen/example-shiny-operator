library(shiny)
library(rtercen)
library(plyr)

# shiny::runApp(launch.browser=FALSE, port=5400)

shinyServer(function(input, output, session) {
    
  output$status = renderText({
    # retreive url query parameters provided by tercen
    httpQueryParameters = parseQueryString(session$clientData$url_search)
    
    # get the authentication token
    token = httpQueryParameters[["token"]]
    # get the workflow id
    workflowId = httpQueryParameters[["workflowId"]]
    # get the step id
    stepId = httpQueryParameters[["stepId"]]
    
    # create a Tercen client object using the token
    client = rtercen::TercenClient$new(authToken=token)
    client = rtercen::TercenClient$new(authToken=token, serviceUri="http://127.0.0.1:4400/service")
    
    # get the cube query defined by the workflow
    query = client$getCubeQuery(workflowId, stepId)
    # execute the query and get the data
    cube = query$execute()
    
    print (cube$sourceTable$as.data.frame())
    # compute the mean by .ids
    computed.df = ddply(cube$sourceTable$as.data.frame(), c(".ids"), summarize, mean = mean(.values))
    
    print(computed.df)
    
    # send the result to Tercen
    query$setResult(computed.df)
    # notify the user that it is done
    renderPrint({ 'done' })()
  })
 
})
  