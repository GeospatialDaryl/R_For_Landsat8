#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
        
        # Application title
        headerPanel("Shiny Text"),
        
        # Sidebar with controls to select a dataset and specify the number
        # of observations to view
        sidebarPanel(
                selectInput("dataset", "Choose a dataset:", 
                            choices = c("rock", "pressure", "cars")),
                
                numericInput("obs", "Number of observations to view:", 10)
        ),
        
        # Show a summary of the dataset and an HTML table with the requested
        # number of observations
        mainPanel(
                verbatimTextOutput("summary"),
                
                tableOutput("view")
        )
))

library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
        
        # Return the requested dataset
        datasetInput <- reactive({
                switch(input$dataset,
                       "rock" = rock,
                       "pressure" = pressure,
                       "cars" = cars)
        })
        
        # Generate a summary of the dataset
        output$summary <- renderPrint({
                dataset <- datasetInput()
                summary(dataset)
        })
        
        # Show the first "n" observations
        output$view <- renderTable({
                head(datasetInput(), n = input$obs)
        })
})

shinyApp(ui = shinyUI, server = shinyServer)

