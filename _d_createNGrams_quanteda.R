# Loading Quanteda and create corpus with it
library(quanteda)

# mytf1 <- textfile("./data/sample/sample.txt")
mytf1 <- textfile("./data/sample/sampleSmall.txt")
myCorpus <- corpus(mytf1)
summary(myCorpus, 5)

# Create document-feature matrix
myDfm <- dfm(myCorpus)
topfeatures(myDfm, 20)

# create unigrams, bigrams and trigrams with dfm
uniDfm <- dfm(myCorpus, stem = FALSE, ngrams = 1, verbose = FALSE)
dfuni <- data.frame(word = features(uniDfm), count = colSums(uniDfm), row.names = NULL, stringsAsFactors = FALSE)
dfuni <- dfuni[order(-dfuni$count),]

biDfm <- dfm(myCorpus, stem = FALSE, ngrams = 2, verbose = FALSE)
dfbi <- data.frame(word = features(biDfm), count = colSums(biDfm), row.names = NULL, stringsAsFactors = FALSE)
dfbi <- dfbi[order(-dfbi$count),]

triDfm <- dfm(myCorpus, stem = FALSE, ngrams = 3, verbose = FALSE)
dftri <- data.frame(word = features(triDfm), count = colSums(triDfm), row.names = NULL, stringsAsFactors = FALSE)
dftri <- dftri[order(-dftri$count),]
