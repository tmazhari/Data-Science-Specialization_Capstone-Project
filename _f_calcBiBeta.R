# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Read unigrams
unidf <- read.csv(file="beta_1gram.csv", header=TRUE, sep=",")
unidf$word <- as.character(unidf$word)
unidf$delta <- unidf$leftover_prob / unidf$beta
uni <- unidf$word

# Read bigrams
bidf <- read.csv(file="2gram.csv", header=TRUE, sep=",")
bidf$word <- as.character(bidf$word)

# Read bigrams
tridf <- read.csv(file="3gram.csv", header=TRUE, sep=",")
tridf$word <- as.character(tridf$word)

totalUnidfEstimate <- sum(unidf$estimate)

# Get beta for a bigram input 
# Beta is the sum of estimates of seen and unseen bigrams after input
# Ex. input can be "sell the" and seen and unseen bigrams can be "the buy", "the house", "the the", ...
# Note that "sell the w3" trigams are unseen but "the w3" bigrams may be seen or unseen
calcBigramBeta <- function(a) {
  word = a['word']
  
  # extract second word ex. "the" from "sell the"
  w2 <- strsplit(word, "_")[[1]][2]
  delta_w2 <- unidf[which(unidf$word == w2), 6]
  
  # get all unseen unigrams after bigram input. Ex. unseen unigrams after "to_be"
  searchkey <- paste("^", word, "_", sep="")
  a <- tridf[grep(searchkey, tridf$word), 1]
  seenuni <- gsub(".*_*_","",a)
  mask <- (uni %in% seenuni)
  # b is all unseen unigrams after bigram input. Ex. unseen unigrams after "to_be"
  # This is set B for "to_be"
  b <- uni[!mask]
  
  # should divide b into to groups. First group is seen unigrams after second word. Ex. seen unigrams after "be"
  searchkey2 <- paste("^", w2, "_", sep="")
  c <- bidf[grep(searchkey2, bidf$word), 1]
  # d is unigrams seen after w2 ex. "be"
  d <- gsub(".*_","",c)
  mask <- (b %in% d)
  # b1 is bigrams that start with w2 ex. "be" and are in b 
  # b1 <- b[mask]
  mask2 <- (d %in% b)
  # e is unigrams seen after w2 ex. "be" and are in b 
  e <- c[mask2]
  df <- bidf[bidf$word %in% e,]
  sumestimate_b1 <- sum(df$estimate)
  
  # second group is unseen unigrams after second word. Ex. unseen unigrams after "be"
  # b2 is unigrams that are in b but unseen after "be" 
  b2 <- b[!mask]
  if (length(b2) > 0) {
    df <- unidf[unidf$word %in% b2,];
    sumestimate_b2 <- sum(df$estimate);
  } else {
    sumestimate_b2 <- 0;
  }
  
  beta <- delta_w2 * sumestimate_b2 + sumestimate_b1
  
  return(beta[1])
}

# Calculate beta for unigrams
bidf$beta <- apply(bidf, 1, function(y) calcBigramBeta((y)))

# Write the final df to file
write.csv(bidf, file = "beta_2gram.csv", row.names = FALSE, na = "")
