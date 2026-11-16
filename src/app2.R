library(shiny)
library(tidyverse)

penguins <- read_csv("data/penguins.csv")
head(penguins)

ui <- fluidPage(
  titlePanel("Penguins App"),
  selectInput("x_axis", label = "Pick the x-axis" , c("bill_length_mm", "bill_depth_mm", 
                                                      "flipper_length_mm", "body_mass_g")),
  
  selectInput("y_axis", label = "Pick the y-axis" , c("bill_length_mm", "bill_depth_mm", 
                                                      "flipper_length_mm", "body_mass_g")),
  
  #selectInput("colour", "Colour by" , c("species", "island", "sex", "year")),
  
  plotOutput("plot")

)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    ggplot(penguins, aes(x = input$x_axis, y = input$y_axis, #colour = input$colour
                         ) + geom_point())
  })
  

}

shinyApp(ui, server)