library(shiny)
library(R.utils)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

rowPath.gen <- function(){
        # declare variables for project extent
        # Path, Row
        RP1 <- c(35, 31)
        RP2 <- c(45, 32)
        RP3 <- c(141, 212)
        RP4 <- c(141, 213)
        RP5 <- c(46, 31)
        RP6 <- c(46, 32)
        RP7 <- c(142, 212)
        RP8 <- c(142, 213)
        
        col.names <- c("Path","Row")
        RP <- rbind(RP1, RP2, RP3, RP4, RP5,RP6, RP7, RP8) 
        dRP <- tbl_df(RP)
        names(dRP) <- col.names
        
        rm(RP)
        rm(col.names)
        
        return(dRP)
        
}


shinyServer(function(input, output) {
         
        csv_name <- "scene_list"
        
        if (! file.exists( csv_name )){
                download.file("http://landsat-pds.s3.amazonaws.com/scene_list.gz", "scene_list.gz")
                gunzip("scene_list.gz")
        }
        
        dRP <- rowPath.gen()
        
        scene_list <- read_csv(csv_name)
        #View(scene_list)
        
        dS <- tbl_df(scene_list)
        rm(scene_list)
        
        
        # geographic extent
        lat_max = 42.3
        #lat_min = 39.428400000000124
        lat_min = 40
        lon_max = -121
        lon_min = -125
        
        dS$mean_lat <- ( dS$max_lat + dS$min_lat )/2.
        dS$mean_lon <- ( dS$max_lon + dS$min_lon )/2.
        
        
        
        output$table <- renderDataTable(
        iris
        )
})

# 
# output$plot1 <- renderPlot({
#         set.seed(2016-05-25)
#         number_of_points <- input$numeric
#         minD <- input$dateBegEnd[1]
#         maxD <- input$dateBegEnd[2]
#         #minY <- input$sliderY[1]
#         #maxY <- input$sliderY[2]
#         dataX <- runif(number_of_points, minX, maxX)
#         dataY <- runif(number_of_points, minY, maxY)
#         #xlab <- ifelse(input$show_xlab, "X Axis", "")
#         #ylab <- ifelse(input$show_ylab, "Y Axis", "")
#         main <- ifelse(input$show_title, "Title", "")
#         #plot(dataX, dataY, xlab = xlab, ylab = ylab, main = main,
#         #     xlim = c(-100, 100), ylim = c(-100, 100))
        