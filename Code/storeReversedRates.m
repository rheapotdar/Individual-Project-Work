function reversedRates = storeReversedRates( coopLabels, r )
% This function stores reversed rates with the coop action labels as key.
% Will be used in evaluating the passive action rates. Assumes that the
% contents of coopLabels is passive. If not symbolic var NaN is returned!!

    reversedRates = containers.Map();
    for action = coopLabels
        action = action{1};
        
        for i = 1:length(r)
            if ismember( action, r(i).activeLabels )
                reversedRate = getReversedRateForAction( r(i) , action );
                reversedRates( action ) = reversedRate;
            end
        end
    end   
end