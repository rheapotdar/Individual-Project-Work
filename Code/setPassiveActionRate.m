function [ oldActionRate, newActionRate ] = ...
    setPassiveActionRate( reversedRates, actionLabel, definitions )
% helper function in computeSolutionsOfPassiveActionRates(). This function
% matches the passive action rate with the right reversed rate and returns
% both the rates.
    
    for definition = definitions
        definition = definition{1};
        if isequal( definition( 'actionName' ), actionLabel )
            oldActionRate = definition( 'actionRate' );
            definition( 'actionRate' ) = reversedRates( actionLabel );
            newActionRate = definition( 'actionRate' );
        end
    end
end