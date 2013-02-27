function testRegisterProcess()
    syms lambda n x_a;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();    

    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, lambda).P(n+1) for n >= 0' );
    assertEqual( registeredProcesses.length(), 1 )
    P = registeredProcesses( 'P' );
    P = P{1};
    assertEqual( P( 'actionName' ), 'e' ) 
    assertEqual( P( 'actionRate' ), lambda )
    assertEqual( P( 'transitionFromState' ), eval('n') ) 
    assertTrue( isequal( P( 'transitionToState' ), n+1 ) ) 
    
    % Test the domain function by giving it actual values (since we can't
    % check the Matlab function converted from a string, will work as
    % expected)
    domain = P( 'domain' );
    assertTrue( isequal( 0, domain(1) ) );
    assertTrue( isequal( Inf, domain(2) ) );
    
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (a, infinity).Q(n+1) for n >= 0' );
    assertEqual( registeredProcesses.length(), 2 )
    Q = registeredProcesses( 'Q' );
    Q = Q{1};
    assertEqual( Q( 'actionRate' ), x_a )
    
    % the input has one process with active action type and one with
    % passive action type. Thus the foll. assertions
    assertEqual( activeActionLabels.length(), 1 )
    assertEqual( activeActionLabels('P'), { P('actionName') } )
    assertEqual( passiveActionLabels.length(), 1 )
    assertEqual( passiveActionLabels('Q'), { Q('actionName') } )
    
    %checking input validations
    assertExceptionThrown( @() registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = a, infinity)   Q(n+1)  n >= 0' ), ...
        'RCATscript:InvalidInputParsedRegisterProcess' );
    assertExceptionThrown( @() registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, '' ), 'RCATscript:InvalidInputRegisterProcess' );
    assertExceptionThrown( @() registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (2e, infinity).Q(n+1) for n >= 0' ),...
        'RCATscript:NumericActionLabel' );
    assertExceptionThrown( @() registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (e, infinity).F(n+1) for n >= 0' ),...
        'RCATscript:ProcessTransitionSyntax' );
end