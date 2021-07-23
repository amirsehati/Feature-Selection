function  z=LaplacianCentrality2(W,x)
%% Description
% The Laplacian centrality measure for weighted networks that used The Laplacian energy. 
% The importance (centrality) of a vertex v is reflected by the drop of the Laplacian energy of the network
% to respond to the deactivation (deletion) of the vertex from the network.

%% Input parameters
% W: The graph matrix
% x: Features vector within a cluster

%% Output parameters
% z: The importance(centrality) of a vector(x) 

%% Main Body
W=bsxfun(@minus,W,diag(diag(W)));

LE_G=LaplacianEnergy(W);

nx=length(x);
z=zeros(1,nx);

for i=1:nx
    Wi=W;
    vi=x(i);
    Wi(vi,:)=[];
    Wi(:,vi)=[];
    LE_Gi=LaplacianEnergy(Wi);
    z(i)=(LE_G-LE_Gi)/LE_G;
end

end

%%****************************************************************
function  LE=LaplacianEnergy(W)

[n,~]=size(W);
X=sum(W,2);

LE=0;
for i=1:n
    s=0;
    for j=i+1:n
        s=s+W(i,j)^2;
    end
    LE=LE+X(i)+2*s; 
end

end