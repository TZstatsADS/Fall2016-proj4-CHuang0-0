install.packages("devtools")
devtools::install_github("cpsievert/LDAvisData")
slam_url <- "http://cran.r-project.org"
install.packages("slam", repos = slam_url, type = "source")
install.packages("tm", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("lda")
install.packages("NLP")
install.packages("LDAvis")
install.packages('servr')

library(NLP)
library(tm)
library(lda)
library(LDAvis)
library(LDAvisData)
library(devtools)
library(servr)

data(reviews, package = "LDAvisData")

#Pre-processing
stop_words <- stopwords("SMART")

# pre-processing:
reviews <- gsub("'", "", reviews)  # remove apostrophes
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
length(vocab) # length=14567
term.table 
dim(term.table) #dim=14567


# now put the documents into the format required by the lda package:
#get.terms <- function(x) {
 # index <- match(x, vocab)
  #index <- index[!is.na(index)]
#  rbind(as.integer(index-1), as.integer(rep(1, length(index))))
# }

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
length(doc.list_1)
doc.list_1=unlist(doc.list[1])
length(doc.list_1)
document_1=matrix(unlist(documents[1]), nrow=2)
class(document_1);dim(document_1);document_1[1,]
index1=document_1[1,]
index2=match(doc.list_1,vocab)
index1==index2[!is.na(index2)] #there are words not in the vocaburary 

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
# celia: 20.17273 mins

fit
names(fit) #"assignments"      "topics"           "topic_sums"       "document_sums"    "document_expects" NA                 NA                 NA                 NA                 "log.likelihoods" 
dim(fit)
class(fit)
fit$assignments #each word's topic number
range(unlist(fit$assignments)) # 0 to 19
fitassig1=unlist(fit$assignments[1]);length(unlist(fitassig1))
length(which(fitassig1==0))
which(vocab=="film")
documents

fit$topics
class(fit$topics) 
dim(fit$topics)# 20 by 14567
fit$topics[1,1:10] 
fit$topics[2,1:10]
st=sort(fit$topics[1,], decreasing=T)
st[1:20]
# different topics have different rankings for each word

fit$topic_sums
fit$topic_sums=unlist(fit$topic_sums)
length(fit$topic_sums);sum(fit$topic_sums) #546677
fit$topic_sums[1]==sum(fit$topics[1,]) #TRUE
# so topic sums are just adding up all the rankings of words in each topics

fit$document_sums
class(fit$document_sums);dim(fit$document_sums) # 20 by 2000, there are 20 topics and 2000 documents
sum(fit$document_sums[,1]) # sum of each column is the sum of each document is the doc.length of this document
fit$document_sums[,1] 
length(which(fitassig1==0)) == fit$document_sums[1,1] # both 31, TRUE
# guess each number in each entry is number of words that belong to that topic

fit$document_expects
class(fit$document_expects);dim(fit$document_expects) # 20 by 2000
fit$document_expects[,1]
sum(fit$document_expects[,1]) #1560000
sum(fit$document_expects[,2]) #1440000
sum(fit$document_expects[1,]) #269043633


fit$log.likelihoods
dim(fit$log.likelihoods) # 2 by 5000


#Visualization
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

MovieReviews <- list(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = vocab,
                     term.frequency = term.frequency)
library(servr)
# create the JSON object to feed the visualization:
json <- createJSON(phi = MovieReviews$phi, 
                   theta = MovieReviews$theta, 
                   doc.length = MovieReviews$doc.length, 
                   vocab = MovieReviews$vocab, 
                   term.frequency = MovieReviews$term.frequency)

serVis(json, out.dir = 'vissample', open.browser = T)

