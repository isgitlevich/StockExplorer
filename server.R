library(DT)
library(shiny)
library(quantmod)


shinyServer(function(input, output, session){
  
  observe({
    companies_subset <- unique(fortune[fortune$sector == input$sectorChoice, ]$company)
    updateSelectizeInput(
      session, "companiesChoice",
      choices = companies_subset,
      selected = companies_subset[1])
  })
  
  ind <- reactive ({
    switch(input$Indices,  
           None = "None",
           SP500 = "SP500",
           Dow = "Dow",
           NYA = "NYA"
             )
  })
  
  sym <- reactive({ 
    sym = fortune[fortune$company == input$companiesChoice, ]$symbol
    getSymbols(sym)
    get(eval(sym))
    
    
    })
  
  dateRange <- reactive({
    
    input$dateRange
    })
   
  rsinum <- reactive({
    
    input$rsi
  })
  

  output$stock_name <- renderText({  
    s = fortune[fortune$company == input$companiesChoice, ]$symbol
    paste("Symbol: ", s)
    })
  
  output$stock_name2 <- renderText({  
    s = fortune[fortune$company == input$companiesChoice, ]$symbol
    paste("Symbol: ", s)
  })

  output$dygraph <- renderDygraph({ 
    
    stock <- sym()[,1:4 ]
    stock_ind <- cbind(stock, Cl(DJI), Cl(GSPC), Cl(NYA))
    names(stock_ind) <- c("Open", "High", "Low", "Close", "SP500", "Dow", "NYSE")
    
    #Prepare graphs based on Market Index radio buttons
    basic <- stock_ind[,1:4] %>% dygraph(main = "Stock Performance" ) %>%
      dyOptions(colors = RColorBrewer::brewer.pal(5, "Set1"))
    sp500 <-stock_ind[,c(4,5)] %>% dygraph(main = "Stock Performance vs. SP500" ) %>% 
      dySeries("SP500", axis="y2") %>% dyOptions(colors = c("red", "blue"))
    dow <- stock_ind[,c(4,6)] %>% dygraph(main = "Stock Performance vs. Dow Jones" ) %>% 
      dySeries("Dow", axis="y2")  %>% dyOptions(colors = c("red", "darkgrey"))
    nya <- stock_ind[,c(4,7)] %>% dygraph(main = "Stock Performance vs. NYSE Composite" ) %>% 
      dySeries("NYSE", axis="y2")  %>% dyOptions(colors = c("red", "green"))

    
    radio_selected <- switch(ind(),  
           None = basic,
           SP500 = sp500,
           Dow = dow,
           NYA = nya
           
           )
    
    if (rsinum() != 0) {
      radio_selected <- cbind(stock_ind[,4], RSI(stock_ind[,4], rsinum())) %>% 
        dygraph(main = "Stock Performance vs. EMA" ) %>% 
        dySeries("EMA", axis="y2")  %>% dyOptions(colors = c("red", "black"))
    }
    
    
    radio_selected <- radio_selected %>% 
      dyRangeSelector(dateWindow= dateRange(), height = 20, strokeColor = "") %>%
      dyOptions(logscale=input$Logscale, stackedGraph = TRUE, animatedZooms=TRUE, digitsAfterDecimal =2)
    
    if (input$Roller) {
      radio_selected <- radio_selected %>% dyRoller()
    }
    
    
    
    
    radio_selected 

  })

  
  output$dygraph2 <- renderDygraph({ 
    
    stock <- sym()[,1:4 ]
    stock_ind <- cbind(stock, Cl(DJI), Cl(GSPC), Cl(NYA))
    names(stock_ind) <- c("Open", "High", "Low", "Close", "SP500", "Dow", "NYSE")
    
    #Prepare graphs based on Market Index radio buttons
    basic <- stock_ind[,1:4] %>% dygraph(main = "Stock Performance" ) %>%
      dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1"))
    basic
  })
  
  
  
  output$table <- DT::renderDataTable({
    datatable(fortune[fortune$sector == input$sectorChoice,], rownames=FALSE)

  })

})