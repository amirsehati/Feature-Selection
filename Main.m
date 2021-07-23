clc;
clear;
close all;

%% Parameter setting
teta=0.5;                % threshold for remove features(default value is 0.5)
w=3;                     % minimum size of the reduced feature set in each cluster
ptrain=0.7;              % Number of sample percentages for classification training    
maxIteration=10;         % the maximum iteration
LP=0.2;                  % the number of edges to be added to the graph(percentage)

LpName=["wCN","wRA","wJC","wPA","wAA"];       % name of link prediction method
nLPMethod=length(LpName);                     % number of link prediction methods
%% Loading Dataset
nameDS = 'wine';            % dataset file name    
Ext='.mat';                 % dataset file extension
prePath='Dataset\';         % dataset file path

[X0,Y0]=DatasetLoad(strcat(prePath,nameDS,Ext));   % function for loading dataset file

%% PreProcessing
X=X0;    % Features
Y=Y0;    % Labels

% Adjusting data preprocessing according to the type of processing method
method1=-1;      %Delete Constant Columns value
[X,Y]=DataPreProcessing(X,Y,method1);     

method1=2;       %Mean insert insteed NaN or inf value
[X,Y]=DataPreProcessing(X,Y,method1);


method2=2;       %Rescaling data to have values between 0 and 1
Xn=NormalizeData(X,method2);
 

%% Initialize

% this section used for information record each iteration. include:

% nCOM:         communities number of network graph.
% nFeatures:    Obtained features.    
% time:         elapsed time for a iteration. 
% svm:          Accuracy obtained using the svm classifier.
% knn:          Accuracy obtained using the knn classifier.
% nb:           Accuracy obtained using the nb classifier.
% dt:           Accuracy obtained using the dt classifier.

type1.nCOM=0;
type1.nFeatures=0;
type1.time=0;
type1.svm=0;
type1.knn=0;
type1.nb=0;
type1.dt=0;
res1=repmat(type1,maxIteration,1);
res2=repmat(type1,maxIteration,1);

type2.nCOM=zeros(1,nLPMethod);
type2.nFeatures=zeros(1,nLPMethod);
type2.time=zeros(1,nLPMethod);
type2.svm=zeros(1,nLPMethod);
type2.knn=zeros(1,nLPMethod);
type2.nb=zeros(1,nLPMethod);
type2.dt=zeros(1,nLPMethod);
res3=repmat(type2,maxIteration,1);

[nSample,nFeature]=size(Xn);

%% Main Loop for iteration

for it=1:maxIteration
    
    ix=randperm(nSample,nSample);   % Random Permutation of Rows of a features and labels
    Xn=Xn(ix,:);  
    Y=Y(ix);    
    
    % Method 1:  GCNC method
    tic
    [FSel1,nCOM]=Algorithm_GCNC(Xn,Y,w,teta);    
    res1(it).time=toc;
    res1(it).nCOM=nCOM;
    res1(it).nFeatures=length(FSel1);
    
    % GCNC Train & Test & Calculate Accuracy for each Classifier
    z=CalcAccWithNClassifier(Xn,Y,ptrain,FSel1);
    res1(it).svm=z(1);
    res1(it).knn=z(2);
    res1(it).nb=z(3);
    res1(it).dt=z(4);
    % End of GCNC method    
    
    % Method 2:   CDGAFS method
    tic
    [FSel2,nCOMbs]=Algorithm_CDGAFS(Xn,Y,w,teta,ptrain);
    res2(it).time=toc;  
    res2(it).nFeatures=length(FSel2);
    res2(it).nCOM=nCOMbs;
    
    % GCNC Train & Test & Calculate Accuracy for each Classifier
    z=CalcAccWithNClassifier(Xn,Y,ptrain,FSel2);
    res2(it).svm=z(1);
    res2(it).knn=z(2);
    res2(it).nb=z(3);
    res2(it).dt=z(4);
    % End of CDGAFS method    
    
    % Method 3:  MyMethod using Link prediction and EBurt methods
    [FSel3,nCOMLP,timeLP]=Algorithm_MyMethodEBurt(Xn,Y,w,teta,LP);
    for LPMethod=1:nLPMethod
        res3(it).nCOM(LPMethod)=nCOMLP{LPMethod};
        res3(it).time(LPMethod)=timeLP(LPMethod);
        FSel33=FSel3{LPMethod};
        res3(it).nFeatures(LPMethod)=length(FSel33);
        
        % my Method Train & Test & Calculate Accuracy for each Classifier
        z=CalcAccWithNClassifier(Xn,Y,ptrain,FSel33);
        res3(it).svm(LPMethod)=z(1);
        res3(it).knn(LPMethod)=z(2);
        res3(it).nb(LPMethod)=z(3);
        res3(it).dt(LPMethod)=z(4);
    end
    % End of MyMethod Eburt
    
end

%% Results
% Calculate results based on average all iterations
A_nCOM1=0;
A_nF1=0;
A_time1=0;
accSVM1=0;
accKNN1=0;
accDT1=0;
accNB1=0;

