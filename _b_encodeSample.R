library(readr)
sample <- read_lines("./data/sample/sample.txt", skip = 0, n_max = -1L, locale = default_locale(), na = character())
length(sample)

# Remove non-ascii characters
sample <- iconv(sample, from = "latin1", to = "ASCII", sub = "")

write_lines(sample, "./data/sample/sampleFromLatinToASCII.txt", na = "NA", append = FALSE)
