function calculatePassiveRatesForBBs( connections, bbStruct )
    
    fprintf( 'Printing rate equations\r\n' );
    passiveTransitions = connections.keys;
    for i = 1:length( connections )
        connectorList = connections( passiveTransitions{i} );
        actionRate = getActionRateForSPNs( passiveTransitions{i} , bbStruct );
        getRateEquations( bbStruct, connectorList , passiveTransitions{i}, actionRate )
    end
    
end

function getRateEquations( bbStruct, connectorList , actionLabel, passiveActionRate )
    oldActionRate = passiveActionRate;
    for i = 1:length( connectorList )
        map = connectorList{i};
        label = map.keys;
        if i == 1
           passiveActionRate =  getReversedRateForBB( bbStruct, label{1} )...
               * map( label{1} );
        else
           passiveActionRate =  passiveActionRate + ...
               getReversedRateForBB( bbStruct, label{1} ) * map( label{1} );
        end
    end
    fprintf( 'Rate equation for %s: %s = %s\r\n',...
                      actionLabel, char(oldActionRate), char(passiveActionRate) );
end


