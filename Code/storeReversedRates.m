function reversedRates = storeReversedRates( coopLabels, r )
% This function stores reversed rates with the coop action labels as key.
% Will be used in evaluating the passive action rates

    reversedRates = containers.Map();
    for action = coopLabels
        action = action{1};
        % r(k) can only have k = 1 or 2 
        for i = 1:2
            if ismember( action, r(i).activeLabels )
                [arrivalRate, serviceRate] = getAggregateArrivalAndServiceRates( r(i) );
                [fromState, toState, rate] = getStatesAndRateForAction( action, r(i) );
                iSSPD = sspdMM1( fromState, arrivalRate, serviceRate );
                jSSPD = sspdMM1( toState, arrivalRate, serviceRate );
                reversedRate = calculateReversedRate( rate, iSSPD, jSSPD );
                reversedRates( action ) = reversedRate;
            end
        end
    end   
end