function [DCG] = iDCG_f (y)
%count iDCG

DCG = 0;
y = sort(y,'descend');
for i=1:size(y,1)
    DCG = DCG + (2^y(i)-1)/log(i+1);
end;

