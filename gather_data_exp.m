close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Code to gather data partially for surrogate models for expensive model
% gathers data then collate into one mat file in another script
% -------------------------------------------------------------------------

% Initialisation
startTime = tic;
rng(1014); % Ensures consistency in LHS generation

model = "Expensive Model";
lowerb = [-10, -50, -200, -1000, -5000, -50000];
upperb = [10, 50, 200, 1000, 5000, 50000];
nVar = numel(lowerb);
maxSamples = 300;
partialEvals = 100; % Adjust if needed for this run

% Manually update for each execution
runNumber = 9;

% Load or initialise evaluatedCount
generalDataFile = 'exp_data_count.mat';
if exist(generalDataFile, 'file')
    load(generalDataFile, 'evaluatedCount'); % global count 
else
    evaluatedCount = 18; % Starting from a previously known count \\ messed up some runs
end

% Files for saving data
fileName = sprintf('exp_data_part_%d.mat', runNumber);
lhsFile = 'exp_data_LHS.mat';

% Generate or load LHS samples
if ~exist(lhsFile, 'file')
    LHx = lhsdesign(maxSamples, nVar, 'criterion', 'maximin', 'iterations', 500);
    scaledSamples = lowerb + (upperb - lowerb) .* LHx;
    save(lhsFile, 'scaledSamples'); % saves global LHS to stay consistent
else
    load(lhsFile, 'scaledSamples'); % loads existing LHS if it exists
end

% Prepare parallel pool for parallelising processes
if isempty(gcp('nocreate'))
    parpool;
end

% Cost function
costFunc = @(x) ExpModel(x);

% Determine the number of evaluations for this run
remainingEvals = maxSamples - evaluatedCount;
evalsThisRun = min(partialEvals, remainingEvals);
setSamples = zeros(evalsThisRun, nVar);
setOptVals = zeros(evalsThisRun, 2);

% Evaluate samples in parallel
parfor i = 1:evalsThisRun
    index = evaluatedCount + i;
    setSamples(i, :) = scaledSamples(index, :);
    setOptVals(i, :) = costFunc(setSamples(i, :));
end

% Update evaluatedCount and save data
evaluatedCount = evaluatedCount + evalsThisRun;
save(fileName, 'setSamples', 'setOptVals');
save(generalDataFile, 'evaluatedCount'); % Save the updated count for future runs

% Output
disp(['Data for run ', num2str(runNumber), ' saved to ', fileName]);
elapsed = toc(startTime);
disp(['Elapsed time: ', num2str(elapsed), ' seconds.']);
