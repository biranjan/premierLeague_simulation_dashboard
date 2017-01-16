#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#install.packages("devtools")
#install.packages(c("shiny", "dplyr", "htmlwidgets", "digest", "bit"))
#devtools::install_github("rstudio/shinydashboard")
#devtools::install_github("jcheng5/bubbles")
#devtools::install_github("hadley/shinySignals")

library(shiny)
library(shinydashboard)
library(plotly)
source("fun.R")

# Define UI for application that draws a histogram
dashboardPage(
            
        skin = "purple",
    
        dashboardHeader(title = "Premier League Simulation",
                        titleWidth = 300),
              dashboardSidebar(
                  
                  tags$head(
                      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
                  
                  menuItem(strong("Pick Teams"),icon = icon("cog")),
                  selectInput("home_t",
                              "Home team:",
                              choices = c("Arsenal","Bournemouth","Burnley","Chelsea","Crystal.Palace",
                                          "Everton","Hull","Leicester","Liverpool","Man.City",      
                                          "Man.United","Middlesbrough","Southampton","Stoke",
                                          "Sunderland","Swansea","Tottenham","Watford","West.Brom",
                                          "West.Ham")),
                  selectInput("away_t",
                              "Away team:",
                              choices =c("Bournemouth","Burnley","Chelsea","Crystal.Palace",
                                         "Everton","Hull","Leicester","Liverpool","Man.City",      
                                         "Man.United","Middlesbrough","Southampton","Stoke",
                                         "Sunderland","Swansea","Tottenham","Watford","West.Brom",
                                         "West.Ham","Arsenal")),
                  fluidRow(style="float:right;right:63%;position:relative;",
                  submitButton("Confirm",icon("spinner"))
                  )
              
              ),
              dashboardBody(
                  fluidRow(box(
                      title = "Probability Pie",solidHeader = TRUE,status="primary",
                      plotlyOutput("print",height=275)
                      
                  ),
                  
                  valueBoxOutput("exp_gl1"),
                  
                  #valueBox(expectd_agoal,"Expected Away Goal", icon("soccer-ball-o"),color="green"),
                  
                  valueBoxOutput("exp_gl2"),
                  
                  valueBox(1000,"Total No. of Simulation", icon("tachometer"),color="green"),
                  
                  box(
                      title = "Goals Distribution",solidHeader = TRUE,status = "info",
                      plotOutput("graph1")
                  ),
                  
                  box(
                      title = "Goals Distribution",solidHeader = TRUE,status = "info",
                      plotOutput("graph2")
                  )
                      
                  ),
                  
                fluidRow(
                    infoBox("Last Games Updated", "1-16-2017", icon = icon("info"))
                )
              )
)
