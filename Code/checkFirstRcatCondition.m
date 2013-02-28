function checkFirstRcatCondition( r, stateSpace )
% every passive action type in all cooperating components is always enabled
% (i.e. enabled in all states of the transition graph)

    for i = 1:length(r)
        if ~isempty( r(i).passiveLabels )
            for label = r(i).passiveLabels
                label = label{1};
                if ~checkActionIsEnabled( label, r(i).definitions, stateSpace )
                    throw( MException( 'RCATscript:FirstConditionViolation', ...
                    'RCAT First Condition is violated. If you think this is an error, then check the pepa description and try again.' ) );
                end
            end
        end
    end
    fprintf( 'First condition of RCAT is satisfied.\r\n');
end