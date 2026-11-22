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
  
  selectInput("colour", "Colour by" , c("species", "island", "sex", "year")),
  
  sliderInput("transparency", label = "Select the transparency", min = 0, 
              max = 1, value = 1),
  
  plotOutput("plot")

)


server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    
    req(input$x_axis, input$y_axis, input$colour)
    
    ggplot(penguins, aes(x = .data[[input$x_axis]], y = .data[[input$y_axis]],
      colour = .data[[input$colour]])) +
      geom_point(alpha = input$transparency) +
      theme_minimal() + 
      labs(title = paste("Plot of ", input$y_axis, "against ", input$x_axis, 
         "coloured by ", input$colour),  x = input$x_axis, y = input$y_axis) +
      theme_minimal()
  })
}

shinyApp(ui, server)




