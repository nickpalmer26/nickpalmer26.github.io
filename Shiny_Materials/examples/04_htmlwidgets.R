## Goal: Add client-side interactivity using htmlwidgets.


library(shiny)
library(tidyverse)
theme_set(theme_minimal())
data(storms)

storms <- storms %>%
  mutate(time = as.POSIXct(paste(year, month, day, hour, sep = "-"),
                           format = "%Y-%m-%d-%H"))

stormsUnique <-  storms %>%
  select(name, year) %>%
  distinct()

ui <- fluidPage(
  
  titlePanel("Storm Wind Speed"),
  
  sidebarLayout(

    sidebarPanel(
      selectInput("stormName",
                  label = "Filter by storm name: ",
                  choices = unique(stormsUnique$name), 
                  selected = stormsUnique$name[[1]])
    ),
    
    mainPanel(
      p("The plot below shows windspeed for the selected storm."),
      plotOutput("windSpeed")
    )
  )
)

server <- function(input, output, session) {
  
  output$windSpeed <- renderPlot({
    storms_filtered <- select(filter(storms, name == input$stormName),
                              time, wind)
    ggplot(storms_filtered, aes(x = time, y = wind)) +
      geom_point(shape = 1, size = 3) + 
      geom_line()
  })
  
}

shinyApp(ui, server)