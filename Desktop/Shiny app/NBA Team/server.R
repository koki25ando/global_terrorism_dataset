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

 
function(input, output) {
    output$scatterplot <- renderPlot({
      nt$Franchise<- reorder(nt$Franchise, -nt[,input$y])
      
      nt %>% 
        ggplot(aes_string(x = nt$Franchise, y = input$y)) + 
        geom_point(colour="red", size=2) +
        theme(axis.text.x = element_text(size = 13,angle = 70, hjust = 1)) + 
        geom_segment(aes(xend=nt$Franchise, yend=0), colour = "pink", alpha =1.0) + 
        labs(x=NULL)
    })
    
    output$teamtable <- DT::renderDataTable({
      DT::datatable(data = nt, 
                    rownames = FALSE,
                    options = list(
                      lengthMenu = list(c(5,10,15,-1), c("5","10","15","ALL")),
                      pagelength = 5)
      )
    })
  }