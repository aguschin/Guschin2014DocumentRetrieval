function [na,mdl] = FindLinearModel(prjFname,iter,vars)

THISFOLDER = fileparts(mfilename('fullpath'));
%CODEFOLDER = fullfile(THISFOLDER,'code');

if nargin < 1, prjFname='demo.prj.txt'; end;
if nargin < 2, vars = 'all'; end;

try
    a = strsplit(prjFname,'.');
    load(strcat('data\',a{1}));
catch

    Data = dlmread(strcat(THISFOLDER,'\data\',a{1},'.dat.txt'),','); % read the data
    if strcmp(prjFname,'demo.prj.txt')
        Data = Data(randperm(size(Data,1)),:);
    end;
    data.Y= Data(:,1);
    data.X = Data(:,2:end);
end;
data.X = AddNewVars(data.X,vars);
data = dataSplit(data);
    
linm = {};
linm.Handle = '@(w,x) w(2:end)*x''';

na = zeros(5,1);
nDCG_linear = zeros(1);

h = figure('name','Linear model');

% for i = 1:7
%     name = strcat('TestFeature',num2str(i));
%     load(name)
%     handle = str2func(model.Handle);
%     y = handle(model.FoundParams, data.X);
%     y(isinf(y))=0;
%     data.X(:,end+1) = y./mean(abs(y(y~=0)));
%     if size(find(isinf(data.X(:,end))),1)
%         data.X(:,end) = y;
%     end;
% end;

for i = 1:iter
    i
    if size(data.X,2) < i
        break;
    end;
    q = 0;
    num = 0; %necessary?
    MSE = 1000000000;%10000000000;
    nDCG = 0;
    for j = 1:size(data.X,2)
        na(1,i) = j;
        if size(unique(na(1,:)),2) ~= i
            continue;
        end;
        if unique(data.X(:,j)) == 0
            continue;
        end;
        mdl = fitlm(data.X(:,na(1,:)),data.Y);
        %nDCG
        X = data.X(:,na(1,:));
        TestX = data.TestX(:,na(1,:));
        linm.FoundParams = mdl.Coefficients.Estimate';
        mdl_nDCG = nDCG_f(X, data.Y, linm.FoundParams, linm.Handle);
        
        if  mdl.MSE < MSE %mdl_nDCG > nDCG %
            nDCG = mdl_nDCG;
            num = j;
            y1 = predict(mdl, data.TestX(:,na(1,:)));
            MSE = mdl.MSE;
            TestMSE = mse(data.TestY-y1);
            TESTnDCG = nDCG_f(TestX, data.TestY, linm.FoundParams, linm.Handle);
        end;
    end;
    na(1,i) = num;
    na(2,i) = MSE;
    na(3,i) = TestMSE;
    na(4,i) = nDCG;
    na(5,i) = TESTnDCG;
    na
    [a, b] = min(na(3,:))
    figure(h);
    plot(linspace(1,i,i),na(2,:),'r',linspace(1,i,i),na(3,:),'b',linspace(1,i,i),na(4,:),'g',linspace(1,i,i),na(5,:),'c');
    hleg1 = legend('nMSE (learning sample)','nMSE (testing sample)', 'nDCG (learning sample)', 'nDCG (testing sample)');
    set(hleg1,'Location','SouthWest')
    %ylabel('nMSE or nDCG');
    xlabel('features in model');
    
end;

na = na(1,:);
mdl = fitlm(data.X(:,na(1,1:b)),data.Y)

%Testing nDCG

% data.TestX = data.TestX(:,na(1,1:b));

% data.TestX = data.TestX(:,na(1,1:b));
% %load mdl1.mat
% linm.FoundParams = mdl.Coefficients.Estimate';
% nDCG_linear(i) = 1 - nDCG_f(data.TestX, data.TestY, data.TestZ, linm.FoundParams, str2func(linm.Handle))


