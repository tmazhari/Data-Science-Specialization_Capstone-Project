# Data Science Spacialization - Capstone Project

This repository contains my submissions for Capstone Project of Data Science Specialization offered by Johns Hopkins University through coursera.com.

In this project I have created a Shiny application called "Smart Keyboard". The Smart Keyboard lets user to enter a text, processes it in real time and presents three options for what the next word might be. The source code for this application can be found in this repository. The Smart Keyboard Shiny application can be accessed at:
https://tmazhari.shinyapps.io/Smart-Keyboard

## Background

Technologies that are capable of inferring meaning and intent from information are very intriguing. One of this type of technologies is a system that can transform a corpus of text into a text prediction system. Tha aim of this project is to build a predictive system, a prdictive text analytics system that develops a predictive model of text out of large sets of unstuctured databases of english language text. Building such system requires consucting analysis, cleaning, tokenization of text. 

## Data

The training data that we use for building our predictive model can be found [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). The data is from a corpus called HC Corpora [www.corpora.heliohost.org](www.corpora.heliohost.org). The data consists of multiple files in four different languages. We use files in English locale in this project. These files are shown below with some statistics about them.

Blogs | News | Twitter
--- | --- | ---
205 MB | 201 MB | 163 MB
899288 Lines | 1010242 Lines | 2360148 Lines


### Sampling Data

To build our model, we created a sample corpus by reading in randomly selected lines of each dataset blogs, news and twitter and combining them. We created the sample corpus by sampling 1/1000 lines of main corpus. From now on we explore this new dataset that is a representative sample of our original datasets. Here are some statistics about the sample corpus:

Lines | Sentences | Tokens
--- | --- | --- | ---
4269 | 6468 | 122773

## Problem

Predicting the next word problem is a **Markov Model**. Markov models are a class of probabilistic models that assume we can predict the probability of some future unit without looking too far into the past. In other words, this model assumes that predicting next word only depends on a few number of preceding words and not the whole text. This is why we generate N-Grams to use them to predict the next word. We simply look at the preceding 1, 2, 3 or ... words and predict the next word based on the probability of these preceding words and not the whole text. In the application we only look at the preceding 2 words of the input to guess the next word.

## Prediction Model 

This application uses three datasets to function: Unigrams, Bigrams and Trigrams. The general idea that our prediction model uses is as follows
  1. Extract last two words from the input text and look up Trigrams for records that have highest probabilities whose first two words match the two words we extracted. If found return top three results. 
  2. If no results were found in Trigrams, look up Bigrams for records with highest probabilites whose first word match the last word we extracted. If found, return top three results.
  3. If no results were found in Bigrams, look up Unigrams and return words with top three words with highest probabilites.

Above is the general plan that we are going to follow. But there are some facts that we need to consider to build our model. We need to better define the term "probability" of a word.  Is probability the frequency of a word, its estimate, maximum likelihood estimate, or ...? Also we should take into account unseen combinations of words that have not been observed in the corpus. These word combinations are called unseen N-Grams.

### N-Grams

After creating document-feature matrix from corpus, we use **quanteda** package to extract N-Grams from the dfm, Unigrams, Bigrams and Trigrams. Unigrams are the unique single words *w1* that have been observed in the sample dataset, Bigrams are *w1w2* format two word phrases that have been observed in the sample dataset and Trigrams are *w1w2w3* format three word phrases that have been observed in the sample dataset. Below are the number of observations in each N-Gram dataframe:

Unigrams | Bigrams | Trigrams
--- | --- | ---
15456 | 69758 | 96678

Now imagine if word "the" in our entire coprus has been seen 11 times and following words as shown below:

word| count
--- | ---
the | 11
the dog | 5
the girl | 4
the man | 2

We can say that the probability of observing "dog" after word "the" is 5/11. This probability is called Maximum Likelihood Estimate. MLEs are almost always high. MLEs are computed using only observed N-Gram counts. In other words we have calculated the probability of "dog" after "the" based on only the words that we have seen after "the" which are "dog", "girl" and "man". So what about the words that have not appeared after "the" in this corpus but in real language can appear after "the"? 

In order to solve this issue, we should calculate reasonable estimate of probabilities for unobserved N-Grams. This is where **Smoothing** comes in. In this scenario,  unobserved N-Grams are bigrams that their first word *w1* is going to be "the" and their second word *w2* is going to be all unigrams in the corpus that have not appeared after "the" in the corpus.       


### Smoothing

For Smoothing we have used **Katz's back-off** model. Katz's back-off is a model that estimates the conditional probability of a word given its history in the N-Gram. Meaning we estimate the probabilities of unseen Trigrams and Bigrams using this model. This model is a discounting technique that takes some amount of probabilites for seen N-Grams and distributes it among unseen N-Grams. We do discounting for Bigrams and Trigrams. 

To be more specific,  we discount at Trigram level to estimate probabilities of unobserved Trigrams by taking that discounted mass and distributing it according to the Bigram frequencies. Likewise, at Bigram level, we discount again and use it to estimate unobserved Bigrams by using the Unigram frequencies. In this project, we have used an absolute discount value of 0.7 at the Bigram and Trigram level.

