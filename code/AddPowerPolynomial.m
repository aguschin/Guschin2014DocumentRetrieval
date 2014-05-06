function [] = AddPowerPolynomial(prjFname)

THISFOLDER = fileparts(mfilename('fullpath'));
%CODEFOLDER = fullfile(THISFOLDER,'code');

if nargin < 1, prjFname='demo.prj.txt'; end;
if nargin < 2, vars = 'all'; end;

a = 'synthetic';
s = strfind(THISFOLDER, '\');
b = THISFOLDER(1:s(end));

Data = dlmread(strcat(b,'data\',a,'.dat.txt'),','); % read the data
if strcmp(prjFname,'demo.prj.txt')
    Data = Data(randperm(size(Data,1)),:);
end;
data.Y= Data(:,1);
data.X = Data(:,2:end);

data.X = x2fx(data.X,'purequadratic');

data_write = [data.Y,data.X];

dlmwrite(strcat(b,'data\synthetic.dat.txt'), data_write, ','); %save to \data\synthetic.dat.txt