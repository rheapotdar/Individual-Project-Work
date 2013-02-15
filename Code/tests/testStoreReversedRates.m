function testStoreReversedRates
    
    syms lambda;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere %
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, lambda).P(n+1) for n >= 0' );
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (a, mu1).P(n-1) for n > 0' );
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (a, infinity).Q(n+1) for n >= 0' );    
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (d, mu2).Q(n+1) for n > 0' );
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    coopLabels = { 'a' };
    reversedRates = storeReversedRates( coopLabels, r );
    
    assertEqual( reversedRates.length(), 1);
    assertTrue( isequal( reversedRates( 'a' ), lambda ) );
    
    coopLabels = { 'd' };
    assertExceptionThrown( @() storeReversedRates( coopLabels, r ),...
        'RCATscript:InvalidComputationStoreReversedRates' );
end