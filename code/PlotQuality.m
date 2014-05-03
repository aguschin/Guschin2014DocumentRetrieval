function [Q] = PlotQuality (Q, population, data, itr, h)

figure(h);
x = linspace(1,itr,itr);

Q(1,itr) = min(10,mean(cellfun(@(x)x.nMSE, population))); %avoiding machine zero

nMSE = zeros(1);
for i=1:size(population,2)
    handle = str2func(population{i}.Handle);
    y = handle(population{i}.FoundParams,data.TestX);
    nMSE(i) = norm(y - data.TestY).^ 2/norm(data.TestY).^2;
end;

Q(2,itr) = min(10,mean(nMSE)); %avoiding machine zero (mean(nMSE) could be over 10^20 for the first iteration)

plot(x,Q(1,:),'r',x,Q(2,:),'g');
legend('nMSE: Learning','nMSE: Test');