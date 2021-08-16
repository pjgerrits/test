# ################################################################################################
# ################################################################################################
# # Sec 1a. Needed Libaries & Input Files
library(shiny)
library(shinydashboard)
library(mapdeck)
library(dplyr)
library(tidyverse)

################################################################################################
################################################################################################
#UI
ui <- fillPage(dashboardPage(
  dashboardHeader(disable = TRUE), 
  dashboardSidebar(disable = TRUE), 
  dashboardBody(
    fluidRow(mapdeckOutput(outputId = 'mapA')),
    tags$style(type = "text/css", "#mapA {height: calc(100vh - 80px) !important;}"))
)
)


################################################################################################
################################################################################################
server <- function(input, output) {
  
  ##The MapDeck Token
  key <- 'pk.eyJ1IjoicGdlcnJpdHMiLCJhIjoiY2s5aWFpODZlMDVxajNvbWc5ajZiOTc0ZSJ9.GuunVUSLbrFSlTvUax_s8g'    ## put your own token here
  set_token(key) ## set your access token
  dfb <- read_csv("https://raw.githubusercontent.com/pietgerrits/Edirne_test/main/Settlements_Combined_v3.csv")
  
  
  ### The Map
  output$mapA <- renderMapdeck({
    m <- mapdeck(token = key, style = mapdeck_style('dark'),   pitch = 45) %>% 
      add_grid(data = dfb, lat = "newpoint_y", lon = "newpoint_x", 
               cell_size = 1000, elevation_scale = 50, layer_id = "both",
               colour_range = colourvalues::colour_values(1:6, palette = "plasma")) %>%
      add_heatmap(
        data = dfb
        , weight = "both",
        lat = "newpoint_y", lon = "newpoint_x",
        layer_id = "heatmap_layer"
        # ) %>%
        # legend_element(variables = "both",
        #                colours = "#00FF00",
        #   colour_type = "fill",
        #   variable_type = "category",
        #   title = "Legend"
      )
  })
  output$mapB <- renderLeaflet({
    m <- leaflet() %>% 
      # addProviderTiles(providers$Stamen.Toner) %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(dfb$newpoint_x, dfb$newpoint_y, popup = paste0("<b>Population: </b>", dfb$both, "
                                                            <br>", "<b>Name: </b>", dfb$belediye_koy))
  })
}
################################################################################################
################################################################################################
shinyApp(ui = ui, server = server)

