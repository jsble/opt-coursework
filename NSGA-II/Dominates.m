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

function b = Dominates(x, y)

    if isstruct(x)
        x = x.Cost;

    end
    if isstruct(y)
        y = y.Cost;

    end

    b = all(x <= y) && any(x<y);

end
