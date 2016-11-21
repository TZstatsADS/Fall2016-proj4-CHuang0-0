# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Chenxi Huang
+ Contributor's UNI: ch3129

+ Projec title: Million Song
+ Project Goals: In this project we will explore the association between music features and lyrics words from a subset of songs in the million song data. Association rule mining has a wide range of applications that include marketing research (on co-purchasing), natural language processing, finance, public health and etc. Here the word "rules" is really as general as any interesting and meaningful patterns. Based on the association patterns identified, we will create lyric words recommender algorithms for a piece of music (using its music features).
+ Project summary: After intensive exploring, I tried out three methods. 1. Baseline, 2. Clustering and 3. Topic Modeling. Suprisingly, I conclude that the Baseline Model gives me a better results using Cross Validation. Please see the below for more details.


+ [**You can also see my project descriptions here as the RMD version.**](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/Project%204%20Description.Rmd)
+#################################### **My Thoughts** ####################################

+ **The Data**
The million song data is an array of matrices storing three groups of data: Analysis, Metadata and Musicbrainz. For the purpose of the evaluation, "- /metadata, -/musicbrainz, -/analysis/songs" will not be provided in the test data. 

+ **The Goal**
Our goal for this project is to make recommendations based on the features provided for each song, to determine which words are more likely to occur in this song and finally give ranks to all words in the Dictionary given. 

+ **What Problem?**
After observing the data, we can divided it into two parts: 1) the first part where we find relations among features; 2) the second part where we connect those features with distributions of words in lyr.data.

+ **Features**
(1) For each song, within each group, i.e. analysis, metadata and musicbrainz, we calculate the 13 statistics of each covariate, using the describe() in {Psych} package, which is more detailed than the summary() statistics. 
(2) For example, for the bar_confidence in the "Analysis" group, we can generate compherehensive stats like"vars, n, mean, sd, median, trimmed, mad, min, max, range, skew, kurtosis, se".
(3) Since the "- /metadata, -/musicbrainz, -/analysis/songs" will not be provided in the test data, I can hard see strong evidence suggesting that I should extract more than 13 subfeatures for each feature. Overall, for the Analysis group, deducting the "songs" part, I have generated 13 * (16-1) = **195 features**.
(4) Feature Selection: will be covered later. See *Details and Justifications*

+ **Reason & Procedures**
+ (1). Baseline Model. 
Baseline model is the simplest model to be compared with other more complex models. It is just determined by the frequencies of words in the lyr.Rdata file.

+ (2). Clustering.
Find clusters of features, determine to which cluster each test data belongs, and assign the frequencies of words in that cluster to that test data. Here, I tried K Means clustering. 

+ (3). Topic Modeling. 
Use Multinomial to see which topics the test data can be allocated to and their weights. Use the word distributions of the topics to determine which words are more prone to occur in the test set. 

+ **Details and Justifications**
+ (1). Dimension Reduction: PCA (considered but abandoned)
Since we have 2350 songs in the training set and 195 features, reducing the dimensionality of features is important in terms of shying from overfitting. Considering we are essentially doing unsupervised learning (labels of songs are noncomparable), so PCA seems like a simple and good way to go. 

However, PCA is reducing dimensionality but not feature selections. It provided PCA components but not a subset of variables that we would like to have. I abandoned this after I searched for and reading related documents for 2+ hours.

+ (2) Feature Selection: Random Forest(considered but abandoned)
Random Forest, along with other classification methods, is also one of my top choices to go. It selects features by their importance. 
However, it contains a lot of problems, such as the lack of labels and the different scales of my features. I also dropped this after more than hours of exploring. 



+ (3). Cross-Validation (define error = mean(predicted ranks) - mean(actual ranks in the test data))
Cross-Validation here is used to avoid overfitting, as well as an indirect criteria to determine which model is better. 
So far cross-validation has helped me to identify some good methods. But it is also limited by its time-consuming nature. Admittedly, running K=1 or 3 (mostly I ran K=3 because of the dimension of the dataset and the limited time) could lead to a totally different results as K=5.


+#################################### **My Findings** ####################################

+ **1.Baseline Rankings**

The baseline is determined just by the **frequencies** of words in the *lyr.Rdata*. 
The meaning of it is to:1) set up a lower bound by assuming all songs have the same word distributions, regardless of the music features;
2) for the benefits of more complicated models, we could compare them with the baseline for future improvement.

So the **Top 20 Words annd their Frequencies** in the Lyr.Rdata is:

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/fig1.png)

and after the Cross Validation, **the average error is 190.3119**, which is not bad {(define error = mean(predicted ranks) - mean(actual ranks in the test data))}.

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/baseline_cv1.png)

+ **2.Clustering (Unsupervised Learning)**

The clustering model is not hard to interpret. We train the lyr.Rdata to see how we can divide them into several groups.

+ KMeans Clustering
I started with Kmeans.

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/Rplot_clustering_K.jpeg)
 By observing the initial plot, I decided K can be between 6 to 10. 

Here are the table of # of K groups Vs the groups it signs to the testing data. 
![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/how%20to%20choose%20K.png)

As you can see, I used a "squeeze method" from math. By narrowing down the number of K, (for example, if K=5 is bad, and K=10 is good, then the optimal K lies in between [5,10]), I finally concluded that K=20 is probably the best way to divided this clusters. However, the results is still less than satisfactory, beacause there are only two clusters.

Using Cross Validation to assess this method. Here are the results:

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/K%20means%20results(CV).png)

As we can see from the results after 1,3,and 5-fold cross validation, the mean error is largely over 200 (recall I defined the error as the difference between the actual and predicted average ranks regarding related words, same calculating methods as required.) 

Therefore, I don't believe K Means is the best way to go for this problem. 



+################################ **What Went Wrong?** ################################

+ Feature Selection
(1) Admittedly, I chose a lot of features, 195 for each song. This could easily lead to overfitting. 
(2) The features I extracted are highly correalted and don't reveal too much information in the "metadata" and "musicbrainz" which we don't have information about in the testing set. But they are good resources of telling who has written these songs and what genres they are. Withouth any additional information to compensate this loss is a big pitfall of this project.
(3) There are lots of "NA" parts in the information. I had to either wipe out these information or fix them with zeros.

+ K Means
(1) K Means clutering are not doing a good job separating the songs. At most, I got 2-3 clusters which were basically equivalent to the baseline. 
(2) To perform K Means, I had to make sure that the means of each column for each feature is not infinite (same reason PCA is hard to perform). This forced me to wipe out some columns of features and may caused me to lose important features.



+################################ **Future Considerations and Concerns** ################################

+ 1. Features in Analysis$songs, Metadata and Musicbrainz.
Despite having subtrated the features in these groups, I didn't really use them when it comes to training the set. 
I do have a idea of finding out the correlation between these features so that even in the testing set we don't have such information, we can infer these features from the exisiting features we have in the testing set, through such relations. 

+ 2. PCA
I used PCA to trim down features. This is flawed in a way because the assumption is that the scales of the numbers don't matter. Although I did normalized my features, I reckon it could still be a problem.

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
