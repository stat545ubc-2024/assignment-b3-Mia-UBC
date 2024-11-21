
# Welcome to my shiny app
## This code builds a shiny app which will allow the user to filter the palmer penguins dataset and download the resulting table.

library(shiny)

library(palmerpenguins)

library(dplyr)

# Code the ui below

ui <- fluidPage(
  
  # App Title
  titlePanel("Palmer Penguins!"),
  
  # Create a sidebar and main panel
  sidebarLayout(
    
    # Code for features in the sidebar
    sidebarPanel(
      
      # Select which species the table will display. Can select multiple species if desired. This allows for the user to only see data from the species, singular or plural, that they are interested in.
      
      selectInput("speciesIN", "species", choices = levels(penguins$species), selected = NULL, multiple = TRUE),
      
      # Select which inland(s) the table will display. This allows for the user to only see data from the island(s) that they are interested in.
      
      selectInput("islandIN", "island", choices = levels(penguins$island), selected = NULL, multiple = TRUE),
      
      # Select which sex(es) the table will display. This allows for the user to only see data from the sex(es) that they are interested in.
      
      checkboxGroupInput("sexIN", "sex", choices = c("female", "male"), selected = NULL),
    ),
    
    # Code for features in the main panel. 
    
    mainPanel(
      
      # This produces a table from the *palmerpenguins* dataset. As the DT package is used, the resulting table will be compact, and come with some basic filtering and search abilities for the user.
      
      DT::dataTableOutput("my_table"))
  )
)

# Code the server below

server <- function(input, output) {

  # Renders the table in the main panel. As the DT package is used, this also implements several features for filtering and searching the data.
  
  filtered_penguins <- reactive({
    penguins %>% 
      filter(
        (is.null(input$speciesIN) | species %in% input$speciesIN) & 
        (is.null(input$islandIN) | island %in% input$islandIN) &
        (is.null(input$sexIN) | sex %in% input$sexIN)
      )
  })
  
  output$my_table <- DT::renderDataTable({
    filtered_penguins()
  })
}

# The following line MUST be the last line in the file; delete anything after it before running the app

shinyApp(ui = ui, server = server)