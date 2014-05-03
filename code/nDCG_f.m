function [nDCG] = nDCG_f (x, y, w, handle)
%counting summary nDCG for the set of queries

handle = str2func(handle);

DCG = DCG_f(x, y, w, handle);
iDCG = 1; %default value in case when all pairs have "0" mark from assessor
if ~(isempty(y(y~=0))) %if all "0" marks
    iDCG = iDCG_f(y); %returns zero if ind is empty
end;
nDCG = DCG/iDCG; 

%nDCG = 1 - nDCG; %because we use fminsearch function and it tries to find min