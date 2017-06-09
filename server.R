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
        
        ###   Filtering Functions

        filter.Row <- function(inDS){
                dim(dRP)[1] -> nRows
                outDS <- inDS[0,]
                for( i in 1:nRows ){
                        DS <- inDS
                        thisRow = dRP[[i,1]]
                        #thisPath = dRP[[i,2]]
                        DS %>%
                                filter(row == thisRow) -> thisDS
                        rbind(outDS, thisDS) -> outDS
                        
                }        
                return(outDS)
                
        }
        
        
        filter.Path <- function(inDS){
                outDS <- inDS[0, ]
                vPaths <- distinct(dRP[,2])
                
                nRows <- dim(vPaths)[1]
                
                for( i in 1:nRows ){
                        DS <- inDS
                        print(outDS)
                        thisPath = dRP[[i,2]]
                        #print(vPaths)
                        #thisPath = vPaths[i]
                        print(thisPath)
                        DS %>%
                                filter(thisPath %in% path) -> thisDS
                        rbind(outDS, thisDS) -> outDS
                }        
                return(outDS)
                
        }

        
        filter.LatLon <- function(inDS, lon_min, lon_max, lat_min, lat_max ){
                inDS %>% 
                        filter(mean_lat < lat_max) %>%
                        filter(mean_lat > lat_min) %>%
                        filter(mean_lon < lon_max) %>%
                        filter(mean_lon > lon_min) -> outDS
                return(outDS)
        }
        
        
        filter.Cloud.H <- function(inDS, cloudCutoffH ){
                inDS %>%
                        filter(cloudCover < cloudCutoffH) -> outDS
                return(outDS)
        }
        
        filter.Cloud.L <- function(inDS, cloudCutoffL ){
                #inDS1 %>%
                #        filter(dS$cloudCover > cloudCutoffL) -> outDS
                
                filter(inDS, cloudCover > as.double(cloudCutoffL)) -> outDS
                return(outDS)
        }
        
        
        filter.StartDate <- function(inDS, startDate){
                inDS %>%
                        filter(acquisitionDate > ymd(startDate)) -> outDS
                return(outDS)
                
        }
        
        filter.EndDate <- function(inDS, endDate){
                inDS %>%
                        filter(acquisitionDate < ymd(endDate)) -> outDS
                return(outDS)
        }
        
        ###  prepare table for ouput

        
        output$table <- renderDataTable({
                # UI Inputs
                startD <- input$dateBegEnd[1]
                endD   <- input$dateBegEnd[2]
                ccLow  <- as.double(input$pcCC[1])
                ccHi   <- as.double(input$pcCC[2])
                rpFilt  <- input$rpF

                # table logic
                dOut <- dS
                dOut <- filter.StartDate(dOut, startD )
                dOut <- filter.EndDate(dOut, endD)
                dOut <- filter.Cloud.L(dOut, ccLow)
                dOut <- filter.Cloud.H(dOut, ccHi)
                if(rpFilt){ 
                        dOut <- filter.Row(dOut)
                }
                
                dOut
                
        }, options = list(pageLength = 12)
        )
})

