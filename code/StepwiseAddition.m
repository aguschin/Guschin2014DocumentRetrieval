function [Q] = StepwiseAddition (newFeatures, project, itr, vars, bestModels)

e = figure('name','adding new generated variables');
Q = zeros(4,1);
for i=1:newFeatures
    x = linspace(1,i,i);
    [na, mdl] = FindLinearModel(project, itr+newFeatures, [vars bestModels(1:i)]);
    Q(:,i) = na(2:5,mdl.NumVariables);
    figure(e);
    p = plot(x,Q(1,:),'r',x,Q(2,:),'g',x,Q(3,:),'b',x,Q(4,:),'k');
    hleg1 = legend('nMSE: Learning','nMSE: Test','nDCG: Learning','nDCG: Test');
    xlabel('Number of variables added');
    set(hleg1,'Location','SouthWest');
    set(findall(e,'type','text'),'fontSize',14,'fontWeight','bold')
end;