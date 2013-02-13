function isGoingForward = isTransitioningForwards( procesDefinition )
% This function is to figure out if a process transition is going forwards or backwards
% Both params must be symbolic equations.
    
    isGoingForward = eval( procesDefinition('transitionToState') - procesDefinition('transitionFromState') ) > 0;
end