# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Read unigrams
unidf <- read.csv(file="beta_1gram.csv", header=TRUE, sep=",")
unidf$word <- as.character(unidf$word)

# Read bigrams
bidf <- read.csv(file="beta_2gram.csv", header=TRUE, sep=",")
bidf$word <- as.character(bidf$word)
# Calculate delta of bigrams
# delta is alpha (leftover_prob) / beta
bidf$delta <- bidf$leftover_prob / bidf$beta

# Read bigrams
tridf <- read.csv(file="3gram.csv", header=TRUE, sep=",")
tridf$word <- as.character(tridf$word)

# Create empty dataframe for top three unseen bigrams
unseenTridf <- data.frame(word=character(), estimate=numeric())

# Create top three unseen bigrams     
createTopThreeUnseenTrigrams <- function(a) {
  word = a['word']
  searchkey <- paste("^", word, "_", sep="")
  
  # find delta for input bigram
  delta <- bidf[which(bidf$word == word), 8]
  
  # Find trigrams that start with bigram input w1w2 and extract word column only
  a <- tridf[grep(searchkey, tridf$word), 1]
  # from above trigrams, extract w2w3 bigrams
  # these are w2w3 bigrams starting with w2 that the w3s are seen unigrams after input bigram w1w2
  # ex. Based on "to_be_w3" trigrams, "be_at" "be_ready" ... bigrams that start with "be" as "be_w3"   
  b <- gsub("^(.*?)_","",a)
  
  # find all bigrams that start with w2 ex. "be" from "to_be" input
  w2 <- strsplit(word, "_")[[1]][2]
  searchkey2 <- paste("^", w2, "_", sep="")
  c <- bidf[grep(searchkey2, bidf$word), 1]
  
  # d is all bigrams that start with w2 ex. "be" which the w3 in d is unseen in w1w2w3 trigrams "to_be_w3" 
  mask <- (c %in% b)
  d <- c[!mask]
  
  # find above rows in bigram dataframe 
  unseendf <- bidf[bidf$word %in% d,]
  unseendf <- unseendf[order(-unseendf$estimate),]

  topThreeUnseen <- unseendf[1:3,]
  
  w3 <- gsub(".*_","",topThreeUnseen$word)
  row <- data.frame(word=paste(word, "_", w3, sep=""), estimate=delta * topThreeUnseen$estimate)
  return(row)
}

# create unseen bigram dataframe
# unseenTridf <- apply(unidf, 1, function(y) createTopThreeUnseenBigrams((y)))

unseenTridf <- do.call(rbind, apply(bidf, 1, function(y) createTopThreeUnseenTrigrams((y))))
i <- sapply(unseenTridf, is.factor)
unseenTridf[i] <- lapply(unseenTridf[i], as.character)

# Round estimate column
unseenTridf$estimate <- round(unseenTridf$estimate, 8)

# Write the final df to file
write.csv(unseenTridf, file = "unseen_3gram.csv", row.names = FALSE, na = "")
