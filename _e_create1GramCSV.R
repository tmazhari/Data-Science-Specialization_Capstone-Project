# Change behavior of console session of whole numbers 
options("scipen" = 10)

# Reset dataframe row index
rownames(dfuni) <- NULL

# Calculate estimate of unigram and store it in new column
countSum <- sum(dfuni$count)
dfuni$estimate <- dfuni$count / countSum

# Round estimate column
dfuni$estimate <- round(dfuni$estimate, 8)

# Write the final df to file
write.csv(dfuni, file = "1gram.csv", row.names = FALSE, na = "")
