# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Chenxi Huang
+ Contributor's UNI: ch3129

+ Projec title: Million Song
+ Project summary: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


+#################################### **My Thoughts** ####################################

+ **1.The Data**
The million song data is an array of matrices storing three groups of data: Analysis, Metadata and Musicbrainz. For the purpose of the evaluation, "- /metadata, -/musicbrainz, -/analysis/songs" will not be provided in the test data. 

+ **The Goal**
Our goal for this project is to make recommendations based on the features provided for each song, to determine which words are more likely to occur in this song and finally give ranks to all words in the Dictionary given. 

+ **What Problem?**
After observing the data, we can divided it into two parts: 1) the first part where we find relations among features; 2) the second part where we connect those features with distributions of words in lyr.data.

+ **Features**
(1) For each song, within each group, i.e. analysis, metadata and musicbrainz, we calculate the 13 statistics of each covariate, using the describe() in {Psych} package, which is more detailed than the summary() statistics. 
(2) For example, for the bar_confidence in the "Analysis" group, we can generate compherehensive stats like"vars, n, mean, sd, median, trimmed, mad, min, max, range, skew, kurtosis, se".
(3) Since the "- /metadata, -/musicbrainz, -/analysis/songs" will not be provided in the test data, I can hard see strong evidence suggesting that I should extract more than 13 subfeatures for each feature. (4) Overall, for the Analysis group, deducting the "songs" part, I have generated 13 * (16-1) = 195 features.

+ **Reason & Procedures**
+ (1). Baseline Model. 
Baseline model is the simplest model to be compared with other more complex models.

+ (2). Clustering.
Find clusters of features, determine to which cluster each test data belongs, and assign the frequencies of words in that cluster to that test data.

+ (3). Topic Modeling. 
Use Multinomial to see which topics the test data can be allocated to and their weights. Use the word distributions of the topics to determine which words are more prone to occur in the test set. 

+ **Details and Justifications**
+ (1). Trimming Down Features: PCA
Since we have 2350 songs in the training set and 195 features, reducing the dimensionality of features is important in terms of shying from overfitting. 
Considering we are essentially doing unsupervised learning (labels of songs are noncomparable), so PCA seems like a simple and good way to go. 

+ 2. Cross-Validation (# error = mean(predicted ranks) - mean(actual ranks in the test data))
Cross-Validation here is used to avoid overfitting, as well as an indirect criteria to determine which model is better. 


+#################################### **My Findings** ####################################

+ **1.Baseline Rankings**

The baseline is determined just by the **frequencies** of words in the *lyr.Rdata*. 
The meaning of it is to:1) set up a lower bound by assuming all songs have the same word distributions, regardless of the music features;
2) for the benefits of more complicated models, we could compare them with the baseline for future improvement.

So the **Top 20 Words annd their Frequencies** in the Lyr.Rdata is:

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/fig1.png)

and after the Cross Validation, **the average error is 190.3119**, which is not bad.

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/baseline_cv1.png)







+#################################### **Future Considerations** ####################################

+ 1. Features in Analysis$songs, Metadata and Musicbrainz.
Despite having subtrated the features in these groups, I didn't really use them when it comes to training the set. 
I do have a idea of finding out the correlation between these features so that even in the testing set we don't have such information, we can infer these features from the exisiting features we have in the testing set, through such relations. 


Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
