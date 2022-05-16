## Goal: Enable filtering by storm status.
  
library(shiny)
library(tidyverse)

theme_set(theme_minimal())

Danl310FinalData <- read_csv("https://nickpalmer26.github.io/Danl310FinalData.csv")

ui <- fluidPage(
  
  selectInput("City",
              label = "Distribution of List Price by City",
              choices = unique(Danl310FinalData$City)),
  
  "The plot below shows the distribution of prices.",
  plotOutput("nameDist")
)

server <- function(input, output, session) {
  
  output$nameDist <- renderPlot({
    
    
    ggplot(data = filter(Danl310FinalData, City == input$City)) +
        geom_histogram(aes(x = `List Price`), bins = 25) 

  },
  
  width = 400, height = 300)
  
}

shinyApp(ui, server)

