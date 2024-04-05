function objVal = auxMask(x, objIdx, costFunc)
    % This function determines which objective function to minimise for 
    % part a) of the assignment using the auxiliary function
    F = costFunc(x);
    objVal = F(objIdx);
end