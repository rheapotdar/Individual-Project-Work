function computeSolutionsOfPassiveActionRates( r, reversedRates )
% This function stores rates replacing type 'x_a' - step 3 of algorithm

    disp( 'Printing passive action rates computed using RCAT algorithm...' );
    for i = 1:2
        if ~isempty( r(i).passiveLabels )
            for label = r(i).passiveLabels
                label = label{1};
                [ oldActionRate, newActionRate ] = setPassiveActionRate( reversedRates, label, r(i).definitions );
                disp( strcat( char(oldActionRate) , ' = ', char(newActionRate) ) );
            end
        end
    end
end