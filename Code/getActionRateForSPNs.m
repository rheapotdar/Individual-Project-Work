function actionRate = getActionRateForSPNs( actionLabel , bbStruct )
    matches = regexp( actionLabel, '\s*_\s*', 'split' );
    actionRate = 0;
    for i = 1:length( bbStruct )
        if strcmp(matches(1), 'i')
            if isKey( bbStruct(i).inputs, actionLabel )
                actionRate = bbStruct(i).inputs( actionLabel );
            end
        else 
            if isKey( bbStruct(i).outputs, actionLabel )
                actionRate = bbStruct(i).outputs( actionLabel );
            end
        end
    end
end