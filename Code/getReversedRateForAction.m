function reversedRate = getReversedRateForAction( r, action )
% This is a helper function designed to calculate the reversed rate for
% action given. It helps in third condition checking where reversed rates
% are checked if equal for an action with multiple transitions.

    [arrivalRate, serviceRate] = getAggregateArrivalAndServiceRates( r );
    [fromState, toState, rate] = getStatesAndRateForAction( action, r );
    iSSPD = sspdMM1( fromState, arrivalRate, serviceRate );
    jSSPD = sspdMM1( toState, arrivalRate, serviceRate );
    
    reversedRate = calculateReversedRate( rate, iSSPD, jSSPD );
    
    if isnan( reversedRate )
        throw( MException( ...
            'RCATscript:InvalidComputationStoreReversedRates',...
            'Error in calculating reversed rate' ) );
    end
end