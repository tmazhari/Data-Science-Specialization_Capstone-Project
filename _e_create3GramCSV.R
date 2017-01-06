# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Reset dataframe row index
rownames(dftri) <- NULL

# Calculate discounted count
dftri$disc_count <- dftri$count - 0.7

# Calculate count of first 2 words of a trigram 
# (eg. in trigrams "sell the house", "sell the boat", "sell the book" count of "sell the" from the dfbi dataframe.),    
calcF2WCount <- function(a) {
  word = a['word']
  first2Words = strsplit(word, "_")[[1]][1:2]
  first2Words = paste(first2Words, collapse = "_")
  f2wcount <- dfbi[which(dfbi['word'] == first2Words), 2]
  return (f2wcount[1])
}

# Store count of first two words in a new column
dftri$f2w_count <- apply(dftri, 1, function(y) calcF2WCount((y)))

# Calculate estimate of trigram and store it in new column
dftri$estimate <- dftri$disc_count / dftri$f2w_count

# Write the final df to file
write.csv(dftri, file = "3gram.csv", row.names = FALSE, na = "")

# Calculate the left over probability mass and store it in Bigram dataframe which is more correct
# Calculate the left over probability mass 
calcLeftoverProb <- function(a) {
  word = a['word']
  word <- paste("^", word, "_", sep="")
  rowsStartWithWord <- dftri[grep(word, dftri$word), ]
  return (1- sum(rowsStartWithWord$estimate))
}

# Calculate the leftover prob mass and store it in new column
dfbi$leftover_prob <- apply(dfbi, 1, function(y) calcLeftoverProb((y)))

write.csv(dfbi, file = "2gram-new.csv", row.names = FALSE, na = "")
