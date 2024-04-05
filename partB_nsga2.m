close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Problem: 
% Implement a strategy (NO surrogate based) to find a good approximation 
% of the ENTIRE Pareto front with at most 30000 function evaluations using 
% the auxiliary function in the file AuxModel.p ; the strategy should be 
% reliable and should be tested on 10 independent runs
% (only if a stochastic method is used).
%
% This program will be utilsing the Non-dominating Sorting Genetic
% Algorithm II (NSGA-II) algorithm.
% -------------------------------------------------------------------------

% Non-surrogate based Global Search of Auxiliary Function - 30000 FE limit
% main()
tic;
rng('default')
seedVals = [74, 111, 115, 101, 102, 83, 97, 110, 116, 105];

addpath(".\NSGA-II\")

% declare variables
maxIt = 150;     % change to compare effect
nPop = 200;       % change to compare effect
nRuns = length(seedVals);

% initialise variables
setX = cell(1, nRuns);
setOpt = cell(1, nRuns);
setTotFE = [];

% bounds of the problem
lowerb = [-10, -50, -200, -1000, -5000, -50000];
upperb = [10, 50, 200, 1000, 5000, 50000];
nVar = numel(lowerb);

% objective function
costFunc = @(x) AuxModel(x);

for i = 1:nRuns
    rng(seedVals(i))
    [F1, FEcount] = NSGA2(costFunc, nVar, lowerb, upperb, maxIt, nPop, seedVals(i));
    
    % Extract positions and costs from F1 for each run
    currentX = arrayfun(@(s) s.Position, F1, 'UniformOutput', false);
    currentOpt = arrayfun(@(s) s.Cost, F1, 'UniformOutput', false);
    
    currentXMat = vertcat(currentX{:});
    currentOptMat = vertcat(currentOpt{:});

    setX{i} = arrayfun(@(x) x.Position, F1, 'UniformOutput', false);
    setOpt{i} = arrayfun(@(x) x.Cost, F1, 'UniformOutput', false);   
    setTotFE = [setTotFE; FEcount];
end

elapsed = toc; % time to run all 10 algorithms

% plot all fronts on one figure
colours = lines(nRuns);
figure('Name', 'All Pareto Fronts - 10 runs')
hold on

for runIdx = 1:nRuns
    startIdx = (runIdx - 1) * nPop + 1;
    endIdx = runIdx * nPop;
    
    currentF1 = cell2mat(setOpt{runIdx});
    plot(currentF1(:, 1), currentF1(:, 2), 'x', 'Color', colours(runIdx, :));
end

hold off
xlabel('Objective Function 1');
ylabel('Objective Function 2');
title('All Pareto Fronts - 10 runs');
legend({'Run 1', 'Run 2', 'Run 3', 'Run 4', 'Run 5', 'Run 6', 'Run 7', 'Run 8', 'Run 9', 'Run 10'}, 'Location', 'best');
grid on;
saveas(gcf, 'PartB_PF.png');

disp(['Total Number of Function Evaluations: ' num2str(sum(setTotFE))])
disp('Routine: Part B - Non-surrogate based Global Search of Auxiliary Function (30000 FE limit) [COMPLETE]')
disp(['Elapsed time: ', num2str(elapsed), ' seconds']);

save("PartB - NSGA2")
