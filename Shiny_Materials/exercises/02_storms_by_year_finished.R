
## Exercise 2: Display number of storms by year.

## 1. Add a table output element to the ui and a corresponding renderer to the server.
##    The table should display the number of named storms in each year.

## 2. Add a plot output element to the ui, and a corresponding renderer to the server.
##    The plot should display the number of named storms in each year.


library(shiny)
library(tidyverse)

data(storms)
storms_by_year <- storms %>%
  group_by(year) %>%
  summarize(n = n_distinct(name))

ui <- fluidPage(
  
  tableOutput("byYearTable"),
  
  plotOutput("byYearPlot")
  
  )

server <- function(input, output, session) {
  
  output$byYearTable <- renderTable({
    storms_by_year
  })
  
  output$byYearPlot <- renderPlot({
    ggplot(data = storms_by_year) +
      geom_line(aes(x = year, y = n)) +
      theme_minimal()
  })
  
}

shinyApp(ui, server)