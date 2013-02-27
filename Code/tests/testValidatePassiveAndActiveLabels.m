function testValidatePassiveAndActiveLabels()

    syms n lambda;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere %
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, infinity).P(n-1) for n >= 1' );
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (e, infinity).Q(n-1) for n >= 1' );
    p = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    
    assertExceptionThrown( @() validatePassiveAndActiveLabels( p ), ...
        'RCATscript:ActionPassiveMultipleComponents' );
    
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, lambda).P(n+1) for n >= 0' ); 
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    
    assertExceptionThrown( @() validatePassiveAndActiveLabels( r ), ...
        'RCATscript:ActionPassiveAndActive' );
    
end