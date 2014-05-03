function [DCG] = DCG_f (x, y, w, handle)
%count DCG

[sA,Y] = ranking_function(x, y, w, handle);
DCG = 0;
y = sort(y);
for i=1:size(x,1) 
    DCG = DCG + (2^y(Y(i))-1)/log(i+1);
end;

