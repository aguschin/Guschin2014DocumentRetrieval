function [X] = AddNewVars(X,vars)

if strcmp(vars(1),'all')
    X1 = X;
else
    try 
        X1 = X(:,vars{1});
    catch
        X1 = X(:,vars);
    end;
end;

try
    for j=2:length(vars)
        h = vars{j};
        X1 = [X1 h(X)];
    end;
catch
    'NO NEW VARIABLES'
end;

X = X1;
