library(shiny)
library(lubridate)
library(sys)

today <- ymd( Sys.Date() )

shinyUI(fluidPage(
        
        titlePanel("LandSat8 Scenes"),
        sidebarLayout(
                
                sidebarPanel(
                        
                        
                        
                        numericInput("numeric", "How Many Random Numbers Should be Plotted?", 
                                     value = 1000, min = 1, max = 1000, step = 1),
                        dateRangeInput("dateBegEnd", "Beginning and Ending Dates",
                                       start = ymd("2017-01-01"),
                                       end = today,
                                       min = ymd("1980-01-01"),
                                       max = today,
                                       format = "yyyy-mm-dd",
                                       startview = "month")
                        
                        #sliderInput("sliderX", "Pick Minimum and Maximum X Values",
                        #            -100, 100, value = c(-50, 50)),
                        #sliderInput("sliderY", "Pick Minimum and Maximum Y Values",
                        #            -100, 100, value = c(-50, 50))
                        #checkboxInput("show_xlab", "Show/Hide X Axis Label", value = TRUE),
                        #checkboxInput("show_ylab", "Show/Hide Y Axis Label", value = TRUE),
                        #checkboxInput("show_title", "Show/Hide Title")
                ),
                mainPanel(
                        h3("Graph of Random Points")
                        #plotOutput("plot1")
                )
        )
))