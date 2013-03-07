function checkSecondRcatCondition( r, coopLabels )
% every reversed action of an active action type in all cooperating process
% is always enabled. This basically checks if there is an incoming active
% action of type a in every state of the active process for a.

    for label = coopLabels
        label = label{1};
        for i = 1:length(r)
            if ismember( label, r(i).activeLabels )
                if ~checkForIncomingTransitions( r(i).definitions, label )
                    throw( MException( 'RCATscript:SecondConditionViolation', ...
                    'RCAT Second Condition is violated. If you think this is an error, then check the pepa description and try again.' ) );
                end
            end
        end
    end
    fprintf( 'Second condition of RCAT is satisfied.\r\n');
end

function isEnabled = checkForIncomingTransitions( definitions, actionLabel )
% Incoming transitions here refer to transitions going from state n -> n-1,
% this assures that every state n will have an incoming transition. The
% domain for these transitions will be [1, Inf] since we are primarily
% dealing with MM1 queues. Change this bound if not.
    syms n;
    isEnabled = false;
    for definition = definitions
        definition = definition{1};
        if isequal( definition( 'actionName' ), actionLabel )
            domain = definition( 'domain' );
            transitionTostate = definition( 'transitionToState' );
            transitionFromState = definition( 'transitionFromState' );
            if isequal( domain(1), 1 ) && isequal( domain(2), Inf )
                if isSymbolicEqual( transitionTostate, eval('n-1') ) && ...
                        isSymbolicEqual( transitionFromState, eval('n') )
                    isEnabled = true;
                end
            end
        end
    end
end