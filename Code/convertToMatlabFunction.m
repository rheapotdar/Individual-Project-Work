function callable = convertToMatlabFunction( functionAsAString )
% This function will take a string in terms of "n" such as "n <= 0" and turn it into a callable function.
% This is useful because you will want to, in the case of conditions
% check if a particular value of n satisfies "n <= 0". While it's a
% string, it's impossible for Matlab to use, so we convert it into a
% function that Matlab can execute.
    
    callable = @(n) eval( functionAsAString );
end