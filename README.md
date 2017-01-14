# Data Science Spacialization - Capstone Project

This repository contains my submissions for Capstone Project of Data Science Specialization offered by Johns Hopkins University through coursera.com.

In this project I have created a Shiny application called "Smart Keyboard". The Smart Keyboard lets user to enter a text, processes it in real time and presents three options for what the next word might be. The source code for this application can be found in this repository. The Smart Keyboard Shiny application can be accessed at:
https://tmazhari.shinyapps.io/Smart-Keyboard

## Background

Simply enter a text in the textfield and you can see that as you type the application proccesses your text and suggests three options for the next word.

## Data

Blogs | News | Twitter
--- | --- | ---
899288 Lines | 1010242 Lines | 2360148 Lines
205 MB | 201 MB | 163 MB
1 | 2 | 3

### Sampling Data

## Problem

Predicting the next word problem is a **Markov Model**. Markov models are a class of probabilistic models that assume we can predict the probability of some future unit without looking too far into the past. In other words, this model assumes that predicting next word only depends on a few number of preceding words and not the whole text. This is why we generate N-Grams to use them to predict the next word. We simply look at the preceding 1, 2, 3 or ... words and predict the next word based on the probability of these preceding words and not the whole text. In the application we only look at the preceding 2 words of the input to guess the next word.

## Prediction Model 

This application uses three datasets to function: Unigrams, Bigrams and Trigrams. And the general idea that our prediction model uses is as follows:
  1. Extract last two words from the input text and look up Trigrams for records that have highest probabilites whose first two words match the two words we extracted. If found return top three results. 
  2. If no results were found in Trigrams, look up Bigrams for records with highest probabilites whose first word match the last word we extracted. If found, return top three results.
  3. If no results were found in Bigrams, look up Unigrams and return words with top three words with highest probabilites.

But it is not that simple. What is probability of a word? Highest frequency ? Note that estimates are the maximum likihood estimates. Also we should account for unseen N-Grams.

### N-Grams

### Smoothing

This application uses three datasets to function Unigrams, Bigrams and Trigrams. Unigrams are the unique single words that were observed in the sample dataset with their estimates. Bigrams are w1w2 format two word phrases that their first word w1 are observed unigrams but the second word w2 may or may not has been seen after w1 in the sample dataset. Also Trigrams are w1w2w3 format three word phrases that their first two words w1w2 are observed bigrams in the sample but the third word w3 may or may not has been seen after w1w2 in the sample dataset.

For generating unseen bigrams and trigrams and their estimates, we used a discounting method to smooth the estimates for seen bigrams and trigrams. for discounting these estimates we applied Katz's Back-Off model.

### Logic 

## Referneces

https://www.youtube.com/watch?v=hsHw9F3UuAQ
https://www.youtube.com/watch?v=FedWcgXcp8w
https://www.youtube.com/watch?v=ruU_Y0iCMDA
https://www.youtube.com/watch?v=1vKNiuiB-6U
https://www.youtube.com/watch?v=d8nVJjlMOYo&index=16&list=PL6397E4B26D00A269
https://www.youtube.com/watch?v=XdjCCkFUBKU&list=PL6397E4B26D00A269&index=18
https://www.youtube.com/watch?v=wtB00EczoCM&index=19&list=PL6397E4B26D00A269
