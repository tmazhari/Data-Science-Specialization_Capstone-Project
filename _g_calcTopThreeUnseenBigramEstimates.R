# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Read unigrams
unidf <- read.csv(file="beta_1gram.csv", header=TRUE, sep=",")
unidf$word <- as.character(unidf$word)
# Calculate delta of input unigram
# delta is alpha (leftover_prob) / beta
unidf$delta <- unidf$leftover_prob / unidf$beta

# Read bigrams
bidf <- read.csv(file="2gram.csv", header=TRUE, sep=",")
bidf$word <- as.character(bidf$word)

# Create empty dataframe for top three unseen bigrams
unseenBidf <- data.frame(name=character(), estimate=numeric())

# Create top three unseen bigrams     
createTopThreeUnseenBigrams <- function(a) {
  word = a['word']
  searchkey <- paste("^", word, "_", sep="")
  
  # find delta for input unigram
  delta <- unidf[which(unidf$word == word), 6]
  
  # Find bigrams that start with input_ and extract word column only
  a <- bidf[grep(searchkey, bidf$word), 1]
  # from above bigrams, extract second word which are seen unigrams after input
  b <- gsub(".*_","",a)
  # from unidf find rows that are seen unigrams after input
  seendf <- unidf[unidf$word %in% b,]
  
  # from unidf find rows that are unseen unigrams after input
  unseendf <- unidf[ !(unidf$word %in% seendf$word), ]
  unseendf <- unseendf[order(-unseendf$estimate),]
  
  topThreeUnseen <- unseendf[1:3,]
  
  row <- data.frame(word=paste(word, "_", topThreeUnseen$word, sep=""), estimate=delta * topThreeUnseen$estimate)
  return(row)
}

unseenBidf <- do.call(rbind, apply(unidf, 1, function(y) createTopThreeUnseenBigrams((y))))
i <- sapply(unseenBidf, is.factor)
unseenBidf[i] <- lapply(unseenBidf[i], as.character)

# Round estimate column
unseenBidf$estimate <- round(unseenBidf$estimate, 8)

# Write the final df to file
write.csv(unseenBidf, file = "unseen_2gram.csv", row.names = FALSE, na = "")
