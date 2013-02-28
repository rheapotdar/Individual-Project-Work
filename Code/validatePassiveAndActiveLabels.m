function validatePassiveAndActiveLabels( r )
% This function validates that an action cannot be both passive and active
% in the same component. It also checks that each cooperating action a in L
% is passive in only one component in the cooperation.

    setOfLabels = {};
    for i = 1: length(r)
        if ~isempty(intersect(r(i).activeLabels, r(i).passiveLabels))
            throw( MException( 'RCATscript:ActionPassiveAndActive', ...
                'Action Label cannot be both passive and active.' ) );
        end
        if ~isempty(intersect(setOfLabels, r(i).passiveLabels))
            throw( MException( 'RCATscript:ActionPassiveMultipleComponents', ...
                    'Each cooperating action a in L is passive in only one component in the cooperation' ) );
        end
        setOfLabels = [setOfLabels, r(i).passiveLabels];
    end    
end