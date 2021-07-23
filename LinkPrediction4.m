function   Z=LinkPrediction4(wG,method,m)
%% Description
% In network theory, link prediction is the problem of predicting the existence of a link between two entities in a network.
% This function using Topology-based methods("wCN","wRA","wJC","wPA","wAA") to predict links

%% Input parameters
% wG:        weighted graph
% method:    ["wCN","wRA","wJC","wPA","wAA"]   
% m:         The number of missing links to be added to the graph     

%% Output parameters
% Z:    A structural vector including the location of missing links and its score based on the selected link prediction method

%% Parameters Setting
global neighbor nv

[nv,~]=size(wG);

neighbor=cell(nv,1);
for i=1:nv
    neighbor{i}=find(wG(i,:));    % Calculate neighbors of node i
end

%% Main body
switch  method
    case 1
        LpList=wCommonNeighbor(wG);
    case 2
        LpList=wResourceAllocation(wG);
    case 3
        LpList=wJaccardCoefficient(wG);
    case 4
        LpList=wPreferentialAttachment(wG);
    case 5
        LpList=wAdamicAdar(wG);        
end

[~,index]=sort([LpList.Rank],'descend');

m=min(m,length(index));
Z=LpList(index(1:m));

end
%%*********************************************************************
function    result=wCommonNeighbor(wG)   %wCN
global neighbor nv

n=ceil(nv*(nv-1)/2);
rs.Rank=0;
rs.x=0;
rs.y=0;
result=repmat(rs,n,1);

idx=1;
for x=1:nv-1
    for y=x+1:nv
        if wG(x,y)~=0
            continue
        end
        
        X=neighbor{x};
        Y=neighbor{y};
        Z=my_intersect(X,Y);
        nZ=length(Z);
        wSum=0;
        if nZ>0
            wSum=sum(sum(wG(x,Z)))+sum(sum(wG(y,Z)));
        end
        
        result(idx).Rank=wSum;
        result(idx).x=x;
        result(idx).y=y; 
        idx=idx+1;

    end
end

result(idx:end)=[];

% v2=v/nZ;
end
%%*********************************************************************
function    result=wResourceAllocation(wG)  %wRA
global neighbor nv

n=ceil(nv*(nv-1)/2);
rs.Rank=0;
rs.x=0;
rs.y=0;
result=repmat(rs,n,1);

idx=1;
for x=1:nv-1
    for y=x+1:nv
        if wG(x,y)~=0
            continue
        end
        
        X=neighbor{x};
        Y=neighbor{y};
        Z=my_intersect(X,Y);
        nZ=length(Z);
        
        wSum=0;
        if nZ>0
            wSum=(sum(sum(wG(x,Z)))+sum(sum(wG(y,Z))))/sum(sum(wG(Z,:)));
        end
        
        result(idx).Rank=wSum;
        result(idx).x=x;
        result(idx).y=y; 
        idx=idx+1;
        
    end
end

result(idx:end)=[];

end
%%*********************************************************************
function    result=wJaccardCoefficient(wG)  %wJC
global neighbor nv

n=ceil(nv*(nv-1)/2);
rs.Rank=0;
rs.x=0;
rs.y=0;
result=repmat(rs,n,1);

idx=1;
for x=1:nv-1
    for y=x+1:nv
        if wG(x,y)~=0
            continue
        end
        
        X=neighbor{x};
        Y=neighbor{y};
        Z=my_intersect(X,Y);
        %nZ=length(Z);
        
        Sumx=sum(wG(x,:));
        Sumy=sum(wG(y,:));
        zSum=sum(sum(wG(x,Z)))+sum(sum(wG(y,Z)));        
        wSum=zSum/(Sumx+Sumy);
        
        result(idx).Rank=wSum;
        result(idx).x=x;
        result(idx).y=y;
        idx=idx+1;
        
    end
end

result(idx:end)=[];

end
%%*********************************************************************
function    result=wPreferentialAttachment(wG)  %wPA
global nv

n=ceil(nv*(nv-1)/2);
rs.Rank=0;
rs.x=0;
rs.y=0;
result=repmat(rs,n,1);

idx=1;
for x=1:nv-1
    for y=x+1:nv
        if wG(x,y)~=0
            continue
        end
              
        Sumxa=sum(wG(x,:));
        Sumyb=sum(wG(y,:));
        wSum=Sumxa*Sumyb;
        
        result(idx).Rank=wSum;
        result(idx).x=x;
        result(idx).y=y;
        idx=idx+1;
        
    end
end

result(idx:end)=[];

end
%%*********************************************************************
function    result=wAdamicAdar(wG)  %wAA
global neighbor nv

n=ceil(nv*(nv-1)/2);
rs.Rank=0;
rs.x=0;
rs.y=0;
result=repmat(rs,n,1);

idx=1;
for x=1:nv-1
    for y=x+1:nv
        if wG(x,y)~=0
            continue
        end
        
        X=neighbor{x};
        Y=neighbor{y};
        Z=my_intersect(X,Y);
        nZ=length(Z);
        
        wSum=0;
        for k=1:nZ
            z=Z(k);
            zSum=sum(wG(z,:));
            wSum=wSum+(wG(x,z)+wG(y,z))/log(1+zSum);
        end
        
        result(idx).Rank=wSum;
        result(idx).x=x;
        result(idx).y=y;
        idx=idx+1;
        
    end
end

result(idx:end)=[];

end