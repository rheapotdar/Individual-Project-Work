function [passiveActionRates, passiveEqualRevStrings] = ...
    computeSolutionsOfPassiveActionRates( r, reversedRates )
% This function stores rates replacing type 'x_a' - step 3 of algorithm

    fprintf( 'Printing passive action rates computed using RCAT algorithm...\r\n' );
    for i = 1:length(r)
        if ~isempty( r(i).passiveLabels )
            for j  = 1:length(r(i).passiveLabels)
                label = r(i).passiveLabels{j}
                [ oldActionRate, newActionRate ] = setPassiveActionRate( ...
                    reversedRates, label, r(i).definitions );
                fprintf( 'Reversed rate for passive action %s: %s = %s\r\n',...
                    label, char(oldActionRate), char(newActionRate) );
                passiveActionRates{j} = oldActionRate;
                passiveEqualRevStrings{j} = strcat(char(oldActionRate), ' = ', char(newActionRate));
%                 fprintf( '%s = %s\r\n', char(oldActionRate), char(newActionRate));
            end
        end
    end
end