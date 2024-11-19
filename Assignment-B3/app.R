#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Example code below, consult and delete

# # Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
# 
#     # Sidebar with a slider input for number of bins 
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#            plotOutput("distPlot")
#         )
#     )
# )
# 
# # Define server logic required to draw a histogram
# server <- function(input, output) {
# 
#     output$distPlot <- renderPlot({
#         # generate bins based on input$bins from ui.R
#         x    <- faithful[, 2]
#         bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#         # draw the histogram with the specified number of bins
#         hist(x, breaks = bins, col = 'darkgray', border = 'white',
#              xlab = 'Waiting time to next eruption (in mins)',
#              main = 'Histogram of waiting times')
#     })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)


library(shiny)

library(palmerpenguins)

# Code the ui below

ui <- fluidPage(
  
  # App Title
  titlePanel("Palmer Penguins"),
  
  # Create a sidebar and main panel
  sidebarLayout(
    
    # Code for features in the sidebar
    sidebarPanel(
      
      # Select which species the table will display. Can select multiple species if desired. This allows for the user to only see data from the species, singular or plural, that they are interested in.
      selectInput("speciesIN", "species", choices = levels(penguins$species)),
      # Select which inland(s) the table will display. This allows for the user to only see data from the island(s) that they are interested in.
      selectInput("islandInput", "Island", choices = c("Biscoe", "Dream", "Torgersen"), multiple = TRUE),
      
      # Select which sex(es) the table will display. This allows for the user to only see data from the sex(es) that they are interested in.
      checkboxGroupInput("sexInput", "Sex", choices = c("female", "male")),
      
      # Download the produced table. This allows the user to download the table with the data filters they have applied as a .csv file, so that they can use it as they please.
      downloadButton("downloadOutput", "Download Table", icon("Download"))
    ),
    
    # Code for features in the main panel. 
    ## This produces a table from the palmer penguins dataset. As the DT package is used, the produced table has several filtering features, which allow the user to sort the data as they desire.
    mainPanel(tableOutput("my_table"))
  )
)

# Code the server below

server <- function(input, output) {

  # Renders the table in the main panel
  #output$pengs <- DT::renderDataTable(penguins)
  
  output$my_table <- renderTable({
   subset(penguins, species == input$speciesIN)
   })
  
  # Allows the download button to function. This will write the data as a .csv file.
  output$downloadOutput <- downloadHandler("Palmer Penguins Table.csv", content = function(file) {
    write.csv(PalmerPenguinTable, file)
  }
  )
}

# The following line MUST be the last line in the file; delete anything after it before running the app

shinyApp(ui = ui, server = server)