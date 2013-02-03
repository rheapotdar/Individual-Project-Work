% (1) Setup a nice strut to store the informatoin
% (2) Make this structure usable. I.e., can you *check* constraints like
%     n >= 0, or can you have a way of distinguishing the lambda in one
%     registerProcess call from the lambda in another? Or do you want the
%     user to supply lambda1 and lambda2? You can just call sym() using
%     the[
%     name that the user has given you, and then you will have yourself a
%     symbolic variable of that name.
    


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
    global r
    r = struct( 'definitions', {}, 'activeLabels', {}, 'passiveLabels', {} );
    
    registerProcess( 'P(n) = (e, lambda).P(n+1) for n >= 0' );
    registerProcess( 'P(n) = (a, mu1).P(n-1) for n > 0' );
    registerProcess( 'Q(n) = (a, infinity).Q(n+1) for n >= 0' );
    registerProcess( 'Q(n) = (d, mu2).Q(n+1) for n > 0' );
    registerCoop( 'P(0) with Q(0) over {a,b,c}' );
    
    createRk();
        
    output = r;
    
%     condition = 'n <= 0';
%     conditionAsAFunction = convertToMatlabFunction( condition );
%     conditionAsAFunction( 5 )
%     conditionAsAFunction( -1 ) 
%     conditionAsAFunction( 0 )
end

function registerCoop( coopDescription )
    % This function parses input for cooperation (synchronisation) between 
    % two processes. It stores the action labels the processes are
    % cooperating on. It also runs sanity checks on the inupt.
    % Example coop: "P(0) with Q(0) over {a}"
    
    global coopLabels
    
    matches = regexp( coopDescription, '([A-Z])\((.+)\) with ([A-Z])\((.+)\) over \{(.+)\}', 'tokens' );
    matches = matches{1};
    
    leftProcess = matches{1};
    leftStartState = matches{2};
    rightProcess = matches{3};
    rightStartState = matches{4};
    coopLabels = regexp( matches{5}, ',', 'split' );
    
    validateCoop( leftProcess, leftStartState, rightProcess, rightStartState, coopLabels )
end

function validateCoop( leftProcess, leftStartState, rightProcess, rightStartState, coopLabels )
    %FIXME: to be completed
    
    global registeredProcesses
    
    % TODO: what happes if the user calls validateCoop before
    % registerProcess?
    % TODO: check if the actions are actually in the processes registered.
    
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
    
    keyset = { 'transitionFromState', 'actionName', 'actionRate', 'transitionToState', 'domain' };
    valueset = { processDefinition{2}, actionLabel, actionRate, processDefinition{6}, domain };
    
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
       len = size(r(i).definitions, 1);
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