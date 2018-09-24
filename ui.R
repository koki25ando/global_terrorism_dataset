library(shiny)
library(DT)
library(data.table)
library(plotly)

gtd <- fread("https://s3-ap-southeast-2.amazonaws.com/globalterrorismdataset/global_terrorism_dataset.csv", data.table = FALSE)
gtd$iyear <- as.numeric(gtd$iyear)
gtd$imonth <- as.numeric(gtd$imonth)
gtd$iday <- as.numeric(gtd$iday)
gtd$date <- as.Date(gtd$date)



fluidPage(
  titlePanel("Global Terrorism Dataset", windowTitle = "GTD"),
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        h3("Plotting"),
        sliderInput(
          inputId = "period",
          label = "Select Period",
          value = c(1980, 2010),
          min = min(gtd$iyear), 
          max = max(gtd$iyear),
          format="####"
        ),
        selectInput(
          inputId = "fill",
          label = "Colour by :",
          choices = c("Region" = "region_txt",
                      "Attack Type" = "attacktype1_txt", 
                      "Target Type" = "targtype1_txt", 
                      "Weapon Type" = "weaptype1_txt"),
          selected = "region_txt"
        )
      ),
      wellPanel(
        h3("Data Table"),
        checkboxGroupInput(
          inputId = "select_var",
          label = "Select Variables",
          choices = names(gtd),
          selected = c("date","country_txt","city",
                       "attacktype1_txt","nkill", "nwound")
        ))
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel(
                    title = "reference",
                    h1("Global Terrorism Dataset"),
                    h2("Overview"),
                    h4("Information on more than 170,000 Terrorist Attacks"),
                    h4("The Global Terrorism Database (GTD) is an open-source database including information on terrorist attacks around the world 
                       from 1970 through 2016 (with annual updates planned for the future). The GTD includes systematic data on domestic as well as 
                       international terrorist incidents that have occurred during this time period and now includes more than 170,000 cases. 
                       The database is maintained by researchers at the National Consortium for the Study of Terrorism and Responses to Terrorism (START), 
                       headquartered at the University of Maryland. "),
                    a(href = "https://www.kaggle.com/START-UMD/gtd/data", "Global Terrorism Database"),
                    br()
                    ),
                  tabPanel(
                    title = "bar",
                    plotOutput(outputId = "barplot")
                  ),
                  tabPanel(
                    title = "map",
                    plotOutput(outputId = "map_plot")
                  )),
      DT::dataTableOutput(outputId = "table")
      ) 
    )
    )