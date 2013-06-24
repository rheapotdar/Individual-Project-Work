function checkBBconditions( bbStruct )
% If the number of Places and transitions are equal then the BB consitions
% are unconditionally satisfied. Else the rho's for all BBs need to be
% found and then the rho equations need to be satisfied with the calculated
% passive rates.

    for i = 1:length( bbStruct )
        assert( length(bbStruct(i).outputs) == length(bbStruct(i).inputs) )
        if ~( length(bbStruct(i).places) >= length(bbStruct(i).inputs) )
            fprintf( 'Product form is subject to following conditions being fulfilled for BB %d :\r\n', i );
            furtherConditionCheck( bbStruct(i) )
        end
    end



end

function furtherConditionCheck( bb )
% Prints bb conditions as bb does not unconditionally have a product form
    i_keys = bb.inputs.keys;
    o_keys = bb.outputs.keys;
    for i = 1:length( bb.inputs )
        matches = regexp( i_keys{i}, 'i_t(.+)', 'tokens' );
        matches = matches{1};
        str = matches{1};
        rho = strcat( 'rho' , str );
        inputs = bb.inputs;
        outputs = bb.outputs;
        arrivalRate = inputs(i_keys{i});
        serviceRate = outputs(o_keys{i});
        fprintf('%s = %s / %s\n', rho, char(arrivalRate), char(serviceRate) );        
        
        if length( str ) == 2 && length( bb.inputs ) >= 3
            r1 = strcat( 'rho' , str(1) );
            r2 = strcat( 'rho' , str(2) );
            fprintf('%s = %s * %s\n', rho, r1, r2 );
        end
    end
end
