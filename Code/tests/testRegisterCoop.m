function testRegisterCoop


    coopLabels = registerCoop( 'P(0) with Q(0) over {a}');
    assertTrue( coopLabels{1} == 'a' );
    
    coopLabels = registerCoop( 'P(0) with Q(0) over {a, b, c}');
    assertEqual( length( coopLabels ), 3 );
    assertTrue( coopLabels{2} == 'b' );
    
    assertExceptionThrown( @() registerCoop( 'P(0) with Q(0) over {}'), ...
        'RCATscript:InvalidInputCoopLabels' );
    assertExceptionThrown( @() registerCoop( ''), 'RCATscript:InvalidInputRegisterCoop' );
end