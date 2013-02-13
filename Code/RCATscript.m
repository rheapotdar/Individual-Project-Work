% TELL THE USER : make labels standardised in terms of n only. Can k only
% equal 1 or 2 (only 2 agents coop?) Rates have to be symbolic and HAVE to
% begin with a letter to be parsed.
% pi as input is given symbollically or as 'MM1 with arrival rate and
% service rate functions'
    

function output = RCATscript( processList, coopString )
    
    %Defining global variables
    registeredProcesses = containers.Map();
    activeActionLabels = containers.Map();
    passiveActionLabels = containers.Map();    

    %Setup%
    for process = processList
        registerProcess( registeredProcesses, activeActionLabels, passiveActionLabels, process{1} );
    end
    coopLabels = registerCoop( coopString );
    %setup done%
    %Step 1%
    r = createRk( registeredProcesses, activeActionLabels, passiveActionLabels );
    %Step 2%
    reversedRates = storeReversedRates( coopLabels, r );
    %Step %
    computeSolutionsOfPassiveActionRates( r, reversedRates );
    output = r;
    
end