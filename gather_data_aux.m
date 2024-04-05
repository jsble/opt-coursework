close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Code to gather data for surrogate model for auxiliary function
% -------------------------------------------------------------------------

startTime = tic;
rng('default')
seedVals = [74, 111, 115, 101, 102, 83, 97, 110, 116, 105];     % seed for reproducibility
nRuns = length(seedVals);
model = "Auxiliary Model";

% bounds of the problem
lowerb = [-10, -50, -200, -1000, -5000, -50000];
upperb = [10, 50, 200, 1000, 5000, 50000];
nVar = numel(lowerb);
maxSamples = 300;   % maximum limit
nIter = 500;
setSamples = zeros(maxSamples*nRuns, nVar);
setOptVals = zeros(maxSamples*nRuns, 2);

costFunc = @(x) AuxModel(x);

for runIdx = 1:nRuns
    rng(seedVals(runIdx));
    LHx = lhsdesign(maxSamples, nVar, 'criterion', 'maximin', 'iterations', nIter);     % generate a new LHS for each run
    scaledSamples = lowerb + (upperb - lowerb) .* LHx;

    startIdx = (runIdx - 1)*maxSamples + 1;
    endIdx = runIdx * maxSamples;
    setSamples(startIdx:endIdx, :) = scaledSamples;

    for i = startIdx:endIdx
        disp(['Processing Run ', num2str(runIdx), ' | Evaluating Sample ', num2str(i)])
        setOptVals(i, :) = costFunc(setSamples(i, :));      % evaluate the samples
        currentElapsed = toc;
        disp(['Current elapsed time: ', num2str(currentElapsed), ' seconds']);

    end
end

elapsed = toc;
disp(['Routine: Gathering Data - ', model, ' [COMPLETE]'])
disp(['Elapsed time: ', num2str(elapsed), ' seconds']);

save("aux_dataset.mat");