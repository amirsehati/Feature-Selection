# Graph-based feature selection improvement using link prediction and hole structures

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
