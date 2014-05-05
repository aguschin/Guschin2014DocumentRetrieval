%join GenerateSample and main

project = 'synthetic.prj.txt'; %synthetic

a = strsplit(project,'.');

if strcmp(a{1},'synthetic')
    dim = 20;
    GenerateSample(10000,'Rosenb',dim);
    dim_t = strcat('_',num2str(dim));
else
    dim_t = '';
end;

try
    load(strcat('vars_',a{1},dim_t));
catch
    [vars, mdl] = FindLinearModel(project, 15);
    save(strcat('vars_',a{1},dim_t),'vars');
end;

try
    load(strcat('bestModels1_',a{1},dim_t));
catch
    bestModels = cell(1);
    i = 1;
    while i <= 5
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
    save(strcat('bestModels_',a{1},dim_t),'bestModels');
end;

[vars, mdl] = FindLinearModel(project, 50, [vars bestModels]);
save(strcat('vars1_',a{1},dim_t),'vars');