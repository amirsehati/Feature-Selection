function   z=my_setdiff(A,B)
%z=A-B

if ~isempty(A) && ~isempty(B)
    p=false(1,max(max(A),max(B)));
    p(A)=1;
    p(B)=0;
    z=A(p(A));    
else
    z=A;
end

end