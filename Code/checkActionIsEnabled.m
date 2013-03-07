function isEnabled = checkActionIsEnabled( actionLabel, definitions, stateSpace )
% helper function in checkFirstRcatCondition(...). This function
% checks if action is enabled in all states of transition graph.
% ASSUMPTIONS are made here. Check if these if problems debugging. They are
% 1. state space is (0 to Infinity). 2. Assumes that all n->n+1 transitions
% are n>=0 and all n->n-1 transitions are n>0. 3. An action to be enabled
% in n->n-1, it must have an invisible transition from n->n for n=0.

    allDefs = definitions;
    isEnabled = false;
    for definition = definitions
        definition = definition{1};
        if isequal( definition( 'actionName' ), actionLabel )
            if ~isequal( definition( 'domain' ), stateSpace )
                if allChecksAreOK( definition, allDefs )
                    isEnabled = true;
                end
            % if the domain is the state space then it is obviously enabled
            % in all the states of the transition graph.
            else
                isEnabled = true;
            end
        end
    end
end

function ret = allChecksAreOK( definition, allDefs )
% returns false if
% 1. domain is 1 and transition is going from n -> n+1.
% 2. domain is 1 and transition is going from n -> n-1 and there are no
% invisible transitions present from n -> n.

    domain = definition( 'domain' );
    transitionTostate = definition( 'transitionToState' );
    ret = false;
    syms n
    if isequal( domain(1), 1 )
        if isSymbolicEqual( transitionTostate, eval('n-1') )
            %iterate over to see if any indication of invisible transitions
            if hasInvisibleTransition( allDefs, definition )
                ret = true;
            end
        end
    end
end

function hasTransition = hasInvisibleTransition( definitions, myDefinition )
    hasTransition = false;
    syms n
    for definition = definitions
        definition = definition{1};
        if isequal( definition( 'actionName' ), myDefinition( 'actionName' ) )
            if isequal( definition( 'domain' ), [0,0] ) && ...
                    isSymbolicEqual( definition( 'transitionToState' ), eval('n') )
                hasTransition = true;
            end
        end
    end
end