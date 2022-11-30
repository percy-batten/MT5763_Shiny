ui <- dashboardPage(
  # Name app
  dashboardHeader(title = "Stock Analysis App"),
  
  # Add sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Stock Charts", icon = icon("chart-line"), tabName = "stock_pick"),
      menuItem(text = "Stock Data", icon = icon("chart-line"), tabName = "stock_data"),
      
      # Allow user to input stock information
      pickerInput(
        inputId = "tickers",
        label = "Pick Stocks: ",
        choices = tickers$options,
        selected = c(),   
        options = list(`max-options` = 4,
                       `actions-box` = TRUE,
                       `live-search` = TRUE,
                       `virtual-scroll` = 10), 
        multiple = T
      ), 
      
      # Set date inputs
      dateInput(inputId = "date_beg",
                label = "Start date:",
                value = Sys.Date() - 3600,
                max = Sys.Date() - 28),  
      
      dateInput(inputId = "date_end",
                label = "End date:", 
                value = Sys.Date(), 
                min = Sys.Date() - 360),
      
      # Use button to trigger code
      actionButton(inputId = "button", label = "Generate Chart")) 
    
    ),
  
  dashboardBody(
    # Utilise nice theme
    shinyDashboardThemes(theme = "grey_dark"),
  
    tabItems(
    tabItem(tabName = "stock_pick", 
            h2("Price Charts"),
            br(),
            plotlyOutput("plotly"),
            fluidRow(box(plotOutput("plot2", height = 250)))),
    
    tabItem(tabName = "stock_data", 
            h2("Stock Data"),
            br(),
            DT::dataTableOutput("stock_data"),
            downloadButton(outputId = "download", label = "Download"))
    )
  )
)

