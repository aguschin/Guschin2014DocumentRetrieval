function [ population ] = main(PrjFname, vars)
% The main function of the MVR 

warning on

% Global variable for plotting, to be removed
global PLTOPTSFIGNUM
PLTOPTSFIGNUM = 1;

% Add paths and initialize dir variables
if nargin < 1
    PrjFname = 'demo.prj.txt';
end
if nargin < 2
    vars = 'all';
end;
THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');
FUNCFOLDER = fullfile(THISFOLDER,'func');
CODEFOLDER = fullfile(THISFOLDER,'code');
REPORTFOLDER  = fullfile(THISFOLDER,'report');
if ~exist(REPORTFOLDER,'dir'), mkdir(REPORTFOLDER); end
addpath(FUNCFOLDER);
addpath(CODEFOLDER);


[ data, primitives, models, nlinopt, genopt, pltopt ] = InputProjectData( PrjFname, vars );

Q = zeros(2,1);
q = figure('name','Quality');
if size(data.X,2)<=2
    pltopt.figHandle = figure('name','Function');
end;
data = dataSplit(data);

population = CreatePopulation(models.Models, models.InitParams, primitives);
population = [population, CreateRandomPopulation(5, primitives, size(data.X, 2), 5)];
population = LearnPopulation(population, data.X, data.Y, nlinopt, pltopt );

for itr = 1 : genopt.MAXCYCLECOUNT
    itr
    Q = PlotQuality (Q, population, data, itr, q);
    populationCO = CrossoverPopulation(population, genopt.CROSSINGAMOUNT);
    populationCO = LearnPopulation(populationCO, data.X, data.Y, nlinopt, pltopt );
    populationMU = MutationPopulation(population, primitives, size(data.X, 2), genopt.MUTATIONAMOUNT);
    populationMU = LearnPopulation(populationMU, data.X, data.Y, nlinopt, pltopt );
    population = SelectBestPopulationElements([population, populationCO, populationMU], genopt.BESTELEMAMOUNT);
end;

PlotStruct(str2func(population{1}.Handle), population{1}.FoundParams, data.X, data.Y, pltopt);
Population2TeX(population, data.X, data.Y, REPORTFOLDER, 'ListOfObtainedModels.tex', pltopt);

end
