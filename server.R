server <- function(input, output) {
  
  # Load in Stock tickers
  NYSE <- read.delim("data/NYSE.txt", stringsAsFactors = FALSE)
  NASDAQ <- read.delim("data/NASDAQ.txt", stringsAsFactors = FALSE)
  LSE <- read.delim("data/LSE.txt", stringsAsFactors = FALSE)
  
  # Combine into one list
  tickers <- rbind(NASDAQ, NYSE, LSE)
  
  # Remove duplicants
  tickers <- distinct(tickers)
  
  # Create new nice column for choices
  tickers$options = paste0(tickers$Symbol, "-", tickers$Description)
  
  # React to button being pressed
  observeEvent(input$button, {
    
    # Prepare chosen data
    ticker_clean <- input$tickers
    stocke <- NULL
    
    # Take out ticker symbols and assign to stocke
    for (i in 1:length(ticker_clean)) {
      stocke[i] <- unlist(strsplit(ticker_clean[i], "-"))[1]  
    }
    
    # Assign price data
    stock_data <- tq_get(stocke[1], get = "stock.prices", from = input$date_beg, to = input$date_end)
    
    # Plot chart
    output$plot2 <- renderPlot ({
      ggplot(stock_data, aes(x = date, y = close)) +
        geom_line() +
        labs(title = paste(stocke[1], "Line Chart"), y = "Closing Price", x = "") + 
        theme_tq()})
    
    # Plot Interactive candlestick chart
    output$plotly <- renderPlotly( 
      plot_ly(data = stock_data, 
            x = stock_data$date, 
            type = "candlestick", 
            open = stock_data$open, 
            close = stock_data$close, 
            high = stock_data$high, 
            low = stock_data$low))
    
    # Create data table for selected stocks
    output$stock_data <- DT::renderDataTable({
      
      if(!is.null(stock_data)) {
        DT::datatable(stock_data,rownames = FALSE, options = list(pageLength = 50, order = list(list(0, 'desc'))))
      }
    })
    
    # Allow selected stock data to be downloaded
    output$download <- downloadHandler( 
      filename = function() {"stock_data.csv"},
      content = function(file) {
        write.csv(stock_data, file)
      })
  })
}


