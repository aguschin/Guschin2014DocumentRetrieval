function model = LearnModelParams(model, y, x, nlinopt)

xlength = size(x,1);
xstep = round(xlength/10)-1;
xindeces = 10*[1:xstep];
xdiffindeces = setdiff(1:length(x),xindeces);
xcontrol  = x(xindeces);
selection = x(xdiffindeces,:);
x         = selection;

ycontrol  = y(xindeces);
y         = y(xdiffindeces);
% Find model parameters solving an optimization problem;
% Calcullate model MSE and error
%
% Inputs:
% model - input model structure;
% y - m-by-1 target variable;
% x - m-by-n independent variable
% nlinopt - options for nlinfit (nonlinear regression adjustment) method
%
% Outputs:
% model with the following new fields:
%  model.FoundParams - found parameters according to the data and
%  optimization problem solution;
%  model.MSE - mean squared error on a learning part of the dataset;
%  model.Error - model error value
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 29-apr-08
% M. Kuznetsov, 20.12.2013

nlinopt.FunValCheck = 'off'; % Check for invalid values, such as NaN or Inf, from  the objective function [ 'off' | 'on' (default) ].
%fprintf('currently in RefreshTreeInfo \n');
%model.Handle
handle = str2func(model.Handle);
initParams = cell2mat(model.InitParams');

model2 = model;
%fprintf(1, '\nTune: %s', model.Name);
model.FoundParams = [];
if ~isempty(model.InitParams)
    try
        [model.FoundParams, ~, ~, model.ParamsCov, model.MSE] =...
            nlinfit(x, y, handle, initParams, nlinopt); % find parameters
    catch
          disp('nlinfit failed, Found Params = Init Params')
          model.FoundParams = initParams;
    end
    
    model.MSE = mean( (handle(model.FoundParams, x) - y) .^ 2);
    model.Control = mean( (handle(model.FoundParams, xcontrol) - ycontrol) .^ 2);
    model.Error = errorFun(model.MSE, model.FoundParams, length(model.Tokens), size(x,1));
    %model.Error = model.MSE + 0.01*length(model.FoundParams);% * norm(model.FoundParams); % Fixme: error function sould be an input
    model2.FoundParams = [];
    
    %there we simplify our vector of parameters
    [model2.Handle, vecW] = paramsSimplyf(model);
    [model2.Handle, tokSize] = templateSearch(model2.Handle, model.Mat, model.Tokens);
    
    handle = str2func(model2.Handle);
    initParams = vecW;
    try
        [model2.FoundParams, ~, ~, model2.ParamsCov, model2.MSE] =...
            nlinfit(x, y, handle, initParams, nlinopt); % find parameters
    catch
          disp('nlinfit failed, Found Params = Init Params')
          model2.FoundParams = initParams;
    end
    
    model.MSE2 = mean( (handle(model2.FoundParams, x) - y) .^ 2);
    model.Error1 = errorFun(model.MSE2, model2.FoundParams, tokSize, size(x,1));
    model.Control1 = mean( (handle(model2.FoundParams, xcontrol) - ycontrol) .^ 2);
    %model.Error2 = model.MSE2 + 0.01*length(model2.FoundParams);% * norm(model2.FoundParams); % Fixme: error function sould be an input
    
        
    if ~strcmp(model.Handle,model2.Handle)
        %model.Handle
        %model2.Handle
        
        
        fileID1 = fopen('tex_table.txt', 'at');
        fileID2 = fopen('plot.txt', 'at');
        %fprintf('%d & %.2f & %.2f & %.2f & %.2f & %.2f \\\\ \n', model.MSE, model.Error,(model.MSE-model.MSE2)/model.MSE,(model.Error-model.Error1)/abs(model.Error), model.Control, (model.Control-model.Control1)/model.Control);
        fprintf(fileID1, '%.2f & %.2f & %.2f\\\\ \n', (model.MSE-model.MSE2)/model.MSE,(model.Error-model.Error1)/abs(model.Error), (model.Control-model.Control1)/model.Control);
        fprintf(fileID2, '%.2f %.2f %.2f \n', (model.MSE-model.MSE2)/model.MSE,(model.Error-model.Error1)/abs(model.Error), (model.Control-model.Control1)/model.Control);
        fclose(fileID1);
        fclose(fileID2);
        %{
        fprintf('MSE %d\n', model.MSE);
        fprintf('Error: %d;\n', (model.Error));
        fprintf('MSE difference %d\n', (model.MSE-model.MSE2)/model.MSE);
        fprintf('Relative error difference: %d;\n', (model.Error-model.Error1)/abs(model.Error));
        
        fprintf('%d; %d\n', model.Error1-model.Error4,model.Error1);
        fprintf('%d; %d\n\n', model.Error2-model.Error5,model.Error2);
        
        fprintf('%d ; %d\n',model.MSE, model.MSE2);
        fprintf('%d ; %d\n\n',model.Error, model.Error2);
        %}
        %{
        if model.MSE-model.MSE2<0
            fprintf('parameters %d %d\n', model.FoundParams, model2.FoundParams);
            
        end
        %}
    end
    %model.MSE = model.MSE2;
    %model.Error = model.Error1;
    
    
end
end

function [value] = errorFun (MSE, dimOmega, modelCompl, dimSelect)
    constInterpr = 15;
    tendToBeBad = 0.01;
    
    
    %aic = log(dimSelect)*dimOmega+dimSelect*log(MSE);
    
    aic = 0.05*norm(dimOmega)^2+MSE;
    value = aic;
    
    if modelCompl<constInterpr
        adding =  tendToBeBad*MSE*modelCompl;
    else
        adding =  MSE*(modelCompl-constInterpr)+tendToBeBad*MSE*constInterpr;
    end
    
    value = value+adding;
    %[adding, MSE, value]
end
