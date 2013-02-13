function registerProcess( registeredProcesses, activeActionLabels, passiveActionLabels, processDescription )
    % This function parses input for each PEPA component defined and adds
    % it to a process structure. It also runs sanity checks on the input.
    % Example: 'P(n) = (e, lambda).P(n+1) for n >= 0'
    
    matches = regexp( processDescription, '([A-Z])\((.+)\) = \((.+), (.+)\)\.([A-Z])\((.+)\)(?: for )?(.*)', 'tokens' );
    addToProcessStructure(registeredProcesses, activeActionLabels, passiveActionLabels, matches{1});
end

function addToProcessStructure( registeredProcesses, activeActionLabels, passiveActionLabels, processDefinition )
% This function stores the processes based on their descriptions. So 2
% descriptions of a single Process P will be stored under the same value 'P'.
% It also relables all action rates with 'infinity'. So a process with
% action rate 'infinity' and action label 'a' will be relabelled as 'x_a'.
% This is for enabling all passive actions in a Process.
    
    processToRegister = processDefinition{1};
    actionRate = processDefinition{4};
    actionLabel = processDefinition{3};
    domain = convertToMatlabFunction( processDefinition{7} );
    
    
    % relabelling passive action rates and creating active action and 
    % passive action labels.
    if isequal( actionRate, 'infinity')
        actionRate = strcat( 'x', '_', actionLabel );
        appendToCellArrayWithinMap( passiveActionLabels, processToRegister, actionLabel );
    else
        appendToCellArrayWithinMap( activeActionLabels, processToRegister, actionLabel );
    end 
    
    % n is made symbolic so that the transition states such as "n+1" are stored
    % as expressions not strings and thus can be used in formula maipulation.
    syms n;
    %Please Note: All rates are made symbolic here -> TODO: consider case
    %when rates are not symbolic!
    % Making action rates symbolic expresssions!
    actionRate = stringToMatlabExpr(actionRate);
    
    keyset = { 'transitionFromState', 'actionName', 'actionRate', 'transitionToState', 'domain' };
    valueset = { eval(processDefinition{2}), actionLabel, actionRate, eval(processDefinition{6}), domain };
    
    processMap = containers.Map(keyset, valueset);
    appendToCellArrayWithinMap( registeredProcesses, processToRegister, processMap );    
end