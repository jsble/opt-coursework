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

function pop = CalcCrowdingDistance(pop, F)

    nF = numel(F);

    for k = 1:nF
        Costs = [pop(F{k}).Cost];
        nObj = size(Costs, 1);
        n = numel(F{k});
        d = zeros(n, nObj);

        for j = 1:nObj
            [cj, so] = sort(Costs(j, :));
            d(so(1), j) = inf;

            for i = 2:n-1
                d(so(i), j) = abs(cj(i+1)-cj(i-1))/abs(cj(1)-cj(end));

            end
            d(so(end), j) = inf; 

        end
        for i = 1:n
            pop(F{k}(i)).CrowdingDistance = sum(d(i, :));

        end
    end
end
