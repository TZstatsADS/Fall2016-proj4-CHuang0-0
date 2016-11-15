install.packages("devtools")
devtools::install_github("cpsievert/LDAvisData")
slam_url <- "http://cran.r-project.org"
install.packages("slam", repos = slam_url, type = "source")
install.packages("tm", repos="http://cran.rstudio.com/", dependencies=TRUE)

library(NLP)
library(tm)
library(lda)
library(LDAvis)
library(LDAvisData)
library(devtools)


library("LDAvisData")
str(AP)
data(reviews, package = "LDAvisData")

#Pre-processing
stop_words <- stopwords("SMART")

# pre-processing:
revie xws <- gsub("'", "", reviews)  # remove apostrophes
reviews <- gsub("[[:punct:]]", " ", reviews)  # replace punctuation with space
reviews <- gsub("[[:cntrl:]]", " ", reviews)  # replace control characters with space
reviews <- gsub("^[[:space:]]+", "", reviews) # remove whitespace at beginning of documents
reviews <- gsub("[[:space:]]+$", "", reviews) # remove whitespace at end of documents
reviews <- tolower(reviews)  # force to lowercase
reviews 


# tokenize on space and output as a list:
doc.list <- strsplit(reviews, "[[:space:]]+")
length(doc.list)       # Length: number of documents
length(doc.list[[1]])  # A splited string of words
doc.list[1]
doc.list[2]


# compute the table of terms:
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE) 
head(term.table)      # Just to give an idea of how it looks like
dim(term.table) # 39399
head(term.table,n=20) #head() returns the top 20 words

# remove terms that are stop words or occur fewer than 5 times:
del <- names(term.table) %in% stop_words | term.table < 5
term.table <- term.table[!del]
vocab <- names(term.table)           # Vocab: a vector of all words
