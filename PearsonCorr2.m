function  coef=PearsonCorr2(X)
%% Description
% Graph Representation using the Pearson correlation coefficient.

%% Input parameters
% X: All features

%% Output parameters
% coef: a n*n matrix is that shown correlation between features.

%% Main body
[n,~]=size(X);

X=bsxfun(@minus,X,sum(X,1)/n);
coef=X' * X;
sstd=sqrt(diag(coef));
p=sstd * sstd';

coef=bsxfun(@rdivide,coef,p);

end

