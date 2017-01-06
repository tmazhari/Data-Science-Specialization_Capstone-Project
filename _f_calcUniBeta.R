# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Read unigrams
unidf <- read.csv(file="1gram.csv", header=TRUE, sep=",")
unidf$word <- as.character(unidf$word)

# Read bigrams
bidf <- read.csv(file="2gram.csv", header=TRUE, sep=",")
bidf$word <- as.character(bidf$word)

totalUnidfEstimate <- sum(unidf$estimate)

# Get beta for a unigram input 
# Beta is the sum of estimates of unseen unigrams after input     
calcUnigramBeta <- function(a) {
  word = a['word']
  word <- paste("^", word, "_", sep="")
  
  # Find bigrams that start with input_ and extract word column only
  a <- bidf[grep(word, bidf$word), 1]
  
  # from above bigrams, extract second word which are seen unigrams after input
  b <- gsub(".*_","",a)
  
  # from unidf find rows that are seen unigrams after input
  df <- unidf[unidf$word %in% b,]
  
  # calculate beta which is sum of estimates for unseen unigrams after input
  # beta = sum of all unigram estimates - sum of estimates for seen estimates 
  beta <- totalUnidfEstimate - sum(df$estimate)
  
  return(beta)
}

# Calculate beta for unigrams
unidf$beta <- apply(unidf, 1, function(y) calcUnigramBeta((y)))

# Write the final df to file
write.csv(unidf, file = "beta_1gram.csv", row.names = FALSE, na = "")