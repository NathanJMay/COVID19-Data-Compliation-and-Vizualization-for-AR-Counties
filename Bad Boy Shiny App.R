library(shiny)
library(dplyr)
library(tidyr)
library(plotly)
library(ggplot2)
library(rsconnect)

rm(list=ls())

#LOAD AND STRUCTURE DATA FRAMES

data <- read.csv("C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/BadBoyShinyApp/Data For Shiny/Appended_File/Appended_Scraped_Files.csv")
data <- transform(data, Day = as.Date(as.character(Day), "%Y%m%d"))
str(data$Day)
datapos <- data[,c(2,3,6)]
datarec <- data[,c(2,4,6)]
datadea <- data[,c(2,5,6)]  

rsconnect::setAccountInfo(name='nathanjmay', token='A3CF4CC3DE0112B8B9F8D0BA429223D3', secret='TNwC9hxwZt+BffOhFaXD3FQsMg3eQnfaPGr0eE8S')

#UI

ui <- fluidPage(
titlePanel("COVID-19 in Arkansas Counties"),
  fluidRow("This Application is designed to show cumulative COVID-19 data organized by counties in the State of Arkansas.
           Data is web-scraped from the Arkansas Department of Health Website daily, processed, and the dataframe this app
           uses is updated. NOTE: THE FIRST THREE GRAPHS ARE DATA FROM THE COUNTY SELECTED IN THE DROPDOWN MENU BELOW. THE
           LAST THREE GRAPHS ARE STATEWIDE."
           ),  #INSTRUCTIONS
  fluidRow(
    column(
      width=4,
      selectizeInput("Counties", label = h5 ("Select a County"), choices = data$Counties, width="100%")    #DROPDOWN MENU
    )
    ),                                                                         #
  sidebarPanel(
    h4("Current Number of Active Cases in Selected County", align = "left"),
    textOutput(outputId = "Currentnum")
    ),
  fluidRow(
    plotOutput(outputId = "Positive")           #OUTPUTS
  ),
  fluidRow(
    plotOutput(outputId = "Recoveries")
  ),
  fluidRow(
    plotOutput(outputId = "Deaths")
  ),
  fluidRow("This application is presented by the Arkansas Biosciences Institute at Arkansas State University.
           Progammed by Nathan May and supervised by Dr. Sudeepa Bhattachraryya."),
  fluidRow((img(src = "C:/Users/Nathan May/Desktop/Research Files (ABI)/Covid/BadBoyShinyApp/abi-logo.jpg")))    #CREDITS
)

  
#SERVER

server= function(input, output, session) {
  
  #FILTERS COUNTY NAMES FOR DROPDOWN MENU
  data <- reactive({
    data %>% filter(County == input$Counties)
  })
  
  #POSITIVE PLOT
  output$Positive <- renderPlot(ggplot(data = datapos, aes(x = Day, y = Positive)) + 
                                  geom_col(fill = "dodgerblue2") + 
                                  labs(title = "Cumulative State-Wide Positive Cases") +
                                  theme(plot.title = element_text(color = "dodgerblue2", size = 20, face = "bold"))
                                  )
  #RECOVERIES PLOT
  output$Recoveries <- renderPlot(ggplot(data = datarec, aes(x = Day, y = Recoveries)) +
                                  geom_col(fill = "mediumaquamarine") +
                                  labs(title = "Cumuative State-Wide Recoveries") +
                                  theme(plot.title = element_text(color = "mediumaquamarine", size = 20, face = "bold"))
                                  )
  #DEATHS PLOT
  output$Deaths <- renderPlot(ggplot(data = datadea, aes(x = Day, y = Deaths)) + 
                                  geom_col(fill = "lightcoral") + 
                                  labs(title = "Cumulative State-Wide Deaths") +
                                  theme(plot.title = element_text(color = "lightcoral", size = 20, face = "bold"))
                                  )

  #area to calculate and display currentnum
  
  
  #output$Currentnum <- (data$Positive - (data$Recoveries + data$Deaths))
    
  
  
  } 


shinyApp(ui = ui, server = server)