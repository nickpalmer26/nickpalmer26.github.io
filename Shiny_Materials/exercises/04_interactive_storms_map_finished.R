
## Exercise 5: Interactive Storms Map

## 1. Run the app and click on the blue markers. Examine the output in 
##    the console to determin the input corresponding to the row number 
###   of the clicked observation.

## 2. Use the slice function to select the row corresponding
##    to the clicked marker from the storms data frame and return
##    this row to the stormDetails output on line 65.


library(shiny)
library(dplyr)
library(leaflet)
library(DT)

data(storms)
storms <- storms %>% 
  mutate(ID = 1:nrow(storms))

stormsUnique <-  storms %>%
  select(name, year) %>%
  distinct() %>% 
  arrange(desc(row_number()))

ui <- fluidPage(
  
  titlePanel("Storm Paths"),
  
  sidebarLayout(
    
    sidebarPanel(
      dataTableOutput("nameTable")
    ),
    
  mainPanel(
  
  leafletOutput("stormMap"),
  
  dataTableOutput('stormDetails')
  
  )))

server <- function(input, output, session) {
  
  output$nameTable <- renderDataTable({
    stormsUnique
  },
  selection = "single",
  options = list(scrollX = TRUE),
  rownames = FALSE)
  
  output$stormMap <- renderLeaflet({
    
    req(input$nameTable_row_last_clicked)
    
    stormRow <- slice(stormsUnique, as.integer(input$nameTable_row_last_clicked))
    
    mapData <- storms %>%
      filter(name == stormRow$name & year == stormRow$year)
    
    leaflet(mapData, options = leafletOptions(zoomControl = FALSE)) %>%
      addCircleMarkers(lat = ~lat, lng = ~long,
                       radius = ~hurricane_force_diameter*.2,
                       layerId = ~ID,
                       stroke = FALSE, fillOpacity = 0.5) %>%
      addTiles() %>% 
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }")
  })
  
  output$stormDetails <- renderDataTable({
    
    ## This prints the current input values to the consule.
    ## Run the app and interact with it to determin which input 
    ## gives you the row number of the last clicked marker on
    ## the map.
    #str(reactiveValuesToList(input))
    
    ## Use the slice function to select the row corresponding
    ## to the clicked marker from the storms data frame.
    
    req(input$stormMap_marker_click)
    slice(storms, input$stormMap_marker_click$id) %>% 
      select(-ID)
    
    
  }, extensions = 'Scroller',
  options = list(dom = 't',
                 scrollX = T),
  selection = 'single',
  rownames = F)
  
}

shinyApp(ui, server)
