rm(list = ls())

library(funModeling) #analysis for plot and stats
library(rvest) #scraping

#Scraper

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

df <- data.frame(Counties=counties_list, Positive=positive_data, Recoveries=recovery_data, Deaths=death_data)
df[is.na(df)] = 0
df <- df[-76,]
write.csv(df, paste0('C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data Sheets/Scrapes/Scrape_', as.numeric(format(as.Date(Sys.Date()), '%Y%m%d')), '.csv'))
write.csv(df, paste0('C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/BadBoyShinyApp/Data For Shiny/Files/Scrape_', as.numeric(format(as.Date(Sys.Date()), '%Y%m%d')), '.csv'))
write.csv(df, 'C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data Sheets/ASSIGNDATE.csv dump/ASSIGNDATE.csv')

main_data <- read.csv('C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data Sheets/ASSIGNDATE.csv dump/ASSIGNDATE.csv')
pop_data <- read.csv('C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Proof_Of_Concept/Early Analysis/Population Data.csv')
data <- merge(main_data, pop_data, by = "Counties")

data <- subset(data, select= -X)

df_status(data)

#Analysis

infectionrate <- (data$Positive/data$Population..2010.)

recoveryrate <- (data$Recoveries/data$Positive)

mortalityrate <- (data$Deaths/data$Positive)

data$Infection_Rate <- infectionrate

data$Recovery_Rate <- recoveryrate

data$Mortality_Rate <- mortalityrate

active_cases <- (data$Positive - (data$Recoveries + data$Deaths))

data$Active_Cases <- active_cases

data[is.na(data)] = 0

df2.0 <- (data)
write.csv(df2.0, paste0('C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data Sheets/Scrapes Complete Rates/Rates_', as.numeric(format(as.Date(Sys.Date()), '%Y%m%d')), '.csv'))

#EDA

pn <- profiling_num(data)
write.csv(pn, paste0('C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data Sheets/Profiles/Profile_', as.numeric(format(as.Date(Sys.Date()), '%Y%m%d')), '.csv'))

plot_num(data, path_out = "C://Users/Nathan May/Desktop/Research Files (ABI)/Covid/Data Sheets/Plots/ASSIGNDATE v3")
