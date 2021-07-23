function    [X,Y]=DatasetLoad(nameDS)
%% Description
% this function is for loading dataset.

%% input parameters
% nameDS: dataset full file name with path and file extension

%% output parameters
% X:  Features (are the fields) X
% Y:  Labels (are used as features output(target))

%% Main body
dataST=load(nameDS);
fields=fieldnames(dataST);
nr=length(fields);
X=[];
Y=[];

if nr==1
    fld=fields{1};
    ds0=dataST.(fld);
    [~,m]=size(ds0);
    X=ds0(:,1:m-1);
    Y=ds0(:,m);
    
elseif nr>1
    for i=1:nr
        fld=fields{i};
        if strcmpi(fld,'X')
            X=dataST.(fld);
        elseif strcmpi(fld,'Y')
            Y=dataST.(fld);
        end        
    end
end

end