# Feature-Selection
In this research, a six-step method is proposed as follows to improve feature selection.The first step is preprocessing, 
in which the dataset is checked and modified for unspecified and repetitive values, 
and then the dataset is normalized for comparison between features. 
We use fisher score to maintain the top n number of outstanding features and remove the rest from the dataset as redundant ones. 
In the second step, we will create a weighted graph using the Pearson correlation coefficient between features as nodes. 
Then, edges with a weight less than threshold θ = 0.5 are removed from the graph. In the third step, 
we apply basic link prediction algorithms to improve the graph's structure and recover the missing or 
erroneously deleted relationships by adding the most probable edges to the graph. In the fourth step, 
using the Louvain community detection algorithm, we find the communities in the created graph. 
In the fifth step, the critical and more central nodes in each cluster are identified using the structural hole method, 
which also considers the latent and indirect connections between features. 
Finally, in the sixth step, in an iterative process for each cluster, the cluster members are ranked, then sorted in descending order, 
and we select the number w of the feature at the beginning of the list. 
Comparing the results using the four well-known classifiers, SVM, KNN, NB, and DT, shows that the proposed method generally performs better than the two recent similar methods,
CDGAFS and GCNC, in terms of performance. However, it is possible to improve the accuracy of the proposed results in several manners for future works. 


Proposal method coding with matlab R2019a. 

Main.m is main file for run. including:

Parameter setting
teta=0.5;                % threshold for remove features(default value is 0.5)
w=3;                     % minimum size of the reduced feature set in each cluster
ptrain=0.7;              % Number of sample percentages for classification training    
maxIteration=10;         % the maximum iteration
LP=0.2;                  % the number of edges to be added to the graph(percentage)

Loading Dataset
nameDS = 'wine';            % dataset file name    
Ext='.mat';                 % dataset file extension
prePath='Dataset\';         % dataset file path
