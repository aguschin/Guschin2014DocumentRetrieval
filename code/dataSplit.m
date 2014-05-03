function [data] = dataSplit(data)

m = round(size(data.X,1)/2); %middle

data.TestX = data.X(m:end,:);
data.X(m:end,:)=[];
data.TestY = data.Y(m:end,:);
data.Y(m:end,:)=[];
