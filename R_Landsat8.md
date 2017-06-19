Landsat 8 - Scene Lookup
========================================================
author: Daryl Van Dyke
date: 2017-06-19        
autosize: true

Purpose
========================================================

This project allows the dynamic query of Landsat 8 data scenes.

- The list is *live* - it updates itself when run.
- The scene list includes a date range filter, as well as
- a filter for cloud cover (max and min).

The Main Stick
========================================================


```r
#install.packages("R.utils")
library(R.utils)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
```

========================================================


```r
summary( dS[,1:4] )
```

```
   entityId         acquisitionDate                 cloudCover    
 Length:1059757     Min.   :2013-04-11 00:14:45   Min.   : -1.00  
 Class :character   1st Qu.:2014-07-24 13:40:56   1st Qu.:  4.37  
 Mode  :character   Median :2015-06-16 18:40:24   Median : 25.69  
                    Mean   :2015-06-03 08:58:29   Mean   : 34.20  
                    3rd Qu.:2016-05-12 22:13:20   3rd Qu.: 62.13  
                    Max.   :2017-05-01 08:14:12   Max.   :100.00  
 processingLevel   
 Length:1059757    
 Class :character  
 Mode  :character  
                   
                   
                   
```

My Hyperlinks!
========================================================

The Github Location:
https://github.com/GeospatialDaryl/5030_R_Landsat

The Shiny App on Shinyapps.io
https://geospatialdaryl.shinyapps.io/5030_R_Landsat/

