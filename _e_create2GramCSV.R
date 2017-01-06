# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Reset dataframe row index
rownames(dfbi) <- NULL

# Calculate discounted count
dfbi$disc_count <- dfbi$count - 0.7

# Calculate count of first word of a bigram 
# (eg. in bigram "of me", we extract the count of "of" from the dfuni dataframe.)    
getFWCount <- function(a) {
  word = a['word']
  firstWord = strsplit(word, "_")[[1]][1]
  firstWordCount <- dfuni[which(dfuni['word'] == firstWord), 2]
  return(firstWordCount[1])
}

# Store count of first word in a new column
dfbi$fw_count <- apply(dfbi, 1, function(y) getFWCount((y)))

# Calculate estimate of bigram and store it in new column
dfbi$estimate <- dfbi$disc_count / dfbi$fw_count

# Calculate the left over probability mass and store it in Unigram dataframe which is more correct
# Calculate the left over probability mass 
calcLeftoverProb <- function(a) {
  word = a['word']
  word <- paste("^", word, "_", sep="")
  rowsStartWithWord <- dfbi[grep(word, dfbi$word), ]
  return (1- sum(rowsStartWithWord$estimate))
}

# Calculate the leftover prob mass and store it in new column
dfuni$leftover_prob <- apply(dfuni, 1, function(y) calcLeftoverProb((y)))

# Write the final df to file
write.csv(dfbi, file = "2gram.csv", row.names = FALSE, na = "")
