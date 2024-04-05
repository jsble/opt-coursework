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


function PlotCosts(pop)

    Costs = vertcat(pop.Cost);
    
    plot(Costs(:, 1), Costs(:, 2), 'bx');
    xlabel('Objective Function 1');
    ylabel('Objective Function 2');
    title('Non-dominated Pareto Front (F_{1})');
    grid on;

end