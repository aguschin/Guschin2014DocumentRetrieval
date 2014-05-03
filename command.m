%join GenerateSample and main

GenerateSample(1000,'Rosenb');

project = 'yandex.prj.txt';

try
    load vars
catch
    [vars, mdl] = FindLinearModel(project, 15);
    save('vars','vars');
end;

bestModels = cell(1);

for i=1:5
    population = main(project, vars);
    f1 = str2func(population{1}.Handle);
    f2 = @(x)f1(population{1}.FoundParams,x);
    bestModels{i} = f2;
end;

[vars, mdl] = FindLinearModel(project, 50, vars);
save('vars1','vars');

save('bestModels','bestModels');

main(project, {vars bestModels{:}})