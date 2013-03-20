function testCreateRk

    syms lambda n x_a;
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    % assuming registered process works since it is unit tested elsewhere%
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'P(n) = (e, lambda).P(n+1) for n >= 0' );
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'Q(n) = (a, infinity).Q(n+1) for n >= 0' );
    registerProcess( registeredProcesses, activeActionLabels,...
        passiveActionLabels, 'R(n) = (d, infinity).R(n+1) for n >= 0' );
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    
    len = size( r );
    %checks if multiple ages are accepted as input
    assertEqual( len( :, 2 ), 3 );
    % since each process has only one definition
    P = r(1).definitions;
    assertEqual( length( P ), 1 );
    P = P{1};
    assertEqual( P( 'actionName' ), 'e' ) 
    assertEqual( P( 'actionRate' ), lambda )
    assertEqual( P( 'transitionFromState' ), eval('n') ) 
    assertTrue( isequal( P( 'transitionToState' ), n+1 ) )
    
    assertEqual( length( r(1).activeLabels ), 1 );
    assertEqual( length( r(2).passiveLabels ), 1 );
    assertEqual( length( r(1).passiveLabels ), 0 );
    assertEqual( r(1).activeLabels{1}, 'e' );
    assertEqual( r(2).passiveLabels{1}, 'a' );
    
end