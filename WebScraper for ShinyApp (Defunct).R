rm(list=ls())

library(tidyverse)
library(funModeling)
library(Hmisc)
library(rvest)
library(ggplot2)

url <- 'https://www.healthy.arkansas.gov/programs-services/topics/covid-19-county-data'

webpage <- read_html(url)

counties_list_html <- html_nodes(webpage,'tr+ tr td:nth-child(1) p')
counties_list <- html_text(counties_list_html)
counties_list <- as.character(counties_list)

positive_data_html <- html_nodes(webpage,'tr+ tr td:nth-child(2) p')
positive_data <- html_text(positive_data_html)
positive_data <- as.numeric(positive_data)

recoveries_data_html <- html_nodes(webpage,'tr+ tr td:nth-child(3) p')
recovery_data <- html_text(recoveries_data_html)
recovery_data <- as.numeric(recovery_data)

deaths_data_html<- html_nodes(webpage,'tr+ tr td:nth-child(4) p')
death_data <- html_text(deaths_data_html)
death_data <- as.numeric(death_data)

#POSITIVE FILE

positive <- data.frame(Counties= counties_list, "06/12/2020"= positive_data)
positive[is.na(positive)]= 0
positive = positive[-c(76),]
write.csv(positive, "C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Positive/Positive Data.csv")

#RECOVERY FILE

recovery <- data.frame(Counties= counties_list, "06/12/2020"= recovery_data)
recovery[is.na(recovery)]= 0
recovery = recovery[-c(76),]
write.csv(recovery, "C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Recoveries/Recovery_Data.csv")

#DEATH FILE

deaths <- data.frame(Counties= counties_list, "06/12/2020"= death_data)
deaths[is.na(deaths)]= 0
deaths = deaths[-c(76),]
write.csv(deaths, "C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Deaths/Death_Data.csv")

#UPDATING

#POSITIVE

datap <- read.csv("C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Positive/Positive Data.csv")
positive_data = positive_data[-c(76),]
datap$DATE <- positive_data

dataold <- read.csv("C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Positive/Positive Data.csv")
testdata <- read.csv("C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Positive/TestPositive Data.csv")
datatestp <- merge(dataold[,-1], testdata[,-1], by.x = "Counties", by.y= "Counties", all = TRUE)
datatestp #WIP

#RECOVERIES

datar <-read.csv("C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Recoveries/Recovery_Data.csv")
recovery_data = recovery_data[-c(76),]
datar$DATE <- recovery_data


#DEATHS

datad <- read.csv("C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data For Shiny/Deaths/Death_Data.csv")
death_data = death_data[-c(76),]
datad$DATE <- death_data

