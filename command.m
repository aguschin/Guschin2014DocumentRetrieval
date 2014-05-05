%join GenerateSample and main

GenerateSample(4000,'Rosenb');

project = 'synthetic.prj.txt'; %synthetic

try
    load vars_synthetic
catch
    [vars, mdl] = FindLinearModel(project, 15);
    save('vars_synthetic','vars');
end;

try
    load bestModels_synthetic5456
catch
    bestModels = cell(1);
    for i=1:5
        population = main(project, vars);
        f1 = str2func(population{1}.Handle);
        f2 = @(x)f1(population{1}.FoundParams(:)',x);
        bestModels{i} = f2;
    end;
    save('bestModels_synthetic','bestModels');
end;

[vars, mdl] = FindLinearModel(project, 50, [vars bestModels]);
save('vars1_synthetic','vars');