close all
clear
clc

% main()
rng('default')
rng(1014)   % setting seed for reproduciblity
tic;

% bounds of the problem
lowerb = [-10, -50, -200, -1000, -5000, -50000];
upperb = [10, 50, 200, 1000, 5000, 50000];

fitnessFunc = @(x) AuxModel(x);

x = rand(1,6)

a = fitnessFunc(x)

disp('Routine: Part {} - {} [COMPLETE]')

elapsed = toc;
disp(['Elapsed time: ', num2str(elapsed), ' seconds']);


% functions
