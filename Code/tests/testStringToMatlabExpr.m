function testStringToMatlabExpr()
    syms lambda1 mu1 lambda_1 mu_1;
    
    assertTrue( isequal( mu_1, stringToMatlabExpr('mu_1') ) )
    assertTrue( isequal(( 1 - lambda1 ) * mu1, stringToMatlabExpr('(1-lambda1)*mu1') ) )
    assertTrue( isequal( ( 1 - lambda1 ) * mu1, stringToMatlabExpr('( 1 - lambda1 ) * mu1') ) )
    assertTrue( isequal( ( 1 - lambda_1 ) * mu_1, stringToMatlabExpr('(1-lambda_1)*mu_1') ) )
    assertTrue( isequal(7404, stringToMatlabExpr('(1234)* 6') ) )

    assertExceptionThrown( @() stringToMatlabExpr('(1-)*mu1'), 'RCATscript:InvalidStringToMatlabExpr' )
end