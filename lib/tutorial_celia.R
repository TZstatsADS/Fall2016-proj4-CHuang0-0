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
vocab
length
length(vocab) # length=14263
term.table 
dim(term.table) #dim=14263

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index-1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)
dim(documents)
documents[1] 
names(documents[1])
class(documents[1])
dim(documents[1])
doc.list_1=doc.list[1]
doc.list_1
doc.list_1=as.array(doc.list_1)
class(doc.list_1);length(doc.list_1)
vocab[9] 

# DOCUMENTS is basically a large list of all docoments we have, each entry is a 2*length(document_i) matrix, recording which word in the VOCAB appeared in this document.

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents (2,000)
D 
W <- length(vocab)  # number of terms in the vocab (14,568)
W
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
doc.length
N <- sum(doc.length)  # total number of tokens in the data (546,827)
N #545313
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, 
term.frequency

# MCMC and model tuning parameters:
K <- 20
G <- 5000
alpha <- 0.02
eta <- 0.02

# Fit the model:
library(lda)
set.seed(357)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  # about 24 minutes on laptop
