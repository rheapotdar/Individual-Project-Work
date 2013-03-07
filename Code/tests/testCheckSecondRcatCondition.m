function testCheckSecondRcatCondition()

    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere %
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (a, lambda).P(n-1) for n > 1' );
    p = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    assertExceptionThrown( @() checkSecondRcatCondition( p, {'a'} ), ...
        'RCATscript:SecondConditionViolation' );
end