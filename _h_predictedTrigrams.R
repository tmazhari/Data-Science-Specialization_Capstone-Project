bidf <- read.csv(file="beta_2gram.csv", header=TRUE, sep=",")
bidf$word <- as.character(bidf$word)
bidf <- seenbi[, !(colnames(seenbi) %in% c("count","disc_count","fw_count","leftover_prob","beta"))]

seentri <- read.csv(file="3gram.csv", header=TRUE, sep=",")
seentri$word <- as.character(seentri$word)
seentri <- seentri[, !(colnames(seentri) %in% c("count","disc_count","f2w_count"))]

unseentri <- read.csv(file="unseen_3gram.csv", header=TRUE, sep=",")
unseentri$word <- as.character(unseentri$word)

alltri <- rbind(seentri, unseentri)
alltri <- alltri[complete.cases(alltri),]
alltri <- alltri[order(-alltri$estimate),]

predictTrigrams <- function(a) {
  word = a['word']
  searchkey <- paste("^", word, "_", sep="")
  
  a <- alltri[grep(searchkey, alltri$word), ]
  
  topthree <- a[1:3,]
  topthree$word <- gsub(".*_*_","",topthree$word)
  
  row <- data.frame(word=word, 
                    p1=topthree[1,1], p1_estimate=topthree[1,2], 
                    p2=topthree[2,1], p2_estimate=topthree[2,2], 
                    p3=topthree[3,1], p3_estimate=topthree[3,2])
  
  return(row)
}

predtri <- do.call(rbind, apply(bidf, 1, function(y) predictTrigrams((y))))
i <- sapply(predtri, is.factor)
predtri[i] <- lapply(predtri[i], as.character)
predtri <- predtri[complete.cases(predtri),]

write.csv(predtri, file = "predicted_3gram.csv", row.names = FALSE, na = "")
