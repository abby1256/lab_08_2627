library(shiny)
library(tidyverse)

penguins <- read_csv("data/penguins.csv")
head(penguins)

ui <- fluidPage(
  titlePanel("Penguins App"),
  selectInput("x_axis", label = "Pick the x-axis" , 
     c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")),
  
  selectInput("y_axis", label = "Pick the y-axis" , 
     c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")),
  
  selectInput("colour", "Colour by" , c("None", "species", "island", "sex", "year")),
  
  sliderInput("transparency", label = "Select the transparency", min = 0, 
              max = 1, value = 1),
  
  #selectInput("filter", "Filter by" , c("None", "species", "island", "sex", "year"))
  
  plotOutput("plot")

)


server <- function(input, output, session) {
  penguin_data <- reactive({req(input$x_axis)
    req(input$y_axis)
    req(input$colour)
    if (input$colour == "None"){
      tibble(
        x_data = penguins[[input$x_axis]],
        y_data = penguins[[input$y_axis]])
    } else {
      tibble(
        x_data = penguins[[input$x_axis]],
        y_data = penguins[[input$y_axis]],
        colour_by = penguins[[input$colour]]
      )}
    })
  
  output$plot <- renderPlot({
    
    if (input$colour == "None"){
      ggplot(penguin_data(), aes(x = x_data, y = y_data)) +
        geom_point(alpha = input$transparency) +
        theme_minimal() + 
        labs(title = paste("Plot of ", input$y_axis, "against ", input$x_axis)
             ,  x = input$x_axis, y = input$y_axis) +
        theme_minimal()
    } else {
    
    ggplot(penguin_data(), aes(x = x_data, y = y_data, colour = colour_by)) +
      geom_point(alpha = input$transparency) +
      theme_minimal() + 
      labs(title = paste("Plot of ", input$y_axis, "against ", input$x_axis, 
         "coloured by ", input$colour),  x = input$x_axis, y = input$y_axis) +
      theme_minimal()
    }
  })
}

shinyApp(ui, server)




