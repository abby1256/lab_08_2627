library(shiny)
library(tidyverse)

penguins <- read_csv("data/penguins.csv")
head(penguins)

ui <- fluidPage(
  titlePanel("Penguins App"),
  selectInput("x_axis", label = "Pick the x-axis" , choices = 
     c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")),
  
  selectInput("y_axis", label = "Pick the y-axis" , choices = 
     c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")),
  
  selectInput("colour", "Colour by" , choices = c("None", "species", "island", 
                                                  "sex", "year")),
  
  sliderInput("transparency", label = "Select the transparency", min = 0, 
              max = 1, value = 1),
  
  selectInput("filter_variable", "Filter by" , choices = list("None", "species", 
   "island", "sex", "year")),
  
  selectInput("filter_value", "Choose value", choices = NULL),
  
  plotOutput("plot")

)


server <- function(input, output, session) {
  observeEvent(input$filter_variable,
    {req(input$filter_variable)
    switch(input$filter_variable,
    species = updateSelectInput(session, "filter_value", "Select species",
                        choices = c("Adelie", "Chinstrap", "Gentoo")),
    island = updateSelectInput(session, "filter_value", "Select island",
                        choices = c("Biscoe", "Dream", "Torgersen")),
    sex = updateSelectInput(session, "filter_value", "Select sex",
                        choices = c("female", "male")),
    year = updateSelectInput(session, "filter_value", "Select year",
                        choices = c(2007, 2008,2009))
    )
    })
  penguin_data <- reactive({req(input$x_axis)
    req(input$y_axis)
    req(input$colour)
    if (input$colour == "None" & input$filter_variable != "None"){
      penguins |> filter(.data[[input$filter_variable]] == input$filter_value) |>
       select(
        x_data = all_of(input$x_axis),
        y_data = all_of(input$y_axis))
    } else if (input$colour != "None" & input$filter_variable != "None"){
      penguins |> filter(.data[[input$filter_variable]] == input$filter_value) |>
        select(
         x_data = all_of(input$x_axis),
         y_data = all_of(input$y_axis),
         colour_by = all_of(input$colour))
    } else if (input$colour == "None" & input$filter_variable == "None"){
      penguins |>
        select(
          x_data = all_of(input$x_axis),
          y_data = all_of(input$y_axis))
    } else {
      penguins |>
        select(
          x_data = all_of(input$x_axis),
          y_data = all_of(input$y_axis),
          colour_by = all_of(input$colour))
    }
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




