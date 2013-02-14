function testGetStatesAndRateForAction()
    
    syms n lambda;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere %
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, lambda).P(n+1) for n >= 0' );    
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    [ fromState, toState, rate ] = getStatesAndRateForAction( 'e', r(1) );
    
    assertTrue( fromState == n );
    assertTrue( toState == n+1 );
    assertTrue( rate == lambda );
end