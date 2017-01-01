# Smart Keyboard 
# Shiny web application Server logic

library(shiny)

shinyServer(function(input, output) {
  
  bidf <- read.csv(file="predicted_2gram.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
  tridf <- read.csv(file="predicted_3gram.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
  
  output$entered_text <- renderPrint({ input$user_text })
  
  sentence_tail <- reactive({
    tail(strsplit(input$user_text,split=" ")[[1]],2)
  })
  
  word <- reactive({
    a <- sentence_tail()
    
    if (length(a) > 1) { 
      paste(a[1], "_", a[2], sep="") 
    } else {
      a
    }
  })

  prediction <- reactive({
    # if input text has text
    if (length(word())) { 
      
      # if tail of sentence is 2 words so that we can start searching from 3grams
      if (length(sentence_tail()) == 2) {
        df <- tridf[which(tridf$word == word()),]
        
        # if the tail of sentence was found in trigrams 
        if (nrow(df)) {
          data.frame(prediction=c(df[1,2], df[1,4], df[1,6]), estimate=c(df[1,3], df[1,5], df[1,7]))
        # if  the tail of sentence was not found in trigrams then search the last word in bigrams
        } else {
          df <- bidf[which(bidf$word == gsub(".*_","",word())),]
          
          # search the last word in bugrams
          if (nrow(df)) {
            data.frame(prediction=c(df[1,2], df[1,4], df[1,6]), estimate=c(df[1,3], df[1,5], df[1,7]))
          }
          # if last word was not in bigrams then display unigrams
          else {
            data.frame(prediction=c("the", "to", "and"), estimate=c(0.04778775, 0.02782042, 0.02391356))
          }
        }

      # if tail of sentence is only 1 word so that we can start searching from 2grams 
      } else {
        df <- bidf[which(bidf$word == word()),]
        
        # search the last word in bugrams
        if (nrow(df)) {
          data.frame(prediction=c(df[1,2], df[1,4], df[1,6]), estimate=c(df[1,3], df[1,5], df[1,7]))
        }
        # if last word was not in bigrams then display unigrams
        else {
          data.frame(prediction=c("the", "to", "and"), estimate=c(0.04778775, 0.02782042, 0.02391356))
        }
      }

    # if input text is empty display unigrams     
    } else {
      data.frame(prediction=c("the", "to", "and"), estimate=c(0.04778775, 0.02782042, 0.02391356))
    }
  })
  
  output$ngram <- renderPrint({ word() })
  
  output$next_word_preditions <- renderPrint({ prediction() })
})
