function validateProcessTransition( fromProcess, toProcess )
    if ~isequal( fromProcess, toProcess )
        throw( MException( 'RCATscript:ProcessTransitionSyntax', ...
            'Syntax error in pepa description. Please ensure all transitions are correct' ) );
    end
end