###DEMO for SHINYR examples###
# Lessons are adapted and organized by Noushin Nabavi, PhD.
## exploring various plots with shiny 

# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Add the text "Shiny is fun"
  "Shiny is fun"
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # "DataCamp" as a primary header
  h1("Hellow"),
  # "Shiny use cases course" as a secondary header
  h2("How are you"),
  # "Shiny" in italics
  em("hi"),
  # "is fun" as bold text
  strong("this is fun")
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# adding structure to the app
# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Add a sidebar layout to the application
  sidebarLayout(
    # Add a sidebar panel around the text and inputs
    sidebarPanel(
      h4("Plot parameters"),
      textInput(inputId = "title", label = "Plot title", value = "Car speed vs distance to stop"),
      numericInput(inputId = "num", label = "Number of cars to show", value = 30, min = 1, max = nrow(cars)),
      sliderInput("size", "Point size", 1, 5, 2, 0.5)
    ),
    # Add a main panel around the plot and table
    mainPanel(
      plotOutput(outputId = "plot"),
      tableOutput(outputId = "table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    plot(cars[1:input$num, ], main = input$title, cex = input$size)
  })
  output$table <- renderTable({
    cars[1:input$num, ]
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Create a numeric input with ID "age" and label of
  # "How old are you?"
  numericInput(inputId = "age", label = "How old are you?", value = 20),
  
  # Create a text input with ID "name" and label of 
  # "What is your name?"
  textInput(inputId = "name", label = "What is your name?")
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

library(shiny)

# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      # Create a text input with an ID of "name"
      textInput("name", "What is your name?", "Dean"),
      numericInput("num", "Number of flowers to show data for",
                   10, 1, nrow(iris))
    ),
    mainPanel(
      # Add a placeholder for a text output with ID "greeting"
      textOutput(outputId = "greeting"),
      # Add a placeholder for a plot with ID "cars_plot"
      plotOutput("cars_plot"),
      # Add a placeholder for a table with ID "iris_table"
      tableOutput("iris_table")
    )
  )
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What is your name?", "Dean"),
      numericInput("num", "Number of flowers to show data for",
                   10, 1, nrow(iris))
    ),
    mainPanel(
      textOutput("greeting"),
      plotOutput("cars_plot"),
      tableOutput("iris_table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Create a plot of the "cars" dataset 
  output$cars_plot <- renderPlot({
    plot(cars)
  })
  
  # Render a text greeting as "Hello <name>"
  output$greeting <- renderText({
    paste("Hello", input$name)
  })
  
  # Show a table of the first n rows of the "iris" data
  output$iris_table <- renderTable({
    data <- iris[1:input$num, ]
    data
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# reactive contexts
ui <- fluidPage(
  numericInput("num1", "Number 1", 5),
  numericInput("num2", "Number 2", 10),
  textOutput("result")
)

server <- function(input, output) {
  # Calculate the sum of the inputs
  my_sum <- reactive({
    input$num1 + input$num2
  })
  
  # Calculate the average of the inputs
  my_average <- reactive({
    my_sum() / 2
  }) 
  
  output$result <- renderText({
    paste(
      # Print the calculated sum
      "The sum is", my_sum(),
      # Print the calculated average
      "and the average is", my_average()
    )
  })
}

shinyApp(ui, server)

#------------------------------------------------------------------------------

# Load the gapminder package
library(gapminder)

# Define UI for the application
ui <- fluidPage(
  "The population of France in 1972 was",
  textOutput("answer")
)

# Define the server function
server <- function(input, output) {
  output$answer <- renderText({
    # Determine the population of France in year 1972
    subset(gapminder, country == "France" & year == 1972)$pop
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# Load the ggplot2 package for plotting
library(ggplot2)

# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      # Add a title text input
      textInput("title", "Title", "GDP vs life exp")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      geom_point() +
      scale_x_log10() +
      # Use the input value as the plot's title
      ggtitle(input$title)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------
# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      # Add a size numeric input
      numericInput("size", "Point size", 1, 1)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      # Use the size input as the plot point size
      geom_point(size = input$size) +
      scale_x_log10() +
      ggtitle(input$title)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------
# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      # Add a checkbox for line of best fit
      checkboxInput("fit", "Add line of best fit", FALSE)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    p <- ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size) +
      scale_x_log10() +
      ggtitle(input$title)
    
    # When the "fit" checkbox is checked, add a line
    # of best fit
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------
# adding colors
# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      checkboxInput("fit", "Add line of best fit", FALSE),
      # Add radio buttons for colour
      radioButtons("colour", "Point colour",
                   choices = c("blue", "red", "green", "black"))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    p <- ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      # Use the value of the colour input as the point colour
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title)
    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------
# Add a continent selector: select input

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      checkboxInput("fit", "Add line of best fit", FALSE),
      radioButtons("colour", "Point colour",
                   choices = c("blue", "red", "green", "black")),
      # Add a continent dropdown selector
      selectInput("continents", "Continents",
                  choices = levels(gapminder$continent),
                  multiple = TRUE,
                  selected = "Europe")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    # Subset the gapminder dataset by the chosen continents
    data <- subset(gapminder,
                   continent %in% input$continents)
    
    p <- ggplot(data, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title)
    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

shinyApp(ui = ui, server = server)
#------------------------------------------------------------------------------

# Add a year filter: numeric slider input

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      checkboxInput("fit", "Add line of best fit", FALSE),
      radioButtons("colour", "Point colour",
                   choices = c("blue", "red", "green", "black")),
      selectInput("continents", "Continents",
                  choices = levels(gapminder$continent),
                  multiple = TRUE,
                  selected = "Europe"),
      # Add a slider selector for years to filter
      sliderInput("years", "Years",
                  min(gapminder$year), max(gapminder$year),
                  value = c(1977, 2002))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    # Subset the gapminder data by the chosen years
    data <- subset(gapminder,
                   continent %in% input$continents &
                     year >= input$years[1] & year <= input$years[2])
    
    p <- ggplot(data, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title)
    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------
# Advanced features to improve your plot

# Load the colourpicker package
library(colourpicker)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      checkboxInput("fit", "Add line of best fit", FALSE),
      
      # Replace the radio buttons with a colour input
      colourInput("colour", "Point colour", value = "blue"),
      selectInput("continents", "Continents",
                  choices = levels(gapminder$continent),
                  multiple = TRUE,
                  selected = "Europe"),
      sliderInput("years", "Years",
                  min(gapminder$year), max(gapminder$year),
                  value = c(1977, 2002))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    data <- subset(gapminder,
                   continent %in% input$continents &
                     year >= input$years[1] & year <= input$years[2])
    
    p <- ggplot(data, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title)
    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# making larger plots

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      checkboxInput("fit", "Add line of best fit", FALSE),
      colourInput("colour", "Point colour", value = "blue"),
      selectInput("continents", "Continents",
                  choices = levels(gapminder$continent),
                  multiple = TRUE,
                  selected = "Europe"),
      sliderInput("years", "Years",
                  min(gapminder$year), max(gapminder$year),
                  value = c(1977, 2002))
    ),
    mainPanel(
      # Make the plot 600 pixels wide and 600 pixels tall
      plotOutput("plot", width = 600, height = 600)
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    data <- subset(gapminder,
                   continent %in% input$continents &
                     year >= input$years[1] & year <= input$years[2])
    
    p <- ggplot(data, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title)
    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------

# Make your plot interactive

# Load the plotly package
library(plotly)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      checkboxInput("fit", "Add line of best fit", FALSE),
      colourInput("colour", "Point colour", value = "blue"),
      selectInput("continents", "Continents",
                  choices = levels(gapminder$continent),
                  multiple = TRUE,
                  selected = "Europe"),
      sliderInput("years", "Years",
                  min(gapminder$year), max(gapminder$year),
                  value = c(1977, 2002))
    ),
    mainPanel(
      # Replace the `plotOutput()` with the plotly version
      plotlyOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Replace the `renderPlot()` with the plotly version
  output$plot <- renderPlotly({
    # Convert the existing ggplot2 to a plotly plot
    ggplotly({
      data <- subset(gapminder,
                     continent %in% input$continents &
                       year >= input$years[1] & year <= input$years[2])
      
      p <- ggplot(data, aes(gdpPercap, lifeExp)) +
        geom_point(size = input$size, col = input$colour) +
        scale_x_log10() +
        ggtitle(input$title)
      
      if (input$fit) {
        p <- p + geom_smooth(method = "lm")
      }
      p
    })
  })
}

shinyApp(ui = ui, server = server)

#------------------------------------------------------------------------------