% TELL THE USER : make labels standardised in terms of n only. Can k only
% equal 1 or 2 (only 2 agents coop?)
% pi as input is given symbollically or as 'MM1 with arrival rate and
% service rate functions'
    


function output = RCATscript()
    
    %Defining global variables
    global registeredProcesses 
    registeredProcesses = containers.Map();
    global activeActionLabels
    activeActionLabels = containers.Map();
    global passiveActionLabels
    passiveActionLabels = containers.Map();
    global coopLabels
    coopLabels = {};
    global reversedRates
    reversedRates = containers.Map();
    global r
    r = struct( 'definitions', {}, 'activeLabels', {}, 'passiveLabels', {} );
    
    registerProcess( 'P(n) = (e, lambda).P(n+1) for n >= 0' );
    registerProcess( 'P(n) = (a, mu1).P(n-1) for n > 0' );
    registerProcess( 'Q(n) = (a, infinity).Q(n+1) for n >= 0' );
    registerProcess( 'Q(n) = (d, mu2).Q(n+1) for n > 0' );
    registerCoop( 'P(0) with Q(0) over {a}' );
    
    createRk();
    storeReversedRates();
    output = reversedRates;
    
end

function registerCoop( coopDescription )
    % This function parses input for cooperation (synchronisation) between 
    % two processes. It stores the action labels the processes are
    % cooperating on. It also runs sanity checks on the inupt.
    % Example coop: "P(0) with Q(0) over {a}"
    
    global coopLabels
    
    %TODO: check if coop is empty. If yes then throw error!
    matches = regexp( coopDescription, '([A-Z])\((.+)\) with ([A-Z])\((.+)\) over \{(.+)\}', 'tokens' );
    matches = matches{1};
    
    
    leftProcess = matches{1};
    leftStartState = matches{2};
    rightProcess = matches{3};
    rightStartState = matches{4};
    coopLabels = regexp( matches{5}, '\s*,\s*', 'split' );
    
    validateCoop( leftProcess, leftStartState, rightProcess, rightStartState, coopLabels )
end

function validateCoop( leftProcess, leftStartState, rightProcess, rightStartState, coopLabels )
    %FIXME: to be completed
    
    global registeredProcesses
    
    % TODO: what happes if the user calls validateCoop before
    % registerProcess?
    % TODO: check if the actions are actually in all processes registered.
    % TODO: check if coop actions are passive in atleast one p.
    
    % Check the processes are in the structures
    if ~isKey( registeredProcesses, leftProcess )
        disp( 'The left process is invalid' )
        return
    end
    
    if ~isKey( registeredProcesses, rightProcess )
        disp( 'The right process is invalid' )
        return
    end
    
    % Now we'll retrieve the domain of the processes (leftProcess and
    % rightProcess). These are already Matlab functions, so we can just
    % call them
%     foundAPassingCondition = false;
%     for processStructure = registeredProcesses( leftProcess )
%         processStructure = processStructure{1} % huh? why do I need to do this?
%         
%     end
    
end


function registerProcess( processDescription )
    % This function parses input for each PEPA component defined and adds
    % it to a process structure. It also runs sanity checks on the input.
    % Example: 'P(n) = (e, lambda).P(n+1) for n >= 0'
    
    matches = regexp( processDescription, '([A-Z])\((.+)\) = \((.+), (.+)\)\.([A-Z])\((.+)\)(?: for )?(.*)', 'tokens' );
    addToProcessStructure(matches{1})
    
    %TODO: Validate user input : 1.check transition is going from P->P!
end

function addToProcessStructure( processDefinition )
    % This function stores the processes based on their descriptions.
    % So 2 descriptions of a single Process P will be stored under the same 
    % value 'P'.
    % It also relables all action rates with 'infinity'. So a process with 
    % action rate 'infinity' and action label 'a' will be relabelled as 'x_a'.
    % This is for enabling all passive actions in a Process.
    
    global registeredProcesses
    global activeActionLabels
    global passiveActionLabels
    
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
    keyset = { 'transitionFromState', 'actionName', 'actionRate', 'transitionToState', 'domain' };
    valueset = { eval(processDefinition{2}), actionLabel, sym(actionRate), eval(processDefinition{6}), domain };
    
    processMap = containers.Map(keyset, valueset);
    appendToCellArrayWithinMap( registeredProcesses, processToRegister, processMap );    
end

