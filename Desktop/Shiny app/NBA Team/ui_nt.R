library(shiny)
library(ggplot2)
library(DT)
library(tidyverse)
library(rvest)
library(magrittr)

NBA_team_datasets <- read_html("https://www.basketball-reference.com/teams/")
nt <- 
  NBA_team_datasets %>% 
  html_table(header = TRUE) %>% 
  extract2(1) %>% 
  filter(To == 2018) %>% 
  distinct(Franchise, .keep_all=TRUE)
colnames(nt) <- c("Franchise","Lg", "From", "To", "Yrs", "G", "W", "L", "PCT", "Plyfs", "Div", "Conf", "Champ")

nt$Champ <- as.numeric(nt$Champ)
nt$Plyfs <- as.numeric(nt$Plyfs)
nt$Div <- as.numeric(nt$Div)
nt$Conf <- as.numeric(nt$Conf)
nt$Yrs <- as.numeric(nt$Yrs)

fluidPage(
  titlePanel("NBA Franchise-record of each Team", windowTitle = "NBA Team Record"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Titles"            = "Champ", 
                              "Plyoffs made"      = "Plyfs", 
                              "Win %"              = "PCT", 
                              "Divsion Titles"    = "Div",
                              "Conference Titles" = "Conf",
                              "Years"             = "Yrs"), 
                  selected = "Champ")
    ),
    mainPanel(
      tabsetPanel(type ="tabs",
                  tabPanel(
                    title = "Plot",
                    plotOutput(outputId = "scatterplot")
                  ),
                  tabPanel(
                    title = "Glossary",
                    tags$div(
                      tags$li("Lg -- League"),
                      tags$li("From -- First year"),
                      tags$li("To -- Last year"),
                      tags$li("G -- Games"),
                      tags$li("W -- Wins"),
                      tags$li("L -- Losses"),
                      tags$li("PCT -- Win-Loss Percentage"),
                      tags$li(" Plyfs -- Years team made the playoffs"),
                      tags$li("Div -- Years team finished first (or tied for first) in the division"),
                      tags$li("Conf -- Years team won the conference championship"),
                      tags$li("Champ -- Years team won the league championship")
                    )
                  ),
                  DT::dataTableOutput(outputId = "teamtable")
      )
    )
  ))