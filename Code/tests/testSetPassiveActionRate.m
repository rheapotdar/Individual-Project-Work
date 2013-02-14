function testSetPassiveActionRate
    % setup test data %
    syms lambda other x_a;
    actionLabel = 'a';
    reversedRates = containers.Map( {actionLabel}, {lambda} );
    keyset = {'actionName', 'actionRate'};
    definitions{1} = containers.Map( keyset,{'b', other} );
    definitions{2} = containers.Map( keyset,{'a', x_a} );
    
    % test case where x_a the passive rate %
    [ oldActionRate, newActionRate ] = setPassiveActionRate( reversedRates, actionLabel, definitions );
    assertTrue( oldActionRate == x_a );
    assertTrue( newActionRate == lambda );
end