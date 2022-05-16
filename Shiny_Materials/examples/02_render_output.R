## Goal: display storm name counts in a shiny app.


library(shiny)
library(tidyverse)

data(storms)

stormNames <- storms %>%
  select(name, year) %>%
  distinct() %>%
  group_by(name) %>%
  summarize(count = n()) %>%
  arrange(desc(count))


ui <- fluidPage(
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)