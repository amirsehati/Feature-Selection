function   y=EBurtMethodFunc1(neighbor,members)
%% Description
% Calculated score vector of each input cluster member using EBurt method based on structural holes

%% Input parameters
% neighbor:        Neighbor matrix of node graphs
% members:         a cluster members

%% Output parameters
% Z:    Calculated score vector of each input cluster member using EBurt method based on structural holes 

%% Parameters Setting
global neighbor1 R H

neighbor1=neighbor;

n=length(members);
m=length(neighbor1);

R=inf(m,m);
H=inf(m,1);

y=zeros(n,1);

%% Main body
for I=1:n
    chI=members(I);
    nbi=neighbor1{chI};
    ni=length(nbi);
    
    s=0;
    for j=1:ni
        J=nbi(j);
        nbj=neighbor1{J};
        %nj=length(nbj);
        
        com=my_intersect(nbi,nbj);
        nk=length(com);
        
        s1=0;
        for k=1:nk
            K=com(k);
            if (K==chI) || (K==J)
                continue
            end
            
            if isinf(R(chI,K))
                R(chI,K)=r(chI,K);
            end
            
            if isinf(R(K,J))
                R(K,J)=r(K,J);
            end
            
            
            s1=s1+R(chI,K)*R(K,J);
        end
        
        
        if isinf(R(chI,J))
            R(chI,J)=r(chI,J);
        end
        
        s=s+(R(chI,J)+s1)^2;
        
    end
    
    y(I)=s;
end

end
%%********************************************************
function   z=r(i,j)

global neighbor1 H

nbi=neighbor1{i};
di=length(nbi);

s=0;
for ii=1:di
    m=nbi(ii);
    if isinf(H(m))
        H(m)=h(m);
    end
    s=s+H(m);
end

if isinf(H(j))
    H(j)=h(j);
end

z=H(j)/s;

end

%%********************************************************
function   z=h(i)

global neighbor1

nbi=neighbor1{i};
ni=length(nbi);

wij=0;
for j=1:ni
    nbj=neighbor1{nbi(j)};
    nj=length(nbj);
    wij=wij+ni*nj;
end

s=0;
for j=1:ni
    nbj=neighbor1{nbi(j)};
    nj=length(nbj);
    p=(ni*nj)/wij;
    s=s+p*log(p);
end

z=(1-s)*wij;

end



