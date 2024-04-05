close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Problem: 
% Using the auxiliary function in the file AuxModel.p, 
% find the global minimum of F(1 ) with a precision of 4 decimal digits, 
% and the global minimum of F(2) with a precision of 1 decimal digit.
%
% This program will be utilsing the Genetic Algorithm MATLAB built-in
% function
% -------------------------------------------------------------------------

% Global Minimum of Auxiliary Function - no limit
% main()
tic;
rng('default')
rng(1014)   % setting seed for reproduciblity

% bounds of the problem
lowerb = [-10, -50, -200, -1000, -5000, -50000];
upperb = [10, 50, 200, 1000, 5000, 50000];

% declaring variables
nVar = numel(lowerb);
nPop = 1000;
maxGen = 500;
recombRate = 0.9;   % change to compare outputs

% objective function
costFunc = @AuxModel;
objIdx = 1;     % choose which objective function to optimise | 1 or 2

options = optimoptions('ga', ...
    'Display', 'iter', ...
    'PopulationSize', nPop, ...
    'MaxGenerations', maxGen, ...
    'CrossoverFraction', recombRate);

% run ga with mask function for choosing which objective function to
% optimise
[xVal, optVal, ~, OUTPUT] = ga(@(x) aux_mask(x, objIdx, costFunc), nVar, [], [], [], [], lowerb, upperb, [], options);

elapsed = toc;

% Display results
disp(['Optimized Design Variables for Objective ', num2str(objIdx), ':']);
disp(xVal);
disp(['Objective Function Value: ', num2str(optVal)]);

disp(['Total Number of Function Evaluations: ' num2str(OUTPUT.funccount)])
disp('Routine: Part A - Global Minimum of Auxiliary Function (no limit) [COMPLETE]')
disp(['Elapsed time: ', num2str(elapsed), ' seconds']);

save("PartA - GA - F1")
