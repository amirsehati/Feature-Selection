function   [FSel,nCOM]=Algorithm_CDGAFS(Xn,Y,w,teta,ptrain)
%% Description
% A Novel Community Detection Based Genetic Algorithm for Feature Selection(CDGAFS).

%% Input parameters
% Xn:       Normalized features.
% Y:        Target labels.
% w:        Minimum size of the reduced feature set in each cluster.
% teta:     Threshold for remove features(default value is 0.5)
% ptrain:   Number of sample percentages for classification training(default=0.7 = 70%)

%% Output parameters
% FSel:     The final features selected that are obtained.  
% nCOM:     The final communities number that are obtained.

%% Parameters Setting
global Xr Y1 ntrain wGn cluster1
Xr=Xn;
Y1=Y;

% Problem Definition
maxVar=100;     % Maximum number of features with the highest Fisher score

[nSample,nVar]=size(Xr);

ntrain=round(nSample*ptrain);

%% Main Body

%Step1: Measure the fisher score of features
FS=FisherScore(Xn,Y);
FSn=NormalizeSoftmaxVector(FS);

%Step2: Irrelevant Feature Removal
if nVar>100
    [~,idx]=sort(FSn,'descend');
    Xr=Xr(:,idx(1:maxVar));
    nVar=maxVar;
end

%Step3: graph creation and Feature clustering
wG=PearsonCorr2(Xr);   % graph creation using the Pearson correlation coefficient. 
wG=abs(wG);
for i=1:nVar
  wG(i,i)=0;  
end

wGn=NormalizeSoftmax2(wG);
wGn(wGn<teta)=0;

comunity=LouvainComDetect(wGn);   % Feature clustering
CL=unique(comunity,'stable');
nCOM=length(CL);
cluster1=cell(nCOM,1);
for i=1:nCOM
   cluster1{i}=find(comunity==CL(i));   
end

%Step4:  A genetic algorithm (GA) Parameters
nPop=100;
MaxIt = 100;
varSize = [1 nVar];
CostFunction = @(x) Costfit(x);
Constrint.varMax = 1;
Constrint.varMin = 0;

pCrossover = 0.8;
nCrossover = round(nPop * pCrossover / 2)*2;
pMutation = 0.05;
nMutation =round(nPop * pMutation);

% Initialization population
empty_individual.Position = [];
empty_individual.Cost = [];
pop = repmat(empty_individual,nPop,1);

for i=1:nPop    
    pop(i).Position = randi([Constrint.varMin,Constrint.varMax],varSize);
    pop(i).Position=RepairChromosome(pop(i).Position,w);
    pop(i).Cost = CostFunction(pop(i).Position);    
end

% Sort Cost base on Order
pop = SortPopulation(pop);

BestSolution = pop(1);

% GA Main Loop
for i=1:MaxIt
    
    popC = repmat(empty_individual,nCrossover/2,2);
    
    for j=1:nCrossover/2
        
        T1 = randi([1 nPop]);
        T2 = randi([1 nPop]);
        
        P1 = pop(T1);
        P2 = pop(T2);
        
        [popC(j,1).Position, popC(j,2).Position] = Crossover(P1.Position,P2.Position);
        
        popC(j,1).Position=RepairChromosome(popC(j,1).Position,w);
        popC(j,2).Position=RepairChromosome(popC(j,2).Position,w);
        
        popC(j,1).Cost = CostFunction(popC(j,1).Position);
        popC(j,2).Cost = CostFunction(popC(j,2).Position);
        
    end
    
    popC = popC(:);
    
    popM = repmat(empty_individual,nMutation,1);
    
    for j=1:nMutation
        
        T = randi([1 nPop]);
        
        P = pop(T);
        
        popM(j).Position = Mutate(P.Position);
        popM(j).Position=RepairChromosome(popM(j).Position,w);
        popM(j).Cost = CostFunction(popM(j).Position);
        
    end    
    
    [pop]=[pop
        popC
        popM];    
    
    pop = SortPopulation(pop);
    
    pop = pop(1:nPop);
    
    BestSolution_iteration = pop(1);
    
    if BestSolution_iteration.Cost > BestSolution.Cost
       BestSolution=BestSolution_iteration; 
    end
    
end

idx=1:nVar;
bs=BestSolution.Position;
FSel=idx(logical(bs));

end
%%*****************************************************************
function  [child1,child2] = Crossover(p1,p2)

n=length(p1);

singlepoint=randi([1 n],1,1); 

child1 = [p1(1:singlepoint),p2(singlepoint+1:end)];
child2 = [p2(1:singlepoint),p1(singlepoint+1:end)];

end
%%*****************************************************************
function  y = Mutate(x)

nVar = length(x);

cr1 = randi([1 nVar],1,1);
cr2 = randi([1 nVar],1,1);

y = x;

a=y(cr1);
y(cr1)=y(cr2);
y(cr2)=a;

end
%%*****************************************************************
function  out = SortPopulation(p)

[~ ,soIndex] = sort([p.Cost],'descend');
out = p(soIndex);
end
%%*****************************************************************
function z=Costfit(x)
global Xr Y1 ntrain wGn

[~,nF]=size(Xr);
fn=1:nF;

fSel=fn(logical(x));

XX=Xr(1:ntrain,fSel);
YY=Y1(1:ntrain,:);

xtest=Xr(ntrain+1:end,fSel);
ytest=Y1(ntrain+1:end,:);

mdKNN1=fitcknn(XX,YY);
yKNN1=predict(mdKNN1,xtest);
flag=ytest==yKNN1;
nT=numel(find(flag==1));
nF=numel(find(flag==0));

ClassAcc=nT/(nT+nF)*100;

nFS=length(fSel);

sim=0;
for i=1:nFS-1
   for j=i+1:nFS
     sim=sim+wGn(fSel(i),fSel(j));  
   end
end

z=ClassAcc/(2/nFS*(nFS-1))*sim;

end
%%*****************************************************************
function  z=RepairChromosome(x,w)
global cluster1
z=x;

n=length(z);
nCL=length(cluster1);

idx=1:n;
fSel=idx(logical(z));

for i=1:nCL
    members=cluster1{i};
    nclass=length(members);
    CM=my_intersect(fSel,members);
    nCM=length(CM);
    
    if  nCM>w
        nR=nCM-w;
        DelSet=[];
        while nR>0
            rd=randi([1 nCM],1,1);
            ts=my_intersect(DelSet,rd);
            if isempty(ts)
                DelSet=[DelSet rd];
                nR=nR-1;
            end
        end
        
        z(CM(DelSet))=0;
        
    elseif nCM<w
        w1=min(w,nclass);
        nAdd=w1-nCM;
        if nAdd<=0
            continue
        end
        
        AddSet=[];
        if nCM>0
            for j=1:nCM
                AddSet=[AddSet,find(members==CM(j))];
            end
        end
        
        while nAdd>0
            rd=randi([1 nclass],1,1);
            ts=my_intersect(AddSet,rd);
            if isempty(ts)
                AddSet=[AddSet rd];
                nAdd=nAdd-1;
            end
        end
        
        z(members(AddSet))=1;      
        
    end
    
end

end
