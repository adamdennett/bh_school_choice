library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(tidyverse)
library(viridis)
library(janitor)
library(shinylive)
library(httpuv)
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
##----------------

#source("SchoolDistance/load_data.R")

##---------------

# # Convert dataframes to sf objects
# BN_pcds_to_school_dist <- st_as_sf(BN_pcds_to_school_dist)
# brighton_sec_schools <- st_as_sf(brighton_sec_schools)
# 
# # Perform the spatial join
# BN_pcds_to_school_dist <- st_join(BN_pcds_to_school_dist, brighton_sec_schools, join = st_nearest_feature)
# 
# # Select and rename columns
# BN_pcds_to_school_dist <- BN_pcds_to_school_dist %>%
#   select(origin_id, destination_id, entry_cost, network_cost, exit_cost, total_cost, geom, school_name = establishment_name)



# Assuming your dataframe is named df
df <- BN_pcds_to_school_dist


# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Home to School Distance Finder"),
  sidebarLayout(
    sidebarPanel(
      textInput("origin", "Enter your home postcode, e.g.  BN3 3BQ:")
    ),
    mainPanel(
      h3(textOutput("originTitle")),
      leafletOutput("map"),
      tableOutput("costTable")
    )
  )
)


###map time
server <- function(input, output, session) {
  filtered_data <- reactive({
    df %>%
      filter(origin_id == input$origin)
  })
  
  output$originTitle <- renderText({
    paste("Distance along the road network from postcode:", input$origin)
  })
  
  output$map <- renderLeaflet({
    data <- filtered_data()
    
    # Create reversed color palette
    pal <- colorNumeric(
      palette = rev(magma(256)),
      domain = data$total_cost
    )
    
    leaflet(data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolylines(
        data = st_as_sf(data, wkt = "geom"),
        color = ~pal(total_cost)
      ) %>%
      addLegend(
        pal = pal,
        values = data$total_cost,
        title = "Total Distance (metres)"
      )
  })
  
  output$costTable <- renderTable({
    data <- filtered_data() %>%
      select(school_name, total_cost) %>%
      rename(
        School = school_name,
        `Distance (metres)` = total_cost
      ) %>%
      st_set_geometry(NULL) %>%
      arrange(`Distance (metres)`)
  })
}




# Run the application 
shinyApp(ui = ui, server = server)
shinylive::export(appdir = "SchoolDistance", destdir = "../docs")
