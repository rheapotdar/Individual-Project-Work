function testComputeSolutionsOfPassiveActionRates

    syms lambda x_a;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    reversedRates = containers.Map( { 'a' }, { lambda } );
    % assuming registered process works since it is unit tested elsewhere%
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (a, infinity).Q(n+1) for n >= 0' );
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    temp = r(1).definitions;
    defs = temp{1};
    oldActionRate = defs( 'actionRate' );
    computeSolutionsOfPassiveActionRates( r, reversedRates );
    temp = r(1).definitions;
    defs = temp{1};
    
    assertTrue( isequal( oldActionRate, x_a ) );
    assertFalse( isequal( defs( 'actionRate' ), oldActionRate ) );
    
    newActionRate = defs( 'actionRate' );
    assertTrue( isequal( newActionRate, lambda ), ...
        'Old passive rate has not been replaced by new calculated rate' );
end