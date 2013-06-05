function revRate = getReversedRateForBB( bbStruct, actionLabel )
% The reversed rate of transition Ty' is lambday,
% i.e.the rate of the corresponding input transition.
    matches = regexp( actionLabel, '\s*_\s*', 'split' );
    assert( strcmp( matches(1), 'o' ) ) %i.e we are finding rev rate of Ty'
    
    inputActionLabel = strcat( 'i', '_', matches{2} );
    revRate = getActionRateForSPNs( inputActionLabel , bbStruct );
end