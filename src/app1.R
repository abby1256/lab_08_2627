library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel(
    tagList(
      textOutput("title", inline = TRUE),
      "Shiny App"
    ),
    # Without this, the browser tab would show the HTML of the title above.
    windowTitle = "Shiny App"
  ),
  textInput("name", label = "Enter your Name"),
  
  numericInput("age", label = "Enter your age", value = 18),
 
  selectInput("colour", label = "What is your favourite colour?", c("Blue", "Red", 
                                                                    "Yellow", "Purple", "Green")),

  uiOutput("colourgreeting")
  )

server <- function(input, output, session) {
  output$title <- renderText({req(input$name) 
    paste0(input$name, "'s")})
  
  greeting <- reactive({req(input$name)
    paste("Hello ", input$name, "your favourite colour is ", input$colour, " and you are ", 
          input$age, " years old.")})

  output$colourgreeting <- renderUI(
    span(style = paste("color: ", input$colour), greeting()))


  
}

shinyApp(ui, server)
