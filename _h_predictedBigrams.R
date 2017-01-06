unidf <- read.csv(file="beta_1gram.csv", header=TRUE, sep=",")
unidf$word <- as.character(unidf$word)
unidf <- unidf[, !(colnames(unidf) %in% c("count", "leftover_prob","beta"))]

seenbi <- read.csv(file="beta_2gram.csv", header=TRUE, sep=",")
seenbi$word <- as.character(seenbi$word)
seenbi <- seenbi[, !(colnames(seenbi) %in% c("count","disc_count","fw_count","leftover_prob","beta"))]

unseenbi <- read.csv(file="unseen_2gram.csv", header=TRUE, sep=",")
unseenbi$word <- as.character(unseenbi$word)

allbi <- rbind(seenbi, unseenbi)
allbi <- allbi[complete.cases(allbi),]
allbi <- allbi[order(-allbi$estimate),]

predictBigrams <- function(a) {
  word = a['word']
  searchkey <- paste("^", word, "_", sep="")
  
  a <- allbi[grep(searchkey, allbi$word), ]
  
  topthree <- a[1:3,]
  topthree$word <- gsub(".*_","",topthree$word)
  
  row <- data.frame(word=word, 
                    p1=topthree[1,1], p1_estimate=topthree[1,2], 
                    p2=topthree[2,1], p2_estimate=topthree[2,2], 
                    p3=topthree[3,1], p3_estimate=topthree[3,2])
  
  return(row)
}

predbi <- do.call(rbind, apply(unidf, 1, function(y) predictBigrams((y))))
i <- sapply(predbi, is.factor)
predbi[i] <- lapply(predbi[i], as.character)
predbi <- predbi[complete.cases(predbi),]

write.csv(predbi, file = "predicted_2gram.csv", row.names = FALSE, na = "")
