function [ fromState, toState, rate ] = getStatesAndRateForAction( actionLabel, process )
% This function returns the states an action transitions from and the
% rate of the instance of action type a going out of that state. This
% is used in calculating the reversed rate for specified action.
% Assumption made here is that in one process there cannot be multiple
% transitions for the same action.
    
    fromState = 0;
    toState = 0;
    rate = 0;
    for definition = process.definitions
        definition = definition{1};
        if isequal( actionLabel, definition( 'actionName' ) )
            fromState = definition( 'transitionFromState' );
            toState = definition( 'transitionToState' );
            rate = definition( 'actionRate' );
        end
    end  
end