function [ population ] = SelectBestPopulationElements( population, maxAmount )
%SELECTNESTPOPULATIONELEMENTS Summary of this function goes here
% Select best k (maxAmount) models from population according to the model errors
%
% Inputs:
% population - cell array of models;
% maxAmount - number k of top-k models
%
% Outputs:
% population - cell array of top-k models
%
% Course: Machine Learning and Data Analysis
% Supervisor: V.V. Strijov
% Author: M. Kuznetsov
% Date 24.12.2013
%
errors = cellfun(@(x)x.Error, population);
[~, sortedIdcs] = sort(errors);
population = population(sortedIdcs(1 : min(maxAmount, length(population))));

end

