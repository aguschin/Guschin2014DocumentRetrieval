function [DCG] = DCG_f (x, y, w, handle)
%count DCG

[sA,Y] = ranking_function(x, y, w, handle);
DCG = 0;
y = sort(y);
for i=1:size(x,1)
    %inc = 2^y(Y(i))-1;
    inc = y(Y(i));
    DCG = DCG + inc/log(i+1);
end;

