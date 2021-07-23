function  W=NormalizeSoftmax2(W)
%% Description
% A nonlinear normalization method called softmax scaling is used to scale the edge weight to the interval [0 1].

%% Input parameters
% W: The graph matrix

%% Output parameters
% W: The graph matrix that Normalized with Softmax method.

%% Main Body
[~,m]=size(W);
s=sum(sum(W));
md=s/(m*m-m);

sumW=0;
for i=1:m
   for j=i+1:m
      W(i,j)=W(i,j)-md;
      W(j,i)=W(i,j);
      
      sumW=sumW+W(i,j)^2;    
   end
end

n=m*(m-1)/2;
variance=sumW/n;

for i=1:m
    for j=i+1:m
        v=W(i,j)/variance;
        W(i,j)=1/(1+exp(-v));
        W(j,i)=W(i,j);
    end
end

end

