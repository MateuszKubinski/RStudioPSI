

library(shiny)
library(maps)
library(mapproj)

stany <- readRDS("data/stany.rds")
source("helpers.R")

shinyApp(ui,server)


ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Tworzenie mapy demograficznej na podstawie 
               informacji ze spisu powszechnego w USA w 2010 r."),
      
      selectInput("var", 
                  label = "Wybierz zmienną do wyświetlenia",
                  choices = c("Procent Bialych", "Procent Czarnoskorych",
                              "Procent Latynosow", "Procent Azjatow"),
                  selected = "Procent Bialych"),
      
      sliderInput("zakres", 
                  label = "Wybrany zakres:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("mapa"))
  )
)

server <- function(input, output) {
  output$mapa <- renderPlot({
    data <- switch(input$var, 
                   "Procent Bialych" = stany$white,
                   "Procent Czarnoskorych" = stany$black,
                   "Procent Latynosow" = stany$hispanic,
                   "Procent Azjatow" = stany$asian)
    
    color <- switch(input$var, 
                    "Procent Bialych" = "darkgreen",
                    "Procent Czarnoskorych" = "black",
                    "Procent Latynosow" = "darkorange",
                    "Procent Azjatow" = "darkviolet")
    
    legend.title <- switch(input$var,
                           "Procent Bialych" = "% Białych",
                           "Procent Czarnoskorych" = "% Czarnych",
                           "Procent Latynosow" = "% Latynosów",
                           "Procent Azjatow" = "% Azjatów" )
    
    
    percent_map(var=data, color=color, legend.title = legend.title, max = 100, min = 0)
  })
}




# uruchom app ----
shinyApp(ui = ui, server = server)

