#install.packages("R.utils")
library(R.utils)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

download.file("http://landsat-pds.s3.amazonaws.com/scene_list.gz", "scene_list.gz")
gunzip("scene_list.gz")

scene_list <- read_csv("X:/_02_Repos/Repos/5030_R_Landsat/scene_list")
#View(scene_list)

dS <- tbl_df(scene_list)
rm(scene_list)

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

# geographic extent
lat_max = 42.3
#lat_min = 39.428400000000124
lat_min = 40
lon_max = -121
lon_min = -125

dS$mean_lat <- ( dS$max_lat + dS$min_lat )/2.
dS$mean_lon <- ( dS$max_lon + dS$min_lon )/2.


filter.RowPath <- function(inPath, inRow){
        dim(dRP)[1] -> nRows
        for( i in 1:nRows ){
                thisRow = dRP[[i,1]]
                thisCol = dRP[[i,2]]
                #print( c(thisRow,thisCol))
                print(filter(dS, dS$row == thisRow))
                
        }
}

filter.LatLon <- function(inDS, lon_min, lon_max, lat_min, lat_max ){
        inDS %>% 
                filter(mean_lat < lat_max) %>%
                filter(mean_lat > lat_min) %>%
                filter(mean_lon < lon_max) %>%
                filter(mean_lon > lon_min)
}

filter.Cloud <- function(inDS, cloudCutoff ){
        inDS %>%
                filter(CloudCover < cloudCutoff)
}

