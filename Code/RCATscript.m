% TELL THE USER : make labels standardised in terms of n only. Can k only
% equal 1 or 2 (only 2 agents coop?) Rates have to be symbolic and HAVE to
% begin with a letter to be parsed.
% pi as input is given symbollically or as 'MM1 with arrival rate and
% service rate functions.' TODO: need to make the sspd toggle
    

function output = RCATscript( processList, coopString )
    
    %Defining global variables
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();
    
    %Todo: define state space from given info.
    stateSpace = [0, Inf];

    %Setup%
    for i = 1:length( processList )
        process = processList(i);
        registerProcess( registeredProcesses, activeActionLabels, ...
            passiveActionLabels, process{1} );
    end
    coopLabels = registerCoop( coopString );
    %setup done% 
    %Step 1%
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    % Validate syntax %
    validatePassiveAndActiveLabels( r );
    %Step %
    checkFirstRcatCondition( r, stateSpace );
    checkSecondRcatCondition( r, coopLabels );
    %Step 2%
    reversedRates = storeReversedRates( coopLabels, r );
    %Step 3%
    computeSolutionsOfPassiveActionRates( r, reversedRates );
    output = r;
    
end