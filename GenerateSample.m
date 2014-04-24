%create synthetic data

function [y,x] = GenerateSample(s,func)

if nargin < 1
    s = 10;
end
THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');

if strcmp(func, 'testfunc')
    y = testfunc(x);
elseif strcmp(func, 'Rosenb')
    x = randn(s,2);
    y = Rosenb(x(:,1),x(:,2));
end;

data = [y,x];

dlmwrite(strcat(DATAFOLDER,'\synthetic.dat.txt'), data, ',') %save to \data\synthetic.dat.txt

end

function [f] = testfunc (x) %test function

f.handle = str2func('@(x) x.^2');
f = f.handle(x);

end

function [f] = Rosenb(x,y) %Rosenbrock function

f=((1-x).^2)+(100*((y-(x.^2)).^2));

end