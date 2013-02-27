function [domainMin, domainMax] = parseDomain( domain )
% This function takes a string of the type
% '<variable><(in)equality><number>' and parses it to return a tuple
% (domainMin, domainMax) which returns the maximum and minimum number the
% transition takes.

     matches = regexp( domain, 'n\s*(.*?)\s*(\d+)', 'tokens' );
     a = matches{1,:};
     operator = a{1,1};
     switch operator
         case '>='
             domainMin = str2double( a{1,2} );
             domainMax = Inf;
         case '>'
             domainMin = str2double( a{1,2} ) + 1;
             domainMax = Inf;
         case '='
             domainMin = str2double( a{1,2} );
             domainMax = str2double( a{1,2} );
         case '<='
             domainMin = 0;
             domainMax = str2double( a{1,2} );
         case '<'
             domainMin = 0;
             domainMax = str2double( a{1,2} ) - 1;
     end
     
end