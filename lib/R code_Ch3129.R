# Project 4: Words 4 Music
# Name: Chenxi Huang
# ch3129

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
###################################################################################################
library(rhdf5)
