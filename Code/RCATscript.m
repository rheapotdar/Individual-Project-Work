% TELL THE USER : make labels standardised in terms of n only.
    

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
    % Condition check %
    checkFirstRcatCondition( r, stateSpace );
    checkSecondRcatCondition( r, coopLabels );
    checkThirdRcatCondition( coopLabels, r )
    %Step 2%
    reversedRates = storeReversedRates( coopLabels, r );
    %Step 3%
    computeSolutionsOfPassiveActionRates( r, reversedRates );
    output = r
    
end
