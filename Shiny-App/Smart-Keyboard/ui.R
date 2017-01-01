# Smart Keyboard 
# Shiny web application UI definition 

library(shiny)
library(markdown)

shinyUI(navbarPage("Smart Keyboard",
                   # Interface Panel
                   tabPanel("Interface",
                            sidebarLayout(
                              sidebarPanel(
                                helpText("This is a smart keyboard. Simply enter a text in  the following input",
                                         "and the application predicts the next word based on",
                                         "the last words of your text."),
                                textInput("user_text", 
                                          label = strong("Your text"), 
                                          value = "Enter text...")
                              ),
                              mainPanel(
                                h4("Your Text"),
                                verbatimTextOutput("entered_text"),
                                h4("Ngram"),
                                verbatimTextOutput("ngram"),
                                h4("Prediction For Next Word"),
                                verbatimTextOutput("next_word_preditions")
                              )
                            )
                   ),
                   # About Panel
                   tabPanel("About",
                            mainPanel(
                              # About application
                              includeMarkdown("about.md")
                            )
                   )
)
)