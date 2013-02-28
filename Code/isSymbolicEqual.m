function ret = isSymbolicEqual( s1, s2 )
    ret = ( simplify( s1 - s2 ) == 0 );
end