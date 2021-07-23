function  TV=TermVariance2(X)
%% Description
% indicates the normalized term variance of feature(X).

%% Input parameters
% X: features     X1={x11,x12,...,x1m} ... Xn={xn1,xn2,...,xnm}.

%% Output parameters
% TV: Term variance features that is a vector. 

%% Main Body
[nR,~]=size(X);

X=bsxfun(@minus,X,sum(X)/nR);
X=bsxfun(@power,X,2);
TV=sum(X)./nR;

end