function coopLabels = registerCoop( coopDescription )
% This function parses input for cooperation (synchronisation) between two
% processes. It stores the action labels the processes are cooperating on.
% It also runs sanity checks on the inupt. Example coop: "P(0) with Q(0) over {a}"
    
      
    %TODO: check if coop is empty. If yes then throw error!
    matches = regexp( coopDescription, ...
        '([A-Z][0-9]*)\(([^\)]+)\) (with .+\s*)+ over \{(.*)\}', 'tokens' );
    
    validateInputIsNotEmpty( matches, 'RCATscript:InvalidInputRegisterCoop', ...
            'The input coopString is empty. Please enter a valid string.' );
        
    matches = matches{1};
%     leftProcess = matches{1};
%     leftStartState = matches{2};
%     rightProcess = matches{3};
%     rightStartState = matches{4};
    
    withMatches = regexp( matches{3}, '([A-Z][0-9]*)\(([^\)]+)\)', 'tokens' );
    
    if isequal( matches{4}, '' )
        throw( MException( 'RCATscript:InvalidInputCoopLabels', ...
            'No actions given which the agents synchronise on. Check input' ) );
    end
    coopLabels = regexp( matches{4}, '\s*,\s*', 'split' );
    coopLabels = unique(coopLabels);
    
%     validateCoop( leftProcess, leftStartState, rightProcess, rightStartState, coopLabels )
end