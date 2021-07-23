function   z=CalcAccWithNClassifier(X,Y,ptrain,feature)
%% Description
% Training the classifiers (SVM, KNN, NB, DT) with the features obtained from the previous step,
% and then test the features and calculate the accuracy.

%% Input parameters
% X:          features      X1={x11,x12,...,x1m} ... Xn={xn1,xn2,...,xnm}.
% Y:          Labels (are used as features output(target))   Y={y1,y2,...,yn}  
% ptrain:     Number of sample percentages for classification training(default=0.7 = 70%)
% feature:    Classifier training using a number of features
       
%% Output parameters
% z: The accuracy obtain of each classifier, z=[z1,z2,z3,z4]
%       z1: The accuracy obtain of SVM classifier  
%       z2: The accuracy obtain of KNN classifier 
%       z3: The accuracy obtain of NB classifier 
%       z4: The accuracy obtain of DT classifier 

%% Main Body
[N,~]=size(X);
ntrain=round(ptrain*N);

XX=X(1:ntrain,feature);
YY=Y(1:ntrain,:);

xtest=X(ntrain+1:end,feature);
ytest=Y(ntrain+1:end,:);

mdSVM1=fitcecoc(XX,YY);
mdKNN1=fitcknn(XX,YY);
mdDT1=fitctree(XX,YY);
t=templateNaiveBayes('DistributionNames','kernel');
mdNB1=fitcecoc(XX,YY,'Learners',t);

nCC=4;
CC{1}=mdSVM1;
CC{2}=mdKNN1;
CC{3}=mdNB1;
CC{4}=mdDT1;

z=zeros(nCC,1);

for i=1:nCC
    prey=predict(CC{i},xtest);
    flag=ytest==prey;
    nT=numel(find(flag==1));
    nF=numel(find(flag==0));
    acc=nT/(nT+nF)*100;
    z(i)=acc;
end


end