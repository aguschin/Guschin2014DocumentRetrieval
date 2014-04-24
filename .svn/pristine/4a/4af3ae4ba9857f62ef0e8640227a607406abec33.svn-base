function [ population ] = main(PrjFname)
% The main function of the MVR 

warning off

% Global variable for plotting, to be removed
global PLTOPTSFIGNUM
PLTOPTSFIGNUM = 1;

% Add paths and initialize dir variables
if nargin < 1
    PrjFname = 'demo.prj.txt';
end
THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');
FUNCFOLDER = fullfile(THISFOLDER,'func');
CODEFOLDER = fullfile(THISFOLDER,'code');
REPORTFOLDER  = fullfile(THISFOLDER,'report');
if ~exist(REPORTFOLDER,'dir'), mkdir(REPORTFOLDER); end
addpath(FUNCFOLDER);
addpath(CODEFOLDER);
clearFiles();

[ data, primitives, models, nlinopt, genopt, pltopt ] = InputProjectData( PrjFname, DATAFOLDER );

population = CreatePopulation(models.Models, models.InitParams, primitives);
population = [population, CreateRandomPopulation(5, primitives, size(data.X, 2), 5)];
population = LearnPopulation(population, data.X, data.Y, nlinopt, pltopt );

for itr = 1 : genopt.MAXCYCLECOUNT
    itr
    populationCO = CrossoverPopulation(population, genopt.CROSSINGAMOUNT);
    populationCO = LearnPopulation(populationCO, data.X, data.Y, nlinopt, pltopt );
    populationMU = MutationPopulation(population, primitives, size(data.X, 2), genopt.MUTATIONAMOUNT);
    populationMU = LearnPopulation(populationMU, data.X, data.Y, nlinopt, pltopt );
    population   = SelectBestPopulationElements([population, populationCO, populationMU], genopt.BESTELEMAMOUNT);
end;

arrayfun (@(x) population{1}.MSE, 1:length(population))
arrayfun (@(x) population{1}.Error, 1:length(population))
%arrayfun (@(x) population{1}.MSE2, 1:length(population))
%arrayfun (@(x) population{1}.Error2, 1:length(population))
%easytrain();


PlotStruct(str2func(population{1}.Handle), population{1}.FoundParams, data.X, data.Y, pltopt);
Population2TeX(population, data.X, data.Y, REPORTFOLDER, 'ListOfObtainedModels.tex', pltopt);

end

function [] = clearFiles ()
    fileID1 = fopen('tex_table.txt', 'wt');
    fileID2 = fopen('plot.txt', 'wt');
    fclose(fileID1);
    fclose(fileID2);
end
