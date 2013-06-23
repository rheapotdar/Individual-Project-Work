function [ forwardSum, backwardSum ] = getAggregateArrivalAndServiceRates( process )
% This function is used to calculate the total forward rate and total
% backward rate of a process. This is used for calculating the sspd of
% a process id MM1.
% Input: Please supply a process, such as p(1) where p is the struct.
    
    forwardSum = 0;
    backwardSum = 0;
    
    for definition = process.definitions
        definition = definition{1};
        if isTransitioningForwards( definition )
            forwardSum = forwardSum + definition('actionRate');
        else
            if ~(eval( definition('transitionToState') - ...
                    definition('transitionFromState') ) == 0)
                backwardSum = backwardSum + definition('actionRate');
            end
        end
    end
end