function sspd = sspdMM1( state, arrivalRate, serviceRate )
% This function calculates the sspd of an MM1 queue given an arrival
% and service rate. Please note if the queue isnt MM1 then this sspd
% does not apply for calculating reversed rates in rcat. Also the input
% arguments to this function have to be symbolic variables.
    
    syms r x;
    
    rho = ( arrivalRate / serviceRate );
    formula = '(1 - r) * r^x';
    temp = subs( formula, x, state );
    sspd = subs( temp, r, rho );
end