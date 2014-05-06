function [] = PolynomialApproximation(project)

e = figure('name','polynomial regression');
Q = zeros(4,1);
for i=1:4
    x = linspace(1,i,i);
    [na, mdl] = FindLinearModel(project, 1000, 'all');
    Q(:,i) = na(2:5,mdl.NumVariables-1);
    figure(e);
    p = plot(x,Q(1,:),'r',x,Q(2,:),'g',x,Q(3,:),'b',x,Q(4,:),'k');
    hleg1 = legend('nMSE: Learning','nMSE: Test','nDCG: Learning','nDCG: Test');
    xlabel('power of polynoms');
    set(hleg1,'Location','SouthWest');
    set(findall(e,'type','text'),'fontSize',14)
    AddPowerPolynomial(project);
end;