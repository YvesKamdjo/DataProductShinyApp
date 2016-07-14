#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(gdata)
require(e1071) 
require(caret)

testing <- NULL


readData <- function(){
  #To use the function read.xls
  
  filename <- 'CreditCard.xls'
  
  if(file.exists(filename)==FALSE){
    download.file('http://archive.ics.uci.edu/ml/machine-learning-databases/00350/default%20of%20credit%20card%20clients.xls',
                  filename,mode = 'w', quiet = TRUE)
  }
  
  #The first column start by the pattern 'ID'
  Cdata <- read.xls(filename,pattern = 'ID')
  
  
  okData <- data.frame(EDUCATION=factor(Cdata$EDUCATION),SEX=factor(Cdata$SEX),
                       MARRIAGE=factor(Cdata$MARRIAGE),AGE=Cdata$AGE,LIMIT_BAL= Cdata$LIMIT_BAL,
                       default.payment.next.month=factor(Cdata$default.payment.next.month)
  )
  
  okData 
}

#A read only data set that will load once, when Shiny starts, and will be 
#available to each user session
creditCarData <- readData()

#Build a simple logistic regression model to predict Default/ not default
creditCardModel <- function(data){
 
  
  #Data splitting
  inTrain <- createDataPartition(data$default.payment.next.month,p=0.75,list=FALSE)
  
  training <- data[inTrain,]
  testing  <<- data[-inTrain,]
  
  modelFit <- train(default.payment.next.month~., data=training, method='glm')
  
  modelFit
}

GLMModel <- creditCardModel(creditCarData)

pred.test <- predict(GLMModel, newdata=testing)

accu <- confusionMatrix(pred.test,testing$default.payment.next.month)$overall['Accuracy']

# Define server logic required to swho the prediction result
shinyServer(function(input, output) {
   output$accuracy <- renderText({
     
    
     
     paste('Model accuracy: ',accu)
   })
   
  observeEvent(input$submit, {
    output$criteria <- renderText({
      paste("Criteria:","Education level: ",input$education," Gender: ",input$sex," marital Status: ",input$marriage," age: ", input$age, " Balance limit ",input$limit_bal) 
      #print(summary(GLMModel))
    })
    output$prediction <- renderText({
      values <-  data.frame(EDUCATION=factor(input$education),SEX=factor(input$sex),
                            MARRIAGE=factor(input$marriage),AGE=input$age,LIMIT_BAL= input$limit_bal
      )
      pred <- predict(GLMModel, newdata=values)
      
       pred
     
    })
  })
  
  
 
  
})
