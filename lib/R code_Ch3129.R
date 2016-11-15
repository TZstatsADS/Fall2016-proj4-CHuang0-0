# Project 4: Words 4 Music
# Name: Chenxi Huang
# ch3129

# set the workng directory 
setwd("C:/Users/ch3129/Desktop/Project 4")
###################################################################################################
# Intro To Dataset
#Common_id.txt: ids for the songs that have both lyrics and sound analysis information. 2350 in total;
#lyr.Rdata: dim: 2350*5001. b-o-w for 2350 songs stored in a dataframe;
#data.zip: .h5 files for the 2350 songs;
#msm_dataset_train.txt original format of the lyrics data
###################################################################################################
# Download Packages
#Reading hdf5 file
#Download rhdf5 library
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
# install missing packages
list.of.packages <- c("NLP", "tm","lda","LDAvis","slam")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
###################################################################################################
# Load Packages
library(rhdf5)

# Topic Modeling
library(NLP)
library(tm);library(slam)# slam not available for R version 3.2.3
library(lda)
library(LDAvis)

###################################################################################################
# The structure of a song
#h5ls("/Users/Bianbian/Documents/Courses/2016Spring/4249_Applied Data Science/Proj5/MillionSongSubset/data/A/A/A/TRAAAAW128F429D538.h5")
read1=h5ls('C:/Users/ch3129/Desktop/Project 4/Project4_data/data/A/A/A/TRAAABD128F429CF47.h5') #try out an example
dim(read1);summary(read1);read1 #dim=27 by 5
# the data are stored in three groups, analysis, metadata and musicbrainz
# Get all data using h5read
sound=h5read("C:/Users/ch3129/Desktop/Project 4/Project4_data/data/A/A/A/TRAAABD128F429CF47.h5", "/analysis")
meta=h5read("C:/Users/ch3129/Desktop/Project 4/Project4_data/data/A/A/A/TRAAABD128F429CF47.h5", "/metadata")
musicbrainz=h5read("C:/Users/ch3129/Desktop/Project 4/Project4_data/data/A/A/A/TRAAABD128F429CF47.h5", "/musicbrainz")
sound
summary(sound)
meta
summary(meta)
musicbrainz
summary(musicbrainz)
# for example
sound$segments_confidence;dim(sound$segments_confidence);class(sound$segments_confidence)  
###################################################################################################

