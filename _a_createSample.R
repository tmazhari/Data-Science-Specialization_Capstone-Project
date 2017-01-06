# Read datasets
library(readr)

blogs <- read_lines("./data/final/en_US/en_US.blogs.txt", skip = 0, n_max = -1L, locale = default_locale(), na = character())
blogsLength <- length(blogs)
blogsLength

news <- read_lines("./data/final/en_US/en_US.news.txt", skip = 0, n_max = -1L, locale = default_locale(), na = character())
newsLength <- length(news)
newsLength

twitter <- read_lines("./data/final/en_US/en_US.twitter.txt", skip = 0, n_max = -1L, locale = default_locale(), na = character())
twitterLength <- length(twitter)
twitterLength

# Print number of words
# TODO
# news <- system('wc -lwm ./data/final/en_US/en_US.news.txt',intern = TRUE)
# news_n <- as.numeric(grep('[0-9]', unlist(strsplit(news," ")), value = TRUE))

# Create sample dataset
library(LaF)
set.seed(123)
blogsSample <- sample_lines("./data/final/en_US/en_US.blogs.txt", blogsLength/100, nlines = blogsLength)
length(blogsSample)

set.seed(123)
newsSample <- sample_lines("./data/final/en_US/en_US.news.txt", newsLength/100, nlines = newsLength)
length(newsSample)

set.seed(123)
twitterSample <- sample_lines("./data/final/en_US/en_US.twitter.txt", twitterLength/100, nlines = twitterLength)
length(twitterSample)

sample <- c(blogsSample, newsSample, twitterSample)
write_lines(sample, "./data/sample/sample.txt", na = "NA", append = FALSE)

# Remove objects from environment
rm(blogs, news, twitter) 
