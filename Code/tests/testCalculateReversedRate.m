function testCalculateReversedRate

    syms lambda n mu1
    iSspd = (1 - (lambda/mu1)) * (lambda/mu1)^(n+1);
    jSspd = (1 - (lambda/mu1)) * (lambda/mu1)^n;
    rate = calculateReversedRate( mu1, iSspd, jSspd );
    
    assertTrue( isequal( rate, lambda ) );
end