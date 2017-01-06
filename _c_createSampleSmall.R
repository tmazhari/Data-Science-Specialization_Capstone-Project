library(readr)

sample <- read_lines("./data/sample/sampleFromLatinToASCII.txt", skip = 0, n_max = -1L, locale = default_locale(), na = character())
length(sample)

set.seed(123)
sampleSmall <- sample(sample, length(sample)/10, replace= FALSE)
length(sampleSmall)

write_lines(sampleSmall, "./data/sample/sampleSmall.txt", na = "NA", append = FALSE)
