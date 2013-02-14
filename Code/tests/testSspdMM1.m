function testSspdMM1()
    syms lambda1 mu1 state1;
    
    assertTrue( sspdMM1( state1, lambda1, mu1 ) == ...
        (1 - (lambda1/mu1)) * (lambda1/mu1)^state1 );
    assertExceptionThrown( @() sspdMM1( state1, lambda1, 'something' ), ...
        'RCATscript:InvalidScalarOrAlgebraticType' );
end