# Tobitviz

Tobitviz is a Shiny application that allows you to play around with censoring. It generates data with a (population) B=1, and shows what happens to this beta when data is censored.
This application also shows the two components of the tobit model, i.e. a plot with the uncensored data points, and the cdf for the censored data points.

## Run

To run this Shiny app locally, install the following R packages first:

```r
install.packages(c("shiny", "ggplot2","censReg"))
```

then use:

```r
shiny::runGitHub("rphars/tobitviz")
```