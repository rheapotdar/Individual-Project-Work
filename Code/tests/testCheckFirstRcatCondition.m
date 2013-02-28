function testCheckFirstRcatCondition()

    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere %
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, infinity).P(n-1) for n > 0' );
    p = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    assertExceptionThrown( @() checkFirstRcatCondition( p, [0,Inf] ), ...
        'RCATscript:FirstConditionViolation' );
    
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere %
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, infinity).P(n+1) for n > 0' );
    p = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    
    assertExceptionThrown( @() checkFirstRcatCondition( p, [0,Inf] ), ...
        'RCATscript:FirstConditionViolation' );
end