install.packages("devtools")
devtools::install_github("cpsievert/LDAvisData")

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
