## Goal: Enable filtering by storm status.
  
library(shiny)
library(dplyr)

data(storms)
theme_set(theme_minimal())

stormNames <- storms %>%
  select(name, year, status) %>%
  distinct() %>%
  group_by(name, status) %>%
  summarize(count = n()) %>%
  arrange(desc(count))

ui <- fluidPage(
  
  selectInput("stormStatus",
              label = "Filter by storm type: ",
              choices = unique(stormNames$status)),
  
  "The plot below shows the distribution of storm name use.",
  plotOutput("nameDist")
)

server <- function(input, output, session) {
  
  output$nameDist <- renderPlot({
    
    str(input$stormStatus)
    
    ggplot(data = filter(stormNames, status == input$stormStatus)) +
        geom_histogram(aes(x = count), bins = 25) 

  },
  
  width = 400, height = 300)
  
}

shinyApp(ui, server)