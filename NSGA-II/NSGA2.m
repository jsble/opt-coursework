%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% -------------------------------------------------------------------------
% Modified by Josef Manlutac
% 
% For ME527 Coursework 2024

function [F1, countFE] = NSGA2(CostFunction, nVar, LowerB, UpperB, MaxIt, nPop, seedNum)

    VarSize = [1 nVar];
    countFE = 0;
    maxFE = 30000; % set max function evaluations

    % Number of Objective Functions
    nObj = numel(CostFunction(unifrnd(LowerB, UpperB, VarSize)));

    %% NSGA-II Parameters
    
    pCrossover = 0.7;                         % Crossover Percentage
    nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parents (Offsprings)
    
    pMutation = 0.4;                          % Mutation Percentage
    nMutation = round(pMutation*nPop);        % Number of Mutants
    
    mu = 0.02;                    % Mutation Rate
    
    sigma = 0.1*(UpperB-LowerB);  % Mutation Step Size
    
    
    %% Initialisation
    
    empty_individual.Position = [];
    empty_individual.Cost = [];
    empty_individual.Rank = [];
    empty_individual.DominationSet = [];
    empty_individual.DominatedCount = [];
    empty_individual.CrowdingDistance = [];
    
    pop = repmat(empty_individual, nPop, 1);
    
    for i = 1:nPop
        pop(i).Position = LowerB + (UpperB - LowerB) .* lhsdesign(1, nVar, 'Iterations',1000);
        pop(i).Cost = CostFunction(pop(i).Position);
        countFE = countFE + 1;
    end
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);
    
    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);
    
    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    
    %% NSGA-II Main Loop
    
    for it = 1:MaxIt
        
        % Crossover
        popc = repmat(empty_individual, nCrossover/2, 2);
        for k = 1:nCrossover/2
            
            i1 = randi([1 nPop]);
            p1 = pop(i1);
            
            i2 = randi([1 nPop]);
            p2 = pop(i2);
            
            [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);
            
            popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
            popc(k, 2).Cost = CostFunction(popc(k, 2).Position);
            countFE = countFE + 2;
        end

        popc = popc(:);
        
        % Mutation
        popm = repmat(empty_individual, nMutation, 1);
        for k = 1:nMutation
            
            i = randi([1 nPop]);
            p = pop(i);
            
            popm(k).Position = Mutate(p.Position, mu, sigma, LowerB, UpperB);
            
            popm(k).Cost = CostFunction(popm(k).Position);
            countFE = countFE + 1;
            
        end
        
        % Merge
        pop = [pop
             popc
             popm]; %#ok
         
        % Non-Dominated Sorting
        [pop, F] = NonDominatedSorting(pop);
    
        % Calculate Crowding Distance
        pop = CalcCrowdingDistance(pop, F);
    
        % Sort Population
        pop = SortPopulation(pop);
        
        % Truncate
        pop = pop(1:nPop);
        
        % Non-Dominated Sorting
        [pop, F] = NonDominatedSorting(pop);
    
        % Calculate Crowding Distance
        pop = CalcCrowdingDistance(pop, F);
    
        % Sort Population
        [pop, F] = SortPopulation(pop);
        
        % Store F1
        F1 = pop(F{1});
        
        % Show Iteration Information
        disp(['Run ' num2str(seedNum) ' Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
        
        % Plot F1 Costs
        %figure(1);
        %PlotCosts(F1);
        %pause(0.01);

    if countFE > maxFE
        disp(['Maximum function evaluations of ' num2str(maxFE) ' reached at iteration ', num2str(it), ' at a count of ' num2str(countFE)]);
        disp('EXITING LOOP')
        break;
    end
    end
end
