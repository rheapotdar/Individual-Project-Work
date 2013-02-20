function validateActionLabelSyntax( actionLabel )
    A = isletter( actionLabel );
    if ~A(1)
        throw( MException( 'RCATscript:NumericActionLabel', ...
            'Action Label cannot begin with a number or be only numeric.' ) );
    end
    
end