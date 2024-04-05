close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Problem:
% Implement a SURROGATE based strategy to find a good approximation of the
% ENTIRE Pareto front with at most 300 function evaluations of the true
% auxiliary function in AuxModel.p 
% the strategy should be reliable and should be tested on 10 independent runs 
% (only if a stochastic method is used)
% 
% This program will be utilsing an Artificial Neural Network (ANN) 
% based approach
% -------------------------------------------------------------------------

% Surrogate based Global Search of Auxiliary Function - 300 FE limit
% main()
rng('default')
rng(1014)   % setting seed for reproduciblity
tic;

load('aux_dataset.mat');

% RNG seeds for each run
seedVals = [74, 111, 115, 101, 102, 83, 97, 110, 116, 105];

% GA options
options = optimoptions('gamultiobj', 'Display', 'iter', 'PopulationSize', 100, 'MaxGenerations', 100);

% Initialise variables for plotting
allParetoFronts = {};  % Cell array to store Pareto fronts from all runs
results(length(seedVals)) = struct('xOptNorm', [], ...
    'fValOpt', [], ...
    'xOpt', [], ...
    'net', [], ...
    'tr', [], ...
    'Xmin', [], ...
    'Xmax', []);

mseErrors = zeros(1, length(seedVals));
maeErrors = zeros(1, length(seedVals));

% Loop over runs
for runIdx = 1:length(seedVals)
    rng(seedVals(runIdx));  % Set seed for reproducibility
    fprintf('Starting Run %d\n', runIdx);
    
    % Data for current run, with a split for training and testing
    totalData = 300; % Number of samples per run
    trainSplit = floor(0.7 * totalData); % 70% for training
    testSplit = totalData - trainSplit; % Remaining for testing
    
    startIndex = (runIdx - 1) * totalData + 1;
    endIndex = runIdx * totalData;
    
    indices = randperm(totalData);
    trainIndices = indices(1:trainSplit) + startIndex - 1;
    testIndices = indices(trainSplit+1:end) + startIndex - 1;
    
    Xtrain = setSamples(trainIndices, :);
    Ytrain = setOptVals(trainIndices, :);
    Xtest = setSamples(testIndices, :);
    Ytest = setOptVals(testIndices, :);
    
    % Normalisation
    Xmin = min(Xtrain, [], 1);
    Xmax = max(Xtrain, [], 1);
    XtrainNorm = (Xtrain - Xmin) ./ (Xmax - Xmin);
    XtestNorm = (Xtest - Xmin) ./ (Xmax - Xmin);

    % ANN architecture and training
    nVars = size(Xtrain, 2);
    net = fitnet([12, 12], 'trainrp');
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;
    
    [net, tr] = train(net, XtrainNorm', Ytrain');

    % Testing and validation
    Ypred = net(XtestNorm');
    mseErrors(runIdx) = mean(mean((Ypred' - Ytest).^2));
    maeErrors(runIdx) = mean(mean(abs(Ypred' - Ytest)));
    
    % Define fitness function
    fitFunc = @(x) ANNSurroFit(x, net, Xmin, Xmax);
    
    % Run optimisation
    [xOptNorm, fValOpt] = gamultiobj(fitFunc, nVars, [], [], [], [], zeros(1, nVars), ones(1, nVars), options);

    % Un-normalise solutions
    xOpt = xOptNorm .* (Xmax - Xmin) + Xmin;
    
    % Store results
    allParetoFronts{runIdx} = fValOpt;
    results(runIdx).xOptNorm = xOptNorm;
    results(runIdx).fValOpt = fValOpt;
    results(runIdx).xOpt = xOpt;
    results(runIdx).net = net;
    results(runIdx).tr = tr;
    results(runIdx).Xmin = Xmin;
    results(runIdx).Xmax = Xmax;

    % Plot current Pareto front
    figure(1); 
    hold on;
    plot(fValOpt(:,1), fValOpt(:,2), 'x', 'DisplayName', ['Run ', num2str(runIdx)]);
end

% Finalise Pareto fronts plot
title('Pareto Fronts Across All Runs');
xlabel('Objective Function 1');
ylabel('Objective Function 2');
legend('show');
grid on;
hold off;
saveas(gcf, 'PartC_PF.png');

% Print MSE and MAE for each run
for runIdx = 1:length(seedVals)
    fprintf('Run %d: MSE = %f, MAE = %f\n', runIdx, mseErrors(runIdx), maeErrors(runIdx));
end

disp('Routine: Part C - Surrogate based Global Search of Auxiliary Function (300 FE limit/run) [COMPLETE]')

elapsed = toc;
disp(['Elapsed time: ', num2str(elapsed), ' seconds']);

% Save all results
save('PartC - ANN');