for i=1:maxIteration
    A_nCOM1=A_nCOM1+res1(i).nCOM;
    A_nF1=A_nF1+res1(i).nFeatures;
    A_time1=A_time1+res1(i).time;
    accSVM1=accSVM1+res1(i).svm;
    accKNN1=accKNN1+res1(i).knn;
    accNB1=accNB1+res1(i).nb;
    accDT1=accDT1+res1(i).dt;
end

A_nCOM1=A_nCOM1/maxIteration;
A_nF1=A_nF1/maxIteration;
A_time1=A_time1/maxIteration;
accSVM1=accSVM1/maxIteration;
accKNN1=accKNN1/maxIteration;
accDT1=accDT1/maxIteration;
accNB1=accNB1/maxIteration;

A_nCOM2=0;
A_nF2=0;
A_time2=0;
accSVM2=0;
accKNN2=0;
accDT2=0;
accNB2=0;

for i=1:maxIteration
    A_nCOM2=A_nCOM2+res2(i).nCOM;
    A_nF2=A_nF2+res2(i).nFeatures;
    A_time2=A_time2+res2(i).time;
    accSVM2=accSVM2+res2(i).svm;
    accKNN2=accKNN2+res2(i).knn;
    accNB2=accNB2+res2(i).nb;
    accDT2=accDT2+res2(i).dt;
end

A_nCOM2=A_nCOM2/maxIteration;
A_nF2=A_nF2/maxIteration;
A_time2=A_time2/maxIteration;
accSVM2=accSVM2/maxIteration;
accKNN2=accKNN2/maxIteration;
accDT2=accDT2/maxIteration;
accNB2=accNB2/maxIteration;

A_nCOM3=zeros(1,nLPMethod);
A_nF3=zeros(1,nLPMethod);
A_time3=zeros(1,nLPMethod);
accSVM3=zeros(1,nLPMethod);
accKNN3=zeros(1,nLPMethod);
accDT3=zeros(1,nLPMethod);
accNB3=zeros(1,nLPMethod);

for i=1:nLPMethod    
    for j=1:maxIteration
        A_nCOM3(i)=A_nCOM3(i)+res3(j).nCOM(i);
        A_nF3(i)=A_nF3(i)+res3(j).nFeatures(i);
        A_time3(i)=A_time3(i)+res3(j).time(i);
        accSVM3(i)=accSVM3(i)+res3(j).svm(i);
        accKNN3(i)=accKNN3(i)+res3(j).knn(i);
        accDT3(i)=accDT3(i)+res3(j).dt(i);
        accNB3(i)=accNB3(i)+res3(j).nb(i);
    end
    
    A_nCOM3(i)=A_nCOM3(i)/maxIteration;
    A_nF3(i)=A_nF3(i)/maxIteration;
    A_time3(i)=A_time3(i)/maxIteration;
    accSVM3(i)=accSVM3(i)/maxIteration;
    accKNN3(i)=accKNN3(i)/maxIteration;
    accDT3(i)=accDT3(i)/maxIteration;
    accNB3(i)=accNB3(i)/maxIteration;
end

% show results
% Method:       method name 
% w:            minimum size of the reduced feature set in each cluster(input parameter)
% nC:           Obtained clusters (output parameter) 
% nF:           Obtained features (output parameter)   
% time:         elapsed time for a iteration (output parameter)  
% svm:          Accuracy obtained using the svm classifier (output parameter) 
% knn:          Accuracy obtained using the knn classifier (output parameter) 
% nb:           Accuracy obtained using the nb classifier  (output parameter) 
% dt:           Accuracy obtained using the dt classifier  (output parameter) 

% myPro_wCN:    my proposal method using wCN method  
% myPro_wRA:    my proposal method using wRA method
% myPro_wJC:    my proposal method using wJC method
% myPro_wPA:    my proposal method using wPA method
% myPro_wAA:    my proposal method using wAA method

disp(mfilename);
fprintf('Dataset: "%s"\n',nameDS);
fprintf('Method,w,nC,nF,SVM,KNN,NB,DT,Time(s)\n');
fprintf('GCNC,%d,%d,%d,%.2f,%.2f,%.2f,%.2f,%.4f\n',w,A_nCOM1,A_nF1,accSVM1,accKNN1,accNB1,accDT1,A_time1);
fprintf('CDGAFS,%d,%d,%d,%.2f,%.2f,%.2f,%.2f,%.4f\n',w,A_nCOM2,A_nF2,accSVM2,accKNN2,accNB2,accDT2,A_time2);
for i=1:nLPMethod
    fprintf('myPro_%s,%d,%d,%d,%.2f,%.2f,%.2f,%.2f,%.4f,LP: %.1f%%+\n',LpName(i),w,A_nCOM3(i),A_nF3(i),accSVM3(i),accKNN3(i),accNB3(i),accDT3(i),A_time3(i),LP*100);
end
