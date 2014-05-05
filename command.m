%join GenerateSample and main

GenerateSample(4000,'Rosenb');

project = 'synthetic.prj.txt'; %synthetic

a = strsplit(project,'.');

try
    load(strcat('2vars_',a{1}));
catch
    [vars, mdl] = FindLinearModel(project, 15);
    save(strcat('vars_',a{1}),'vars');
end;

try
    load(strcat('bestModels1_',a{1}));
catch
    bestModels = cell(1);
    i = 1;
    while i <= 10
        try
            population = main(project, vars);
            f1 = str2func(population{1}.Handle);
            f2 = @(x)f1(population{1}.FoundParams(:)',x);
            bestModels{i} = f2;
            i = i + 1;
        catch
            'error in main.m'
        end;
    end;
    save(strcat('bestModels_',a{1}),'bestModels');
end;

[vars, mdl] = FindLinearModel(project, 50, [vars bestModels]);
save(strcat('vars1_',a{1}),'vars');