function appendToCellArrayWithinMap(map, key, valueToAppend)
    % helper function in 'addToProcessStructure(..)'
    
    if ~isKey(map, key)
        map(key) = { valueToAppend };
    else
        % This use of temp is due a syntactical limitation in Matlab
        temp = map(key);
        temp{ end + 1 } = valueToAppend;
        map(key) = temp;
    end
end

function createRk()
    % this function creates the structure Rk used in the RCAT algorithm.
    % It has 3 fields :
    % 1. Definitions which stores the transition info (with action label
    % and rate) 2. Active labels which have all the active actions
    % 3. Passive labels which have all passive (and enabled) actions. If a
    % process has no passive actions then it will store an empty set. 
    
    global registeredProcesses
    global activeActionLabels
    global passiveActionLabels
    global r
    
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
        value = labelMap( key );
    end
end

function callable = convertToMatlabFunction( functionAsAString )
    % This function will take a string in terms of "n"
    % such as "n <= 0" and turn it into a callable function.
    
    % This is useful because you will want to, in the case of conditions
    % check if a particular value of n satisfies "n <= 0". While it's a
    % string, it's impossible for Matlab to use, so we convert it into a
    % function that Matlab can execute.
    
    callable = @(n) eval( functionAsAString );
end

function storeReversedRates()
    % This function stores reversed rates with the coop action labels as
    % key. Will be used in evaluating the passive action rates
    
    global coopLabels
    global reversedRates
    global r

    for action = coopLabels
        action = action{1};
        % r(k) can only have k = 1 or 2 
        for i = 1:2
            if ismember( action, r(i).activeLabels )
                [arrivalRate, serviceRate] = getAggregateArrivalAndServiceRates( r(i) );
                [fromState, toState, rate] = getStatesAndRateForAction( action, r(i) );
                iSSPD = sspdMM1( fromState, arrivalRate, serviceRate );
                jSSPD = sspdMM1( toState, arrivalRate, serviceRate );
                reversedRate = calculateReversedRate( rate, iSSPD, jSSPD );
                reversedRates( action ) = reversedRate;
            end
        end
    end   
end

function [ fromState, toState, rate ] = getStatesAndRateForAction( actionLabel, process )
    % This function returns the states an action transitions from and the
    % rate of the instance of action type a going out of that state. This
    % is used in calculating the reversed rate for specified action.
    % Assumption made here is that in one process there cannot be multiple
    % transitions for the same action.
    
    fromState = 0;
    toState = 0;
    rate = 0;
    for definition = process.definitions
        definition = definition{1};
        if isequal( actionLabel, definition( 'actionName' ) )
            fromState = definition( 'transitionFromState' );
            toState = definition( 'transitionToState' );
            rate = definition( 'actionRate' );
        end
    end  
end

function [ forwardSum, backwardSum ] = getAggregateArrivalAndServiceRates( process )
    % This function is used to calculate the total forward rate and total
    % backward rate of a process. This is used for calculating the sspd of
    % a process id MM1.
    % Input: Please supply a process, such as p(1) where p is the struct.
    
    forwardSum = 0;
    backwardSum = 0;
    
    for definition = process.definitions
        definition = definition{1};
        if isTransitioningForwards( definition )
            forwardSum = forwardSum + definition('actionRate');
        else
            backwardSum = backwardSum + definition('actionRate');
        end
    end
end

function isGoingForward = isTransitioningForwards( procesDefinition )
    % Figure out if it's going forwards to backwards
    % Both params must be symbolic equations.
    
    isGoingForward = eval( procesDefinition('transitionToState') - procesDefinition('transitionFromState') ) > 0;
end

function sspd = sspdMM1( state, arrivalRate, serviceRate )
    % This function calculates the sspd of an MM1 queue given an arrival
    % and service rate. Please note if the queue isnt MM1 then this sspd
    % does not apply for calculating reversed rates in rcat. Also the input
    % arguments to this function have to be symbolic variables.
    
    syms r x;
    
    rho = ( arrivalRate / serviceRate );
    formula = '(1 - r) * r^x';
    temp = subs( formula, x, state );
    sspd = subs( temp, r, rho );
end

function reversedRate = calculateReversedRate( forwardRate, iStateSSPD, jStateSSPD )
    % This function calculates the reversed rate based on the formula given
    % in the generic algorithm for rcat.

    formula = (forwardRate * iStateSSPD) / jStateSSPD;
    reversedRate = simplify(formula); 
end