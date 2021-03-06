%join GenerateSample and main

project = 'synthetic.prj.txt'; %synthetic
a = strsplit(project,'.');

if strcmp(a{1},'synthetic')
    dim = 2;
    GenerateSample(400*dim,'Rosenb',dim,'off');
    dim_t = strcat('_',num2str(dim));
    itr = round(dim*5/4);
    newFeatures = round(dim/7)+1;
else
    dim_t = '';
    itr = 50;
    newFeatures = 8;
end;

try
    load(strcat('vars_',a{1},dim_t));
catch
    [na, mdl] = FindLinearModel(project, itr);
    vars = na(1,:);
    save(strcat('vars_',a{1},dim_t),'vars');
end;

try
    load(strcat('bestModels_',a{1},dim_t));
catch
    bestModels = cell(1);
    i = 1;
    while i <= newFeatures
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

PolynomialApproximation(project);

%StepwiseAddition (newFeatures, project, itr, vars, bestModels);

vars = na(1,:);
save(strcat('vars1_',a{1},dim_t),'vars');