function checkThirdRcatCondition( coopLabels, r )
% every passive action type in all cooperating components is always enabled
% (i.e. enabled in all states of the transition graph)

    for action = coopLabels
        action = action{1};
        
        for i = 1:length(r)
            if ismember( action, r(i).activeLabels )
                [ret, fromStates, toStates, rates] = ...
                    checkForMultipleTransitionsAndGetsRates( r(i), action );
                if ret
                    if ~checkAllRatesAreSame( fromStates, toStates, rates, r(i) )
                        throw( MException( 'RCATscript:ThirdConditionViolation', ...
                            'RCAT Third Condition is violated. Check the pepa description and try again.' ) );
                    end
                end
            end
        end
    end
    fprintf( 'Third condition of RCAT is satisfied.\r\n');

end

function [ret, fromStates, toStates, rates] = ...
    checkForMultipleTransitionsAndGetsRates( process, actionLabel )

    counter = 0;
    for definition = process.definitions
        definition = definition{1};
        if isequal( actionLabel, definition( 'actionName' ) )
            counter = counter + 1;
            fromStates{counter} = definition( 'transitionFromState' );
            toStates{counter} = definition( 'transitionToState' );
            rates{counter} = definition( 'actionRate' );
        end
    end
    
    ret = ( counter > 0 );
end

function check = checkAllRatesAreSame( fromStates, toStates, rates, r )

    check = 1;
    [arrivalRate, serviceRate] = getAggregateArrivalAndServiceRates( r );
    for i=1:length( rates )
        iSSPD = sspdMM1( fromStates{i}, arrivalRate, serviceRate );
        jSSPD = sspdMM1( toStates{i}, arrivalRate, serviceRate );
        reversedRates{i} = calculateReversedRate( rates{i}, iSSPD, jSSPD );
    end
    
    for i=2:length( reversedRates )
        check = isSymbolicEqual( rates{i-1}, rates{i} );
        
        if ~check
            break;
        end
    end
end