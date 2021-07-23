function   [FSel,nCOM,runTime]=Algorithm_MyMethodEBurt(Xn,Y,w,teta,LP)
%% Description
% A Novel Feature Selection Based hole structure.

%% Input parameters
% Xn:       Normalized features.
% Y:        Target labels.
% w:        Minimum size of the reduced feature set in each cluster.
% teta:     Threshold for remove features(default value is 0.5)
% ptrain:   Number of sample percentages for classification training(default=0.7 = 70%)
% LP:       The number of edges to be added to the graph(percentage default=0.2 = 20%)

%% Output parameters
% FSel:          The final features selected that are obtained.  
% nCOM:          The final communities number that are obtained.
% runTime:       The Function runtime.

%% Parameters Setting
[~,nFeature]=size(Xn);
maxFeature=100;    % n Top of Score Features with Fisher Score 

nLPMethod=5;       % ["wCN","wRA","wJC","wPA","wAA"]

FSel=cell(nLPMethod,1);
nCOM=cell(nLPMethod,1);
runTime=zeros(nLPMethod,1);

%% Main Body
% Keep N-nTop Score Feature from dataset with Fisher score method and
% removal other, in other words, Irrelevant Feature Removal
Xn1=Xn;
if nFeature>maxFeature
    FeatureScore=FisherScore(Xn1,Y);
    FeatureScore=NormalizeSoftmaxVector(FeatureScore);
    [~,idx]=sort(FeatureScore,'descend');
    idx=idx(1:maxFeature);
    Xn1=Xn1(:,idx);
    nFeature=maxFeature;
end

% Graph Representation using the Pearson correlation coefficient.
W=PearsonCorr2(Xn1);  
W1=abs(W);
for i=1:length(W1)
    W1(i,i)=0;
end

% A nonlinear normalization method called softmax scaling is used to scale the edge weight to the interval[0 1].
Wn=NormalizeSoftmax2(W1);

% the edges with associated weights lower than a threshold ? will be
% removed in order to improve performance of the Louvain community detectionalgorithm.
Wn2=Wn;
Wn2(Wn2<teta)=0;

WnLP0=Wn2;

% Link Prediction
nLinkMissing=numel(find(WnLP0==0))/2-nFeature;   % Calculate the number of missing links
nL=ceil(nLinkMissing*LP);                        % The number of missing links to be added to the graph

% 
for LPMethod=1:nLPMethod
    tic
    WnLP1=WnLP0;
    pos=LinkPrediction4(WnLP1,LPMethod,nL);
    for i=1:nL
        x=pos(i).x;
        y=pos(i).y;
        v1=pos(i).Rank;
        v2=Wn(x,y);
        WnLP1(x,y)=v2;
        WnLP1(y,x)=WnLP1(x,y);
    end
    
    ComunitiesLP=LouvainComDetect(WnLP1);
    CLLP=unique(ComunitiesLP,'stable');
    nCOMLP=length(CLLP);
     
    COM2=cell(nCOMLP,1);
      
    neighbor=cell(nFeature,1);
    for i=1:nFeature
        neighbor{i}=find(WnLP1(i,:)~=0);
    end
    
    for k=1:nCOMLP
        members=find(ComunitiesLP==CLLP(k));
        L=length(members);
        
        NE=EBurtMethodFunc1(neighbor,members);
        %NE=(NE-min(NE))./(max(NE)-min(NE));
        
        [~,index]=sort(NE);
        
        COM2{k}=members(index(1:min(L,w)));
        
    end
    
    Cls1=[];
    for i=1:nCOMLP
        Cls1=[Cls1,COM2{i}];
    end
    
    Cls1=unique(Cls1);

    FSel{LPMethod}=Cls1;
    nCOM{LPMethod}=nCOMLP;
    runTime(LPMethod)=toc;

end

end