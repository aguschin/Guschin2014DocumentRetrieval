function [X] = AddNewVars(X,vars)

if ~strcmp(vars,'all')
    try
        X1 = X(:,vars{1});
        for j=2:length(vars)
            h = vars{j};
            X1 = [X1 h(X)];
        end;
        X = X1;
    catch
        X = X(:,vars);
    end;
end;