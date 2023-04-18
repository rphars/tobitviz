library(shiny)
library(ggplot2)
library(censReg)

# Generate synthetic data outside the server function
set.seed(42)
n <- 100
x <- runif(n, min = -2, max = 2)
fixed_beta <- 1
y <- fixed_beta * x + rnorm(n, sd = 0.5)

server <- function(input, output) {
  output$scatterPlot <- renderPlot({
    no_censored_data <- FALSE
    
    if (input$censoring_type == "below") {
      y_censored <- ifelse(y < input$threshold, input$threshold, y)
      tobit <- tryCatch(censReg(y_censored ~ x, left = input$threshold, right = Inf), error = function(e) { no_censored_data <<- TRUE; NULL })
    } else {
      y_censored <- ifelse(y > input$threshold, input$threshold, y)
      tobit <- tryCatch(censReg(y_censored ~ x, left = -Inf, right = input$threshold), error = function(e) { no_censored_data <<- TRUE; NULL })
    }
    
    if (!no_censored_data) {
      tobit_beta <- coef(tobit)["x"]
      title_text <- paste("Tobit Estimated Beta:", round(tobit_beta, 3))
    } else {
      title_text <- "No estimates available"
    }
    
    # Calculate the "True" OLS beta and censored OLS beta
    true_ols_beta <- round(coef(lm(y ~ x))["x"], 3)
    censored_ols_beta <- round(coef(lm(y_censored ~ x))["x"], 3)
    
    fitted_line <- input$beta * x
    
    p <- ggplot() +
      geom_point(aes(x = x, y = y_censored), alpha = 0.5) +
      geom_segment(aes(x = x, xend = x, y = input$threshold, yend = y_censored), data = subset(data.frame(x, y_censored), y_censored == input$threshold), linetype = "dashed", alpha = 0.5) +
      geom_line(aes(x = x, y = fitted_line), color = "blue") +
      labs(x = "Independent Variable", y = "Dependent Variable", title = paste(title_text, "\nCensored OLS Beta:", censored_ols_beta, "\nUncensored OLS Beta:", true_ols_beta)) +
      coord_cartesian(xlim = c(-4,4),ylim=c(-3,3)) +
      theme_minimal()
    
    print(p)
  })
  
  output$cdfPlot <- renderPlot({
    cdf_x <- seq(-4, 4, length.out = 100)
    if (input$censoring_type == "below") {
      cdf_y <- 1 - pnorm(input$beta * cdf_x - input$threshold)
    } else {
      cdf_y <- pnorm(input$beta * cdf_x - input$threshold)
    }
    
    # Plot the CDF
    p <- ggplot() +
      geom_line(aes(x = cdf_x, y = cdf_y), color = "red") +
      labs(x = "Independent Variable", y = "Cumulative Probability") +
      coord_cartesian(ylim = c(0,1)) +
      theme_minimal()
    
    print(p)
  })
}
