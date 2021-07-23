function   [X,Y]=DataPreProcessing(X,Y,method)
%% Description
% This function is for data preprocessing. 
% Data preprocessing is an important step in the data mining process.
% Data-gathering methods are often loosely controlled, resulting in out-of-range values (e.g., Income: ?100),
% impossible data combinations (e.g., Sex: Male, Pregnant: Yes), and missing values, etc.

%% input parameters
% X:  Features
% Y:  Labels are used as features output(target)

% method=
% -1:  Delete Constant Columns value
%  0:  Replace NaN with zero value
%  1:  Remove sample with NaN or Inf value
%  2:  Mean insert insteed NaN or Inf value
%  3:  median samples insert insteed NaN or inf value
%  4:  Minimum samples insert insteed NaN or Inf value
%  5:  Maximum samples insert insteed NaN or Inf value

%% output parameters
% X:  Features  
% Y:  Labels are used as features output(target)

%% Main body
[nSample,m]=size(X);
r=zeros(nSample,1);

switch method
    case -1   %Delete Constant Columns value
        j=1;
        while j<=m
            flag=0;
            for i=1:nSample-1
                if X(i,j)~=X(i+1,j)
                    flag=1;
                    break;
                end
            end
            
            if flag
                j=j+1;
            else
                X(:,j)=[];
                m=m-1;
            end
            
        end
        
    case 0  % Replace NaN with zero value
        for j=1:m
            for i=1:nSample
                if isnan(X(i,j))
                    X(i,j)=0;
                end
            end
        end
        
        if nSample==m
            for i=1:m
                X(i,i)=1;
            end
        end
        
    case 1   % Remove sample with NaN or Inf value
        
        cnt=1;
        for i=1:nSample
            for j=1:m
                if isnan(X(i,j)) || isinf(X(i,j))
                    r(cnt)=i;
                    cnt=cnt+1;
                    break
                end
            end
        end
        
        r(cnt:end)=[];
        X(r,:)=[];
        Y(r,:)=[];
        
    case 2  % Mean insert insteed NaN or Inf value
        
        for j=1:m
            s=0;
            cnt=1;
            for i=1:nSample
                if isnan(X(i,j)) || isinf(X(i,j))
                    r(cnt)=i;
                    cnt=cnt+1;
                    continue
                end
                s=s+X(i,j);
            end
            
            cnt=cnt-1;
            md=s/(nSample-cnt);
            for i=1:cnt
                X(r(i),j)=md;
            end
        end
        
    case 3   % median samples insert insteed NaN or inf value
        
        list=zeros(nSample,1);
        
        for j=1:m
            cnt=1;
            list(:)=0;
            k=1;
            
            for i=1:nSample
                if isnan(X(i,j)) || isinf(X(i,j))
                    r(cnt)=i;
                    cnt=cnt+1;
                    continue
                end
                list(k)=X(i,j);
                k=k+1;
            end
            
            list(k:end)=[];
            k=k-1;
            list=sort(list);
            if mod(k,2)==0
                idx=k/2;
                md=(list(idx)+list(idx+1))/2;
            else
                idx=ceil(k/2);
                md=list(idx);
            end
            
            cnt=cnt-1;
            for i=1:cnt
                X(r(i),j)=md;
            end
        end
        
    case 4   % Minimum samples insert insteed NaN or Inf value
        
        list=zeros(nSample,1);
        
        for j=1:m
            cnt=1;
            list(:)=0;
            k=1;
            
            for i=1:nSample
                if isnan(X(i,j)) || isinf(X(i,j))
                    r(cnt)=i;
                    cnt=cnt+1;
                    continue
                end
                list(k)=X(i,j);
                k=k+1;
            end
            
            list(k:end)=[];
            minValue=min(list);
            
            cnt=cnt-1;
            for i=1:cnt
                X(r(i),j)=minValue;
            end
        end
         
    case 5   % Maximum samples insert insteed NaN or Inf value
        
        list=zeros(nSample,1);
        
        for j=1:m
            cnt=1;
            list(:)=0;
            k=1;
            
            for i=1:nSample
                if isnan(X(i,j)) || isinf(X(i,j))
                    r(cnt)=i;
                    cnt=cnt+1;
                    continue
                end
                list(k)=X(i,j);
                k=k+1;
            end
            
            list(k:end)=[];
            maxValue=max(list);
            
            cnt=cnt-1;
            for i=1:cnt
                X(r(i),j)=maxValue;
            end
        end
        
end

end