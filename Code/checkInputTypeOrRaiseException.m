function checkInputTypeOrRaiseException( type, variable )
    if ~( isequal( class(variable), type) || isnumeric(variable) )
            exception = MException('RCATscript:InvalidScalarOrAlgebraticType', ...
            strcat('Input arguments are not numeric or ', type) ) ;
            throw( exception )
    end
end