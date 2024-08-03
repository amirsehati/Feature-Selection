function   accuracy=CalcAccWithNClassifier(X,y,pTrain,features)
%% Description
% Training the classifiers (SVM, KNN, NB, DT,GBM) with the features obtained from the previous step,
% and then test the features and calculate the accuracy.

%% Input parameters
% X:          features      X1={x11,x12,...,x1m} ... Xn={xn1,xn2,...,xnm}.
% y:          Labels (are used as features output(target))   Y={y1,y2,...,yn}  
% pTrain:     Number of sample percentages for classification training(default=0.7 = 70%)
% features:    Classifier training using a number of features
       
%% Output parameters
% z: The accuracy obtain of each classifier, z=[z1,z2,z3,z4]
%       z1: The accuracy obtain of SVM classifier  
%       z2: The accuracy obtain of KNN classifier 
%       z3: The accuracy obtain of NB classifier 
%       z4: The accuracy obtain of DT classifier 
%       z5: The accuracy obtain of GBM classifier gradient boosting machine

%% Main Body
[numFeatures,~]=size(X);
nTrain=round(pTrain*numFeatures);

XTrain=X(1:nTrain,features);
yTrain=y(1:nTrain,:);

XTest=X(nTrain+1:end,features);
yTest=y(nTrain+1:end,:);

mdSVM1=fitcecoc(XTrain,yTrain);
mdKNN1=fitcknn(XTrain,yTrain);
mdDT1=fitctree(XTrain,yTrain);
t1=templateNaiveBayes('DistributionNames','kernel');
mdNB1=fitcecoc(XTrain,yTrain,'Learners',t1);
t2=templateTree('MaxNumSplits',10);
mdGBM1 = fitcensemble(XTrain, yTrain, 'Method', 'LPBoost', ...
                     'NumLearningCycles',100,'Learners',t2);

numclassifiers=5;

CC{1}=mdSVM1;
CC{2}=mdKNN1;
CC{3}=mdNB1;
CC{4}=mdDT1;
CC{5}=mdGBM1;

accuracy=zeros(numclassifiers,1);

for i=1:numclassifiers
    yPred=predict(CC{i},XTest);
    accuracy(i) = sum(yPred == yTest) / length(yTest);
    accuracy(i) = accuracy(i) * 100;

    % flag=yTest==yPrey;
    % nT=numel(find(flag==1));
    % nF=numel(find(flag==0));
    % accuracy(i)=nT/(nT+nF)*100;
end


end