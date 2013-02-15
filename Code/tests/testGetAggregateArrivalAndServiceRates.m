function testGetAggregateArrivalAndServiceRates

    syms lambda mu1;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere%
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, lambda).P(n+1) for n >= 0' );
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    [ forwardSum, backwardSum ] = getAggregateArrivalAndServiceRates( r(1) );
    
    assertTrue( isequal( forwardSum,lambda ) );
    assertTrue( isequal( backwardSum, 0) );
    
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (f, mu1).P(n-1) for n >= 0' );
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (g, 2*lambda).P(n+1) for n >= 0' );
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    [ forwardSum, backwardSum ] = getAggregateArrivalAndServiceRates( r(1) );
    
    assertTrue( isequal( forwardSum, 3*lambda) );
    assertTrue( isequal( backwardSum, mu1) );
end