For generating unseen bigrams and trigrams and their estimates, we used a discounting method to smooth the estimates for seen bigrams and trigrams. for discounting these estimates we applied Katz's Back-Off model.

### Logic 

Based on Katz's Back-Off model we can calculate estimates for both seen and unseen N-Grams. Below is the model for Bigrams:

![alt text](https://github.com/tmazhari/Data-Science-Specialization_Capstone-Project/blob/master/figure/KatzBigramModel.PNG)
  
As shown above, calculating estimates for seen N-Grams are relatively easy.

For example for seen Bigrams the estimate is:
`dicounted count(*w1w2*) / count(*w1*)`

Calculating estimates for unseen Bigrams requires a little bit more calculations. However based on the Katz's Back-Off model it can be concluded that the estimate for unseen bigram *w1w2* is:
`alpha(*w1*) * qML(*w2*) / denominator` 
The interesting point is denominator is only dependent on the set of words that have been seen before *w2* in the corpus. Since we already know this set, so denominator can be calculated in advance and kept stored at Unigram level. 

Therefore, for all unigrams we can calculate alpha and this denominator value. Let's calculate the value of `alpha(*w1*) / denominator` for each unigram and call it *beta* and store it in Unigrams.

Similarly how we computed *beta* for Unigrams, we can compute this value for Bigrams and store it at Bigram level. 

![alt text](https://github.com/tmazhari/Data-Science-Specialization_Capstone-Project/blob/master/figure/KatzTrigramModel.PNG)

So based on Bigrams we can calculate Unigram *beta*s and based on Trigrams we can calculate Bigram *beta*s.   

After calculating *beta*s , we can calculate the estimate for unseen N-Grams. So we generate unseen Bigrams out of seen Unigrams and keep only top three unseen Bigrams with highest estimates. We use same approach to generate unseen Trigrams.

Finally we merged seen and unseen Bigrams as well as Trigrams. For merged Bigrams we kept only the ones with unique first words with highest estimates. For merged Trigrams we kept only the ones with unique first two words with highest estimates. Now our data is ready for predicting the next word.

Now, Unigrams are the unique single words that were observed in the sample dataset with their estimates. Bigrams are w1w2 format two word phrases that their first word w1 are observed unigrams but the second word w2 may or may not has been seen after w1 in the sample dataset. Also Trigrams are w1w2w3 format three word phrases that their first two words w1w2 are observed bigrams in the sample but the third word w3 may or may not has been seen after w1w2 in the sample dataset.

*A sample unigram "on"*

word | count | leftover_prob | estimate | beta
--- | --- | --- | --- | ---
on | 869 | 0.2883774 | 0.0085518 | 0.6335239

*Unseen words after "on"*

word | count | leftover_prob | estimate | beta
--- | --- | --- | --- | ---
 of | 1984 |     0.3217742 | 0.01952448 | 0.5935307
 on |  869 |    0.2883774 | 0.00855180 | 0.6335239
 was |  638  |    0.3873041 | 0.00627854  | 0.6117458
are |  531 |    0.3770245 | 0.00522556 | 0.6875999
be |  527  |    0.4104364 | 0.00518619 | 0.6752791
have |   518 |     0.2729730|  0.00509762 | 0.6935438

*Unseen bigrams starting with "on"*

name | estimate
--- | ---
on_of | 0.01952448
on_on | 0.00855180
on_was | 0.00627854

## Referneces

1. Data Science Specialization - Data Science Capstone - Discussion Forums
2. http://files.asimihsan.com/courses/nlp-coursera-2013/notes/nlp.html#discounting-methods-part-1
3. https://www.youtube.com/watch?v=hsHw9F3UuAQ
4. https://www.youtube.com/watch?v=FedWcgXcp8w
5. https://www.youtube.com/watch?v=ruU_Y0iCMDA
6. https://www.youtube.com/watch?v=1vKNiuiB-6U
7. https://www.youtube.com/watch?v=d8nVJjlMOYo&index=16&list=PL6397E4B26D00A269
8. https://www.youtube.com/watch?v=XdjCCkFUBKU&list=PL6397E4B26D00A269&index=18
9. https://lagunita.stanford.edu/c4x/Engineering/CS-224N/asset/slp4.pdf
10. www.cs.columbia.edu/~kathy/NLP/ClassSlides/Class3-ngrams09/ngrams.pdf
11. http://www.speech.sri.com/projects/srilm/manpages/ngram-discount.7.html
12. https://en.m.wikipedia.org/wiki/Katz%27s_back-off_model
13. https://en.wikipedia.org/wiki/Markov_chain
14. https://en.wikipedia.org/wiki/Markov_model
15. https://en.m.wikipedia.org/wiki/N-gram

### Other Useful Resources
16. https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html
17. https://www.r-bloggers.com/text-mining-the-complete-works-of-william-shakespeare/
18. https://www.youtube.com/watch?v=wtB00EczoCM&index=19&list=PL6397E4B26D00A269
