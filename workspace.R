source("ui.R")
source("server.R")

options("tercen.workflowId"= "a2655956732b211c80ed41bb20003816")
options("tercen.stepId"= "7dbeae29-fd27-4d2c-a7ae-4c1ed871b850")

runApp(shinyApp(ui, server))  
