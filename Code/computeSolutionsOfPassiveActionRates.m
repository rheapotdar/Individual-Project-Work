function computeSolutionsOfPassiveActionRates( r, reversedRates )
% This function stores rates replacing type 'x_a' - step 3 of algorithm

    fprintf( 'Printing passive action rates computed using RCAT algorithm...\r\n' );
    for i = 1:length(r)
        if ~isempty( r(i).passiveLabels )
            for label = r(i).passiveLabels
                label = label{1};
                [ oldActionRate, newActionRate ] = setPassiveActionRate( ...
                    reversedRates, label, r(i).definitions );
                fprintf( '%s = %s\r\n', char(oldActionRate), char(newActionRate));
            end
        end
    end
end