ui <- fluidPage(
  titlePanel("Censored Regression Model Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("beta", "Beta Value:", min = -3, max = 3, value = 0, step = 0.1),
      sliderInput("threshold", "Censoring Threshold:", min = -3, max = 3, value = 3, step = 0.1),
      radioButtons("censoring_type", "Censoring Type:", choices = c("Below" = "below", "Above" = "above"), selected = "above")
    ),
    
    mainPanel(
      fluidRow(
        column(6, plotOutput("scatterPlot")),
        column(6, plotOutput("cdfPlot"))
      )
    )
  )
)