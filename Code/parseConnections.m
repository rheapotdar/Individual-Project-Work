function connections = parseConnections( connectionString )
    connections = containers.Map();
    match = regexp( connectionString, '\s*;\s*', 'split' );
    for i = 1:length( match )
        connectionString = match{i};
        matches = regexp( connectionString, '{(.+) to (.+)}', 'tokens' );
        matches = matches{1};
        output = matches{2};
        assert( length({output}) == 1 );
        splits = regexp( matches{1}, '\s*,\s*', 'split' );
        inputs = parseInputs( splits );
        connections( output ) = inputs;
    end
    
end

function inputs = parseInputs( splits )
    for i = 1:length( splits )
       matches = regexp( splits{i}, '(.+) = (.+)', 'tokens' );
       matches = matches{1};
       probability = stringToMatlabExpr( matches{2} );
       map = containers.Map( {matches{1}}, { probability } );
       inputs{ i } = map;
    end
end