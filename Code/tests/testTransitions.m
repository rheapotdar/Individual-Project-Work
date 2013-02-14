function testTransitions()
    procesDefinition = containers.Map();
    syms n;
    procesDefinition('transitionFromState') = n+1;
    procesDefinition('transitionToState') = n;
    isGoingForward = isTransitioningForwards( procesDefinition );
    assertFalse( isGoingForward )
end