library(DT)
library(shiny)
library(shinydashboard)
library(quantmod)
library(dplyr)

shinyUI(dashboardPage(skin = "purple", 
    dashboardHeader(title = "Stock Explorer"),
    dashboardSidebar(
        width=370,
        sidebarUserPanel("Stock Explorer", image = "sp.jpg"), 
        sidebarMenu(
            menuItem("Analyzer", tabName = "Analyzer", icon = icon("area-chart")),
            menuItem("Predictor", tabName = "Predictor", icon = icon("line-chart")),
            menuItem("Data", tabName = "Data", icon = icon("database"))
            
        ),
        
        selectizeInput("sectorChoice",
                       label = h5("Select Sector"),
                       sectorsChoice, 
                       selected = "Technology"),
        selectizeInput(inputId = "companiesChoice",
                       label = h5("Select Company"),
                       choices = companiesChoice,
                       selected = "ALPHABET INC."),
        dateRangeInput('dateRange',
                       label = h5('Date Range'),
                       start = "2007-01-03", end = Sys.Date()),
        
        radioButtons("Indices", label = h5("Market Index"), 
                           choices = list("None" = "None", "SP500" = "SP500", 
                                          "Dow" = "Dow", "NYA" = "NYA"), inline = TRUE, selected = "None"),
        numericInput("rsi", label = h5("RSI # of periods"), value = 0),
        checkboxInput("Logscale", label = h5("Log Scale"), value = FALSE ),
        checkboxInput("Roller", label = h5("Period Roller"), value = FALSE )
        
    
    ),
    dashboardBody(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      ),
      tabItems(
        #Analyzer tab
        tabItem(tabName = "Analyzer",
                h4(textOutput("stock_name")), 
                fluidRow(box(dygraphOutput("dygraph"), height = 500, width=12))
        ),
        
        #Predictor tab
        tabItem(tabName = "Predictor",
              h4(textOutput("stock_name2")),
              fluidRow(box(dygraphOutput("dygraph2"), height = 500, width=12))
            
        ),
        #Data tab
        tabItem(tabName = "Data",
               
                fluidRow(box(DT::dataTableOutput("table"), width=12))
        )
      )
    
      
    #DashboardBody close
    )
)
)