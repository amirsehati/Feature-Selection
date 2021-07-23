function  Z=LouvainComDetect(G)
%% Description
% The Louvain method is an algorithm to detect communities in large networks.
% It maximizes a modularity score for each community, 
% where the modularity quantifies the quality of an assignment of nodes to communities.
% in other words, The Louvain algorithm is a hierarchical clustering algorithm,
% that recursively merges communities into a single node and 
% executes the modularity clustering on the condensed graphs.

%% Input parameters
% G: The graph matrix

%% Output parameters
% Z: Detected communities 

%% Main Body
[n,~]=size(G);

Comunities=1:n;

% Main Loop
while(1)
   
    [COM, isChangeflag]=Move_Nodes(G);     %Phase 1      
    
    if isChangeflag==0
        break;
    end
    
    G=Community_Aggregation(G,COM);        %Phase 2 
    Comunities=ExtractComunity(Comunities,COM);
  
end

Z=Comunities;

end

%%*************************************************************************
function   newComunities=ExtractComunity(Comunities,COM)

 Cl=unique(COM,'stable');
 nC=numel(Cl);
 
 for i=1:nC
     members1=find(COM==Cl(i));
     L=length(members1);
     for j=1:L
         members2=find(Comunities==members1(j));
         Comunities(members2)=i;
     end    
     
 end
 
 newComunities=Comunities;
 
end
%%*************************************************************************
function  [COM, flag]=Move_Nodes(G)

[nCOM,~]=size(G);
COM=1:nCOM;

ki=sum(G);
sum_tot=ki;
m=sum(ki);

flag=0;
flagChange=1;
while(flagChange)    

    flagChange=0;    

    for i=1:nCOM
        
        Ci=COM(i);
        COM(i)=-1;
        
        sum_tot(Ci)=sum_tot(Ci)-ki(i);
        
        NBi=my_setdiff(find(G(i,:)),i);
        L=numel(NBi);
        
        maxValue=-inf;
        maxComIndex=0;
        
        GainV=zeros(1,nCOM);
        
        for j=1:L  
            Cj=COM(NBi(j));
            
            if GainV(Cj)~=0
                continue
            end
            
            NBj=find(COM==Cj);            
            ki_in=sum(sum(G(i,NBj)));
            
            GainV(Cj)=ki_in/m - ki(i)*sum_tot(Cj)/(m*m);            
            
            if GainV(Cj) > maxValue
                 maxValue=GainV(Cj);
                 maxComIndex=Cj;
            end
        end
          
        if (maxValue>0)
            COM(i)=maxComIndex;
            sum_tot(maxComIndex)=sum_tot(maxComIndex)+ki(i);            
        else
            COM(i)=Ci;
            sum_tot(Ci)=sum_tot(Ci)+ki(i);
        end
        
       if  COM(i)~=Ci
           flagChange=1; 
           flag=1;
       end
        
    end
       
end

end
%%*************************************************************************
function  newG=Community_Aggregation(G,COM)

Clusters=unique(COM);
N=length(Clusters);

newG=zeros(N,N);

for ii=1:N
    Ci=Clusters(ii);
    membersA=find(COM==Ci);
    L1=length(membersA);
    
    for jj=ii:N
        Cj=Clusters(jj);
        membersB=find(COM==Cj);
        L2=length(membersB);
        
        sum_in=0;
        for i=1:L1
            for j=1:L2
                sum_in=sum_in+G(membersA(i),membersB(j));
            end
        end
        newG(ii,jj)=sum_in;
        newG(jj,ii)=newG(ii,jj);
    end
    
end

end