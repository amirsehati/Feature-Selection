function  score=FisherScore(X,Y)
%% Description
% Fisher score is one of the most widely used supervised feature selection methods.
% it selects each feature independently according to their scores under the Fisher criterion,
% which leads to a suboptimal subset of features.
% also, It aims at finding an subset of features, which maximize the lower
% bound of traditional Fisher score

%% Input parameters
% X:        Features.
% Y:        Target labels.

%% Output parameters
% score:     A vector is the size of the number of features in which the Fisher score of each feature is calculated.
%        score=[s1,s2,...,sn]

%% Parameters Setting
[~,nFeature]=size(X);
score=zeros(nFeature,1);
meanFeature=sum(X)./nFeature;
ClassIndex=unique(Y,'stable');
nC=length(ClassIndex);

%% Main body

for fi=1:nFeature
    
    s1=0;
    s2=0;
    
    for k=1:nC
        c=ClassIndex(k);
        mem=find(Y==c);
        nClass=length(mem);
        
        sumClassF=sum(X(mem,fi));
        meanClassF=sumClassF/nClass;
        sdClassF=(sumClassF-meanClassF)^2/nClass;
        s1=s1+nClass*(meanClassF-meanFeature(fi))^2;
        s2=s2+nClass*sdClassF^2;
    end
    
    score(fi)=s1/s2;
end

end