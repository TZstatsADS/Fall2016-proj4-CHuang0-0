# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+############################### **Project Introduction** ##############################
+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Chenxi Huang
+ Contributor's UNI: ch3129

+ Projec title: Million Song
+ Project Goals: In this project we will explore the association between music features and lyrics words from a subset of songs in the million song data. Association rule mining has a wide range of applications that include marketing research (on co-purchasing), natural language processing, finance, public health and etc. Here the word "rules" is really as general as any interesting and meaningful patterns. Based on the association patterns identified, we will create lyric words recommender algorithms for a piece of music (using its music features).
+ Project summary: After intensive exploring, I tried out three methods. 1. Baseline, 2. Clustering and 3. Topic Modeling. **Suprisingly, I conclude that the Baseline Model gives me a better results using Cross Validation**. Please see the below for more details.



+#################################### **My Thoughts** ####################################

+ **The Data**
The million song data is an array of matrices storing three groups of data: Analysis, Metadata and Musicbrainz. For the purpose of the evaluation, "- /metadata, -/musicbrainz, -/analysis/songs" will not be provided in the test data. 

+ **The Goal**
Our goal for this project is to make recommendations based on the features provided for each song, to determine which words are more likely to occur in this song and finally give ranks to all words in the Dictionary given. 

+ **What Problem?**
After observing the data, we can divided it into two parts: 1) the first part where we find relations among features; 2) the second part where we connect those features with distributions of words in lyr.data.

+ **Features**
(1) For each song, within each group, i.e. analysis(excluding "$songs"), I calculate the **13 statistics of each covariate**, using the describe() in *{Psych}* package, which is more detailed than the summary() statistics. 

(2) For example, for the bar_confidence in the "Analysis" group, we can generate compherehensive stats like **"vars, n, mean, sd, median, trimmed, mad, min, max, range, skew, kurtosis, se"**. This generated very comprehensive statistics.For example, the bars would inform me whether the song is 2/4, 3/4 or 4/4. Since I am not an expert in music, I decided to leave it to the statistics to decide which ones are important and which not. So I constructed as many features as possible first.

(3) Since the "- /metadata, -/musicbrainz, -/analysis/songs" will not be provided in the test data, I can hardly see strong evidence suggesting that I should extract more subfeatures for each feature. 

(4) Feature Selection: will be covered later. See *Details and Justifications*

Overall, for the Analysis group, deducting the "songs" part, I have generated 13 * (16-1) = **195 features in total**.

+ **Reason & Procedures**
+ (1). **Baseline Model** 
Baseline model is the simplest model to be compared with other more complex models. It is just determined by the frequencies of words in the lyr.Rdata file.

+ (2). **Clustering**
Find clusters of features, determine to which cluster each test data belongs, and assign the frequencies of words in that cluster to that test data. Here, I tried K Means clustering and Hierarchical clustering. 

+ (3). **Topic Modeling**
Use Multinomial to see which topics the test data can be allocated to and their weights. Use the word distributions of the topics to determine which words are more prone to occur in the test set. 

+ **Details and Justifications**
+ (1). **Dimension Reduction**: PCA (considered but abandoned)
Since we have 2350 songs in the training set and 195 features, reducing the dimensionality of features is important in terms of shying from overfitting. Considering we are essentially doing unsupervised learning (labels of songs are noncomparable), so PCA seems like a simple and good way to go. 

However, PCA is reducing dimensionality but not feature selections. It provided PCA components but not a subset of variables that we would like to have. I abandoned this after I searched for and reading related documents for 2+ hours.

+ (2) **Feature Selection**: Random Forest(considered but abandoned) + Feature Cleaning

(i) Random Forest, along with other classification methods, is also one of my top choices to go. It selects features by their importance. 
However, it contains a lot of problems, such as the lack of labels and the different scales of my features. Moreimportantly, principal component are used as new features, instead of the original variables (which is not ideal here). I also dropped this option after more than hours of exploring. 

(ii) I was also able to reduce from 195 features to 174 ones by deleting NA columns or columns whose means are INF or -INF (please refer to the document format needed for K means more for details.)


+ (3). **Cross-Validation** (define **error = mean(predicted ranks) - mean(actual ranks in the test data)**)
Cross-Validation here is used to avoid overfitting, as well as an indirect criteria to determine which model is better. 
So far cross-validation has helped me to identify some good methods. But it is also limited by its time-consuming nature. Admittedly, running K=1 or 3 (mostly I ran K=1,3,5 because of the dimension of the dataset and the limited time) could lead to a totally different results as K=5.



+#################################### **My Findings** ####################################

+ **1.Baseline Rankings**

The baseline is determined just by the **frequencies** of words in the *lyr.Rdata*. 
The meaning of it is to:1) set up a lower bound by assuming all songs have the same word distributions, regardless of the music features;
2) for the benefits of more complicated models, we could compare them with the baseline for future improvement.

So the **Top 20 Words annd their Frequencies** in the Lyr.Rdata is:

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/fig1.png)

and I tested 100 training documents using CV, **the average error is 190.3119**, which is not bad {(define error = mean(predicted ranks) - mean(actual ranks in the test data))}.

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/baseline_cv1.png)

But after I used the whole training set and did 1,3,5 fold cross validation, the results are not so good, but pretty consistent. 

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/baseline%20cv%20results.png)

+ **2.Clustering (Unsupervised Learning)**

The clustering model is not hard to interpret. We train the lyr.Rdata to see how we can divide them into several groups.

+ **(I) KMeans Clustering**
I started with Kmeans. K-means clustering is the most popular partitioning method. It requires the analyst to specify the number of clusters to extract. 

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/Rplot.jpeg)

By observing the initial plot, I decided K can be between >= 8. 

Here are the table of # of K groups Vs the groups it signs to the testing data. 
![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/how%20to%20choose%20K.png)

As you can see, I used a "squeeze method" from math. By narrowing down the number of K, (for example, if K=5 is bad, and K=10 is good, then the optimal K lies in between [5,10]), I finally concluded that K=20 is probably the best way to divided this clusters. However, the results is still less than satisfactory, beacause there are only two clusters.

Using Cross Validation to assess this method. Here are the results:

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/K%20means%20results(CV).png)

As we can see from the results after 1,3,and 5-fold cross validation, the mean error is generally over 600 (recall I defined the error as the difference between the actual and predicted average ranks regarding related words, same calculating methods as required.) 

But could it be because I chose the wrong K? Let's see the results of K=10 comparing to K=20.

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/K%20means%20results(CV%2C%20K10%2BK20).png)

Like I expected, when there are 10 clusters, the performance is even worse than the 20 clusters.

Therefore, I don't believe K Means is the best way to go for this problem. 


+ **(II) Hierarchical Clustering**
I was also wondering, was the high error rates due to the calculating methods of K Means and the "euclidean" distance?
So I also tried out the Wald Hierarchical Clustering recommended here (http://www.statmethods.net/advstats/cluster.html)
 
First as usual, we look at the graph and choose K. After trying method ="euclidean", "binary" and "maximum", I found the "maximum" method generated okay results. And also to avoid repetitive calculations I did using K Means, I finally decided to use **K=10, Method="Maximum (also known as "Complete")"**.

 
 ![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/Rplot_K10%2C%20Eucliean.jpeg)
 ![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/Rplot_K10%2CBinary.jpeg)
 ![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/Rplot_K10%2C%20Maximum.jpeg)

 The graphs above can justify my choice. "Maximum"'s clusters look nicer.
 
Would Hierarchical Models do better?
Actually, after fitting the test data into the model, I still found at most 2 clusters can be generated. 
Here are the Cross Validation Results (as procedures are similar to K Means, I won't overstate the details here.)

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/HC%20results(CV%2C%20K%3D10).png)

So it turns out that Hierarchical Clustering doesn't do too well either.


+ **3.Topic Modeling**

I also trained topic modeling in the confidence that instead of trying directly to find relationships bewtween features and predict lyrics, we should find associations between lyrics, classify topics, predict lyrics and use their features' relationships to decide which topics.


![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/topic%20modeling%20method.png)

Unfortunately, without good clustering, even good classifications of topics won't render good results.



+ **4. Final Decision**

Therefore, incorporating all of the abovementioned findings and results, I finally **decided to use the baseline model** I created.

For more information on the final csv I submitted, please refer to [baseline/final prediction](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/output/sample_submission_ch3129(only%20test).csv)


+################################ **What Went Wrong?** ################################

+ **Feature Selection**
(1) Admittedly, I chose a lot of features, 195 for each song. This could easily lead to overfitting. 
(2) The features I extracted are highly correalted and don't reveal too much information in the "metadata" and "musicbrainz" which we don't have information about in the testing set. But they are good resources of telling who has written these songs and what genres they are. Without any additional information to compensate this loss is a big pitfall of this project.
(3) There are lots of "NA" parts in the information. I had to either wipe out these information or fix them with zeros.
(4) I also tried to delete the constant columns and that left me with 153 columns of features in total(which is 40 down from the original 195 features) but the clutering results from this seemed to be worse since I could only obtain one cluster for the whole testing set. It doesn't take cross validation for me to know it's not a good direction to go.

+ **K Means**
(1) K Means clutering are not doing a good job separating the songs. At most, I got 2-3 clusters which were basically equivalent to the baseline. 
(2) To perform K Means, I had to make sure that the means of each column for each feature is not infinite (same reason PCA is hard to perform). This forced me to wipe out some columns of features and may caused me to lose important features.

+ **Hierarchical Clustering**
(1) To avoid anything unfit for this problem in the nature of K Means, I also used Hierarchical Clustering, even different methods ("maximum"/"complete" instead of "eulidean" as in the K Means, "medium" instead of "mean" when aggregating"). The results are similar to K Means, if not worse. Therefore, I can conclude that either features don't have a strong association with the lyrics, or clustering is not suitable for these sorts of problems, or there was something wrong with my features. 




+################################ **Future Considerations and Concerns** ################################

+ **1.Features in Analysis$songs, Metadata and Musicbrainz**
Despite having subtrated the features in these groups, I didn't really use them when it comes to training the set. 
I do have a idea of finding out the correlation between these features so that even in the testing set we don't have such information, we can infer these features from the exisiting features we have in the testing set, through such relations. 

+ **2.Feature Selection**
I imgaed using PCA to trim down features. This is flawed in a way because the assumption is that the scales of the numbers don't matter. Although I did normalized my features, I reckon it could still be a problem beause PCA is dimensionality reduction, not feature selection. 

The problem with using PCA is that (1) measurements from all of the original variables are used in the projection to the lower dimensional space, so here principal component are used as new features, instead of the original variables; (2) only linear relationships are considered, and (3) PCA or SVD-based methods, as well as univariate screening methods (t-test, correlation, etc.), do not take into account the potential multivariate nature of the data structure (e.g., higher order interaction between variables).

Therefore how to select features among 195 generated ones is still something I should work on in the future.



+################################## **Thank You for Reading** ###############################

![image](https://github.com/TZstatsADS/Fall2016-proj4-CHuang0-0/blob/master/figs/just%20like%20fire%20lyric.png)


*(lyrics from P!nk's "Just Like Fire", one of my favorite.)*



+######################################### **The End**###########################################

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
