function reversedRate = calculateReversedRate( forwardRate, iStateSSPD, jStateSSPD )
% This function calculates the reversed rate based on the formula given in
% the generic algorithm for rcat.

    formula = (forwardRate * iStateSSPD) / jStateSSPD;
    reversedRate = simplify(formula); 
end