function  Xn=NormalizeData(X,method)
%% Description
% this function is for normalizing dataset.
% Data normalization is the process of rescaling one or more attributes to the range of 0 to 1. 
% This means that the largest value for each attribute is 1 and the smallest value is 0.

%% input parameters
% X: features 
% method=
%         1:  Standardization:  Transforming data using a z-score or t-score
%         2:  Normalization:    Rescaling data to have values between 0 and 1

%% output parameters
% Xn:  features that normalized.

%% Main body
[n,m]=size(X);
Xn=zeros(n,m);

switch method
    case 1    % Standardization
        Xmd=bsxfun(@minus,X,sum(X)/n);
        Xp=bsxfun(@power,Xmd,2);
        variance=sum(Xp)/n;        
        Xn=Xmd./variance;
        
    case 2   % Normalization
        minX=min(X);
        maxX=max(X);
        
        for j=1:m
            for i=1:n
                if maxX(j)~=minX(j)
                    Xn(i,j)=(X(i,j)-minX(j))/(maxX(j)-minX(j));
                else
                    Xn(i,j)=0;
                end
            end
        end
        
end


end