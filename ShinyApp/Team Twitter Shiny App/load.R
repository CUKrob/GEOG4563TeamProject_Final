knitr::opts_chunk$set(echo = TRUE)
options(stringsAsFactors = FALSE)
# Load all libraries required
library(devtools)
library(leaflet)
library(dplyr)
library(rgdal)
library(tidytext)
library(stringr)
library(shiny)
library(rgdal)
library(RColorBrewer)
library(raster)
library(sp)

#### This code is the processing required to create the single 10 minute twitter data csv
#### the 10 minute file was created for the shiny app to run faster and not need to run 
#### this code everytime it is loaded

# # load data - longitude and latitude already transformed
# twitter_data <- read.csv("data/twitter_31days.csv")
# twitter_data$Timestamp<-as.POSIXct(twitter_data$Timestamp)
# ## manipulate long & lat into usable form ##
# # split coordinates into two columns and remove special characters
# twitter_data$lon <- sapply(strsplit(as.character(twitter_data$Coordinates),','), "[", 1) 
# twitter_data$lon <- (sub('^\\[', '', twitter_data$lon)) %>% as.numeric(twitter_data$lon)
# twitter_data$lat <- sapply(strsplit(as.character(twitter_data$Coordinates),','), "[", 2)
# twitter_data$lat <- (sub(']$', '', twitter_data$lat))
# 
# # cast strings as num
# twitter_data$lon <-as.numeric(twitter_data$lon)
# twitter_data$lat <-as.numeric(twitter_data$lat)
# 
# twitter_data <- subset(twitter_data, 
#                        twitter_data$Timestamp >= ('2014-08-24 04:20:44') &
#                          twitter_data$Timestamp <= ('2014-09-24 04:20:43') )
# 
# # set eruption date and time
# day1 <- as.Date("2014-08-24")
# hour1 <- as.POSIXct("2014-08-24 04:20:44")
# 
# # add columns for elapsed days
# twitter_data$days <- as.numeric(difftime (as.Date(twitter_data$Timestamp), day1, units = "days"))
# twitter_data$days2 <- as.numeric(difftime(twitter_data$Timestamp, hour1, units = "days"))
# 
# # add columns for elapsed minutes
# twitter_data$minutes <- as.numeric(difftime(twitter_data$Timestamp, hour1, units = "mins"))
# twitter_data$seconds <- as.numeric(difftime(twitter_data$Timestamp, hour1, units = "secs"))
# 
# # Subset twitter data to 10 minutes post earthquake
# twitter_data_10min <- subset(twitter_data, 
#                              twitter_data$Timestamp >= ('2014-08-24 04:20:44') &
#                                twitter_data$Timestamp <= ('2014-08-24 04:30:43') )
# # clean up text and break down tweets by word
# 
# 
# replace_reg <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
# unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
# 
# tidy_tweets <- twitter_data_10min %>%
#   mutate(Text = str_replace_all(Text, replace_reg, "")) %>%
#   unnest_tokens(word, Text, token = "regex", pattern = unnest_reg) %>%
#   filter(!word %in% stop_words$word,
#          str_detect(word, "[a-z]"))
# Read in california census shapefile

# Read in 10 minute twitter data
twitter_data_10min <- read.csv("twitter_data_10min.csv")
# Read in california shapefile
CaliCen <- readOGR("CaliCensus/Cal_Cnty_RacePop.shp")

# Read in shakemap raster
shake_raster <- raster("shakemap/raster/mi.fit")
# Set the CRS of the raster file
crs(shake_raster) <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

