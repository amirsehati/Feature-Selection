function  x=NormalizeSoftmaxVector(x)
%% Description
% A nonlinear normalization method called softmax scaling is used to scale the vector values to the interval [0 1].

%% Input parameters
% x:        a vector of values.

%% Output parameters
% x:        scaled the vector values in the interval [0 1].

%% Parameters Setting
n=length(x);

%% Main body
meanx=sum(x)/n;

s1=0;
for i=1:n
   s1=s1+(x(i)-meanx)^2; 
end
sd=s1/n;

for i=1:n
   v=(x(i)-meanx)/sd;
   x(i)=1/(1+exp(-v)); 
end

end