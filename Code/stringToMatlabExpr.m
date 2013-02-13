function symExpr = stringToMatlabExpr( string )
% This function parses a string, finds variables in the string, makes
% them symbolic and then returns the evaluated string as a symbolic var
    matches = regexp( string, '([a-z]+[a-z0-9_]+)', 'tokens' );
    for i = 1:length( matches )
        match = matches{i}{1};
        syms( match );
    end
    symExpr = eval( string );
end