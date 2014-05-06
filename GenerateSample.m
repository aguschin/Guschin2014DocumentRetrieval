%create synthetic data

function [y,x] = GenerateSample(s,func,d,noise)

if nargin < 3, d = 2; end;
if nargin < 4, noise = 'on'; end;

THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');

if strcmp(func, 'testfunc')
    y = testfunc(x);
elseif strcmp(func, 'Rosenb')
    x = randn(s,d);
    y = Rosenb(x);
    if strcmp(noise,'on')
        x = [x randn(s,round(d/4))]; %noise features
    end;
    %y = y + 0.05*mean(y)*randn(s,1); %gaussian noise
end;

data = [y,x];

dlmwrite(strcat(DATAFOLDER,'\synthetic.dat.txt'), data, ',') %save to \data\synthetic.dat.txt

end

function [y] = Rosenb(xx)

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

