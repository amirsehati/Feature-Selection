function    [FSel,nCOM]=Algorithm_GCNC(Xn,Y,w,teta)
%% Description
% GCNC: Graph Clustering with Node Centrality for feature selection method. 

%% Input parameters
% Xn:       Normalized features.
% Y:        Target labels.
% w:        Minimum size of the reduced feature set in each cluster.
% teta:     Threshold for remove features(default value is 0.5)

%% Output parameters
% FSel:     The final features selected that are obtained.  
% nCOM:     The final communities number that are obtained.

%% Parameters Setting
influence_threshold=0.2;      % Threshold for remove features less of influence

%% Initializing
% Graph Representation using the Pearson correlation coefficient.
W=PearsonCorr2(Xn);
W1=abs(W);
for i=1:length(W1)
    W1(i,i)=0;
end

% A nonlinear normalization method called softmax scaling is used to scale the edge weight to the interval[0 1].
Wn=NormalizeSoftmax2(W1);

[nFeature,~]=size(Wn);

Wn2=Wn;
Wn2(Wn2<teta)=0;
Wn3=Wn2;

% Feature Clustering
Comunities=LouvainComDetect(Wn3);
CL=unique(Comunities,'stable');
nCOM=length(CL);

COM1=[];
COM1(1,:)=1:nFeature;
COM1(2,:)=Comunities;

Wn4=Wn3;

TV=TermVariance2(Xn);                % Calculate term variance features
TV=(TV-min(TV))./(max(TV)-min(TV));  % normalizing with max min method 

flag=1;
while flag
    flag=0;
    
    for k=1:nCOM
        members=find(COM1(2,:)==CL(k));
        L=length(members);
        
        LE=LaplacianCentrality2(Wn4,members);   % calculate Laplacian Centrality for a cluster members
        LE=(LE-min(LE))./(max(LE)-min(LE));     % normalize Laplacian Centrality for a cluster members 
        
        Condidate_list=zeros(1,L);
        Cnt=1;
        for i=1:L
            idx=members(i);
            ch=COM1(1,idx);
            influence=LE(i)*TV(ch);
            
            if (influence < influence_threshold)
                Condidate_list(Cnt)=idx;
                Cnt=Cnt+1;
            end
        end
        
        Condidate_list(Cnt:end)=[];    %remove rest of blank elements
        Cnt=Cnt-1;
        
        if (L-Cnt) >= w
            oldCOM=COM1;
            COM1(:,Condidate_list)=[];
            Wn4(Condidate_list,:)=[];
            Wn4(:,Condidate_list)=[];
            
            if ~isequal(oldCOM,COM1)      % verify if changed? 
                flag=1;
            end
            
        end
    end
    
end

Clusters1=cell(1,nCOM);
FSel=[];
for i=1:nCOM
    idx=find(COM1(2,:)==CL(i));
    Clusters1{i}=COM1(1,idx);
    FSel=[FSel Clusters1{i}];
end

FSel=unique(FSel);

end