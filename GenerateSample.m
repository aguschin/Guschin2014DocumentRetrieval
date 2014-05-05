%create synthetic data

function [y,x] = GenerateSample(s,func,d)

if nargin < 3, d = 2; end;

THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');

if strcmp(func, 'testfunc')
    y = testfunc(x);
elseif strcmp(func, 'Rosenb')
    x = randn(s,d);
    y = RosenBIG(x);
end;

data = [y,x];

dlmwrite(strcat(DATAFOLDER,'\synthetic.dat.txt'), data, ',') %save to \data\synthetic.dat.txt

end

function [y] = RosenBIG(xx)

d = size(xx,2);
sum = 0;
for ii = 1:(d-1)
	xi = xx(:,ii);
	xnext = xx(:,ii+1);
	new = 100*(xnext-xi.^2).^2 + (xi-1).^2;
	sum = sum + new;
end

y = sum;

end

function [f] = testfunc (x) %test function

f.handle = str2func('@(x) x.^2');
f = f.handle(x);

end

function [f] = Rosenb(x,y) %Rosenbrock function

f=((1-x).^2)+(100*((y-(x.^2)).^2));

end

