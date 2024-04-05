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


function y = Mutate(x, mu, sigma, lowerb, upperb)
    nVar = numel(x);
    nMu = ceil(mu*nVar);
    j = randsample(nVar, nMu);

    if numel(sigma) > 1
        sigma = sigma(j);
    end
    
    y = x;
    y(j) = x(j) + sigma .* randn(size(j));
    
    % Ensure bounds are respected
    y(j) = max(y(j), lowerb(j));
    y(j) = min(y(j), upperb(j));
end
