
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(randomForest)


#model load 
modelFit <- readRDS("rfMin.rds") #only wish to load this once per app startup (not with the page is refreshed)

#conversion functions
ageConvert <- function(age) ifelse(age=='adult',1,9)
doubleConvert <- function(temp) as.double(temp)
numericConvert <- function(temp) as.numeric(temp)
extm_tempConvert <- function(temp) ifelse(temp=='Normal', 1, ifelse(temp=='Warm',2,ifelse(temp=='Cool',3,4)))
periph_pulseConvert <- function(temp) ifelse(temp=='Normal',1,ifelse(temp=='Increased',2,ifelse(temp=='Reduced',3,4)))
muc_membConvert <- function(temp) ifelse(temp=='Normal Pink',1,ifelse(temp=='Bright Pink',2,ifelse(temp=='Pale Pink',3,ifelse(temp=='Pale Cyanotic',4,ifelse(temp=='Bright Red',5,6)))))
cap_refilConvert <- function(temp) ifelse(temp=='Less than 3 seconds',1,2)
painConvert <- function(temp) ifelse(temp=='no pain',1,ifelse(temp=='depressed',2,ifelse(temp=='intermittent mild pain',3,ifelse(temp=='intermittent severe pain',4,5))))
peristalsisConvert <- function(temp) ifelse(temp=='hypermotile',1,ifelse(temp=='normal',2,ifelse(temp=='hypomotile',3,4)))
abd_distConvert <- function(temp) ifelse(temp=='none',1,ifelse(temp=='slight',2,ifelse(temp=='moderate',3,4)))


#server function
shinyServer(function(input, output) {

    output$progOutput <- renderTable({modelFit$finalModel$confusion})
    
    #ageData <- reactive(ifelse(input$ageInput == 'adult',1,9))
    
    
    #newdf <- data.frame("age"={ageConvert(input$ageInput)})
    
    #output$progOutput <- renderPrint('newdf')
        
    #output$predictOutput <- renderPrint({ageData(input$ageInput)})
    output$predictOutput <- renderText({
        newdf <- data.frame("age"=ageConvert(input$ageInput),
                            "rect_temp"=doubleConvert(input$rect_tempInput),
                            "pulse"=numericConvert(input$pulseInput),
                            "resp_rate"= numericConvert(input$resp_rateInput),
                            "extm_temp"=extm_tempConvert(input$extm_tempInput),
                            "periph_pulse"=periph_pulseConvert(input$periph_pulseInput),
                            "muc_memb"=muc_membConvert(input$muc_membInput),
                            "cap_refil"=cap_refilConvert(input$cap_refilInput),
                            "pain"=painConvert(input$painInput),
                            "peristalsis"=peristalsisConvert(input$peristalsisInput),
                            "abd_dist"=abd_distConvert(input$abd_distInput))
        
        pred <- predict(modelFit,newdf)
                            
        
        ifelse(pred==1,"Good Recovery Expected","Urgent Care Required")
    })

})
