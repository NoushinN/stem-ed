###DEMO for SHINYR###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# Library dependencies: shiny package 

install.packages("shiny")
library("shiny") # to load the shiny package

# ShinyApp is composed of ui and server
## user interface (ui) = code for creating the web page
## server = code for the computer running the R calculations 

# A. Define ui:
ui <- basicPage()

# B. Define server:
server <- function(input, output) {}

# C. Assemble the shinyApp
shinyApp(ui = ui, server =server)

# Ex. 1: Getting a bit closer: now definte the ui better

ui <- pageWithSidebar(
  titlePanel("This is the title of the panel"),
  sidebarPanel("This is the sidebar panel"),
  mainPanel("This is the main Panel")
)

# assemble the app
server <- function(input, output) {}
shinyApp(ui = ui, server =server)

# Ex. 2: can also try a more basic ui layout by using fluidpage

ui <- fluidPage(
  titlePanel("This is the title of the panel"),
  sidebarPanel("This is the sidebar panel"),
  mainPanel("This is the main Panel")
)

# assemble the app
server <- function(input, output) {}
shinyApp(ui = ui, server =server)

# Ex. 3: build up the layout with slider input


ui <- fluidPage(
  titlePanel("This is the title of the panel"),
  sidebarLayout(
    sidebarPanel("This is the sidebar panel",
                 sliderInput(
                   inputId = "bins",
                   label = "Slider label",
                   min = 0, max = 10, value = 5)),
  mainPanel("This is the main Panel")
))

# assemble the app
server <- function(input, output) {}
shinyApp(ui = ui, server =server)



# Ex. 4: build the layout with select list input


ui <- fluidPage(
  titlePanel("This is the title of the panel"),
  sidebarLayout(
    sidebarPanel("This is the sidebar panel",
                 selectInput(
                   inputId = "list",
                   label = "List label",
                   choices = c("Good", "Bad", "Ugly"),
                   selected = "Good")),
    mainPanel("This is the main Panel")
  ))

# assemble the app
server <- function(input, output) {}
shinyApp(ui = ui, server =server)








