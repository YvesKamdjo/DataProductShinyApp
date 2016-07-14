#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Will You default for your next credit card payment?"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    # Show a plot of the generated distribution
    sidebarPanel(
      fluidRow(
        column(12,
               textOutput('accuracy')
        ),
        column(12,
               textOutput('criteria')
               ),
        column(12,
               helpText("Default payment: 1= Yes, 0= No"),
               verbatimTextOutput('prediction')
               )
      )
      
    ),
    mainPanel(
      fluidRow(
        column(3, 
               h3("Info"),
               helpText("Predict if a credit holder will default", 
                        "The model is build on the UCI default of credit card clients data set"
                        )),
        column(3,
               helpText('1 = graduate school; 2 = university; 3 = high school; 4 = others'),
          selectInput('education',label = 'Select your eductaion level',
          choices = list('graduate school'=1,'university'=2, 'high school'=3, 'others'=4),
          selected = 1
          )
        ),
        column(3,
               helpText('1 = male; 2 = female'),
               radioButtons('sex',label = 'Gender',
               choices = list('male'=1,'female'=2),
               selected = 1
               )
        ),
        column(3,
               helpText('1 = married; 2 = single; 3 = others'),
               selectInput('marriage',label = 'Marital status',
               choices = list('married'=1,'single'=2,'other'=3),
               selected = 2
               )
        ),
        column(3,
          sliderInput("age",
                   "Your age",
                   min = 18,
                   max = 100,
                   value = 18)
      ),
      column(3, 
             numericInput("limit_bal", 
                          label = h3("The credit card balance limit"), 
                          value = 1))   
      ),
      column(3,
             actionButton("submit", "Submit")
             )
    )
  )
  
))
