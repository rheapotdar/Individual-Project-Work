function testParseDomain()

    [a,b] = parseDomain('n>=0');
    assertTrue( isequal(a, 0));
    assertTrue( isequal(b, Inf));
    [a,b] = parseDomain('n>0');
    assertTrue( isequal(a, 1));
    assertTrue( isequal(b, Inf));
    [a,b] = parseDomain('n=0');
    assertTrue( isequal(a, 0));
    assertTrue( isequal(b, 0));
    [a,b] = parseDomain('n<=5');
    assertTrue( isequal(a, 0));
    assertTrue( isequal(b, 5));
    [a,b] = parseDomain('n<5');
    assertTrue( isequal(a, 0));
    assertTrue( isequal(b, 4));
end