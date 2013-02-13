function coopLabels = registerCoop( coopDescription )
% This function parses input for cooperation (synchronisation) between two
% processes. It stores the action labels the processes are cooperating on.
% It also runs sanity checks on the inupt. Example coop: "P(0) with Q(0) over {a}"
    
      
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