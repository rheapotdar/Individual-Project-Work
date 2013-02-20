function validateInputIsNotEmpty( input, msgIndent, errorMsg )

    if isempty( input )
        throw( MException( msgIndent, errorMsg ) );
    end
end