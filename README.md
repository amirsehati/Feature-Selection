# Feature Selection
This package is a tool for selecting features. We use hole structures to select features in the graph based on selecting the best representation in the clusters and finally increasing the accuracy.

Prerequisites
This package write on matlab R2019a x64 under windows 10 x64. 

Installation
requires matlab R2019a for run.

Main.m is main file for runing. so we need config parameters to obtain results.

Parameter setting
teta=0.5                threshold for remove features(default value is 0.5)
w=3                     minimum size of the reduced feature set in each cluster
ptrain=0.7              Number of sample percentages for classification training(default value is 0.7)     
maxIteration=10         the maximum iteration
LP=0.2                  the number of edges to be added to the graph(percentage) (default value is 0.2)

Loading Dataset
nameDS = 'wine'             dataset file name    
Ext='.mat'                  dataset file extension
prePath='Dataset\'          dataset file path

[X0,Y0]=DatasetLoad(strcat(prePath,nameDS,Ext))          function for loading dataset file

X0       Features
Y0       Labels(targets)
