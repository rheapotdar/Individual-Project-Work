function bbStruct = createBbStruct( listOfBBs )
    bbStruct = struct( 'places', {}, 'inputs', {}, 'outputs', {} );
    dim = size( listOfBBs );
    for i = 1:length( listOfBBs )
        bb = listOfBBs( i );
        [places, inputs, outputs] = parseBB( bb{1} );
        bbStruct( i ).places = places;
        bbStruct( i ).inputs = inputs;
        bbStruct( i ).outputs = outputs;
    end
end

function [places, inputs, outputs] = parseBB( bbString )

    match = regexp( bbString, '{(.+)}, {(.+)}, {(.+)}, {(.+)}, {(.+)}', 'tokens' );
    matches = match{1};
    places = regexp( matches{1}, '\s*,\s*', 'split' );
    
    inputKeyset = regexp( matches{2}, '\s*,\s*', 'split' );
    i_rates = relabelPassiveRates( inputKeyset, ...
        regexp( matches{3}, '\s*,\s*', 'split' ) );
    inputValues = convertToSymbolicRates( i_rates );
    inputs = containers.Map( inputKeyset, inputValues );
    
    outputKeyset = regexp( matches{4}, '\s*,\s*', 'split' );
    o_rates = relabelPassiveRates( outputKeyset, ...
        regexp( matches{5}, '\s*,\s*', 'split' ) );
    outputValues = convertToSymbolicRates( o_rates );
    
    outputs = containers.Map( outputKeyset, outputValues );
end

function symRates = convertToSymbolicRates( rates )
    for i = 1:length( rates )
        symRates{ i } = stringToMatlabExpr( rates{ i } );
    end
end

function rates = relabelPassiveRates( actionLabels, rates)
    for i = 1:length( rates )
        if strcmp( rates{ i }, 'infinity' )
           rates{ i } = strcat( 'x', '_', actionLabels{ i } );
        end
    end
end