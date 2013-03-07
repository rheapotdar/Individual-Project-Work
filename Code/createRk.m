function r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels )
% this function creates the structure Rk used in the RCAT algorithm.
% It has 3 fields :
% 1. Definitions which stores the transition info (with action label and
% rate) 2. Active labels which have all the active actions 3. Passive
% labels which have all passive (and enabled) actions. If a process has no
% passive actions then it will store an empty set. 
    
    r = struct( 'definitions', {}, 'activeLabels', {}, 'passiveLabels', {} );
    numOfProcesses = length( registeredProcesses );
    processKeyset = keys( registeredProcesses );

     
    for i = 1:numOfProcesses
       r(i).definitions = registeredProcesses( processKeyset{1,i} );
       r(i).activeLabels = setActionLabels( activeActionLabels, processKeyset{1,i} );         
       r(i).passiveLabels = setActionLabels( passiveActionLabels, processKeyset{1,i} );
    end

end

function value = setActionLabels( labelMap, key )
% helper function in 'createRk()'
    if ~isKey( labelMap, key )
        value = {};
    else
        value = unique(labelMap( key ));
    end
end