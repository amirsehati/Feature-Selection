function   z=my_intersect(A,B)
% z=(A-B) union (B-A)

if isempty(A) || isempty(B)
    z=[];
    return
end

p=false(1,max(max(A),max(B)));
p(A)=1;
z=B(p(B));

end