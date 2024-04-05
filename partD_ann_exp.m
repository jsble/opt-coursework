close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Problem:
% Use the SURROGATE based strategy developed at point c) to find the best
% approximation of the true Pareto front for the problem function implemented
% in ExpModel.p (the expensive routine) with at most 300 function evaluations
% of the expensive function.
% 
% This program will be utilsing an Artificial Neural Network (ANN) 
% based approach
% -------------------------------------------------------------------------

% Surrogate based Global Search of Expensive Function - 300 FE limit
% main()
rng('default')
rng(1014)   % setting seed for reproduciblity
tic;

load('exp_dataset.mat');

% Splitting dataset into training and testing
totalSamples = size(expSamples, 1);
trainRatio = 0.7;
numTrainSamples = floor(trainRatio * totalSamples);
numTestSamples = totalSamples - numTrainSamples;

indices = randperm(totalSamples);
trainIndices = indices(1:numTrainSamples);
testIndices = indices((numTrainSamples + 1):end);

Xtrain = expSamples(trainIndices, :);
Ytrain = expOptVals(trainIndices, :);
Xtest = expSamples(testIndices, :);
Ytest = expOptVals(testIndices, :);

% Normalising input variables for training and testing sets
Xmin = min(Xtrain);
Xmax = max(Xtrain);
XtrainNorm = (Xtrain - Xmin) ./ (Xmax - Xmin);
XtestNorm = (Xtest - Xmin) ./ (Xmax - Xmin);

% Defining ANN architecture
nVars = size(expSamples, 2);
hiddenLayerSize = [2*nVars, 2*nVars];
net = fitnet(hiddenLayerSize, 'trainrp');

net.divideParam.trainRatio = 0.7;
net.divideParam.testRatio = 0.15;
net.divideParam.valRatio = 0.15;

disp('Starting ANN training');
[net, tr] = train(net, XtrainNorm', Ytrain');
disp('Finished ANN training');

% Validating ANN with testing set
Ypred = net(XtestNorm');
mseError = mean(mean((Ypred' - Ytest).^2));
maeError = mean(mean(abs(Ypred' - Ytest)));
fprintf('Testing MSE: %.4f\n', mseError);
fprintf('Testing MAE: %.4f\n', maeError);

% GA settings
normLb = zeros(1, nVars);
normUb = ones(1, nVars);
options = optimoptions('gamultiobj', 'Display', 'iter', 'PopulationSize', 100, 'MaxGenerations', 100, 'PlotFcn', 'gaplotpareto');

fitFunc = @(x) ANNSurroFit(x, net, Xmax, Xmin);

disp('Starting optimisation process');
[xOptNorm, fValOpt] = gamultiobj(fitFunc, nVars, [], [], [], [], normLb, normUb, options);
saveas(gcf, 'PartD_PF_Surrogate.png');
close(gcf);

xOpt = xOptNorm .* (Xmax - Xmin) + Xmin;

% Evaluate the expensive function in parallel
if isempty(gcp('nocreate'))
    parpool('local');  % Adjust to use available cores
end
expVals = zeros(size(xOpt, 1), 2);  % Preallocate for expensive function evaluations
parfor i = 1:size(xOpt, 1)
    expVals(i, :) = ExpModel(xOpt(i, :)); 
end

% Plotting the results
figure;
hold on;
plot(fValOpt(:, 1), fValOpt(:, 2), 'bx', 'DisplayName', 'Surrogate Model Predictions');
plot(expVals(:, 1), expVals(:, 2), 'rx', 'DisplayName', 'True Expensive Function Values');
legend('show');
xlabel('Objective Function 1');
ylabel('Objective Function 2');
title('Comparison of Pareto Fronts: Surrogate Model vs. Expensive Function');
saveas(gcf, 'PartD_PF_Comparison.png');

disp('Routine: Part D - Surrogate based Global Search of Expensive Function (300 FE limit) [COMPLETE]')

elapsed = toc;
disp(['Elapsed time: ', num2str(elapsed), ' seconds']);

save('PartD - ANN');
