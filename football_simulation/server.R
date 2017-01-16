#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

library(dplyr)
library(ggplot2)
library(plotly)
source("fun.R")
 # loads the required functions
# loading the data 

# Regression model (Poisson to be precise)





# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
  output$print <- renderPlotly({
    
    # generate bins based on input$bins from ui.R
    #game_result(input$home_t,input$away_t)
        c <- list(input$home_t,input$away_t)
      do.call(game_result,c )
      plot_pie
  })
  
  output$graph1 <- renderPlot({
      do.call(game_result,list(input$home_t,input$away_t) )
      final_graph1 
  })
  
  output$graph2 <- renderPlot({
      do.call(game_result,list(input$home_t,input$away_t) )
      final_graph2 
  })
  
  output$exp_gl1 <- renderValueBox({
      do.call(game_result,list(input$home_t,input$away_t) )
      valueBox(expectd_hgoal,"Expected home goal",icon("soccer-ball-o"),color="red") 
  })
  
  output$exp_gl2 <- renderValueBox({
      do.call(game_result,list(input$home_t,input$away_t) )
      valueBox(expectd_agoal,"Expected away goal",icon("soccer-ball-o"),color="blue") 
  })
  
})


