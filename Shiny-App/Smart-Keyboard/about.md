## Smart Keyboard

This Shiny application gets a text from user as input, processes it in real time and presents three options for what the next word might be along their estimates. The data that this app is built on, is a sample dataset derived from these [large datasets](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). This app is the Capstone Project for "Data Science Specialization" offered by Johns Hopkins University through coursera.com.

Simply enter a text in the textfield and you can see that as you type the application proccesses your text and suggests three options for the next word. Predicting the next word problem is a **Markov Model**. This model assumes that predicting next word only depends a few number of preceding words and not the whole text. This application only looks at the preceding 2 words of the input to guess the next word. 

This application uses three datasets to function Unigrams, Bigrams and Trigrams. Unigrams are the unique single words that were observed in the sample dataset with their estimates. Bigrams are *w1w2* format two word phrases that their first word *w1* are observed unigrams but the second word *w2* may or may not has been seen after *w1* in the sample dataset. Also Trigrams are *w1w2w3* format three word phrases that their first two words *w1w2* are observed bigrams in the sample but the third word *w3* may or may not has been seen after *w1w2* in the sample dataset.

For generating unseen bigrams and trigrams and their estimates, we used a discounting method to smooth the estimates for seen bigrams and trigrams. for discounting these estimates we applied **Katz's Back-Off** model.     

You may find more detailed information about this project at [here](https://github.com/tmazhari/Data-Science-Specialization_Capstone-Project).
  