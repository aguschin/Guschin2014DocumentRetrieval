function [Q] = PlotQuality (Q, population, data, itr, h)

x = linspace(1,itr,itr);

Q(1,itr) = min(1,mean(cellfun(@(x)x.nMSE, population))); %avoiding machine zero

nMSE = zeros(1);
nDCG = zeros(1);
nDCG_Test = zeros(1);
for i=1:size(population,2)
    handle = str2func(population{i}.Handle);
    y = handle(population{i}.FoundParams,data.TestX);
    if itr == 10
        'a'
    end;
    nMSE(i) = norm(y - data.TestY).^ 2/norm(data.TestY).^2;
    nDCG(i) = nDCG_f(data.X, data.Y, population{i}.FoundParams, population{i}.Handle);
    nDCG_Test(i) = nDCG_f(data.TestX, data.TestY, population{i}.FoundParams, population{i}.Handle);
end;

Q(2,itr) = min(100,mean(nMSE)); %avoiding machine zero (mean(nMSE) could be over 10^20 for the first iteration)
Q(3,itr) = mean(nDCG);
Q(4,itr) = mean(nDCG_Test);

figure(h);
p = plot(x,Q(1,:),'r',x,Q(2,:),'g',x,Q(3,:),'b',x,Q(4,:),'k');
legend('nMSE: Learning','nMSE: Test','nDCG: Learning','nDCG: Test');
xlabel('Number of iterations');
%set(p,'linewidth',2);