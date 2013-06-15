function bbStruct = RCATscriptForSPN( listOfBBs, connectionString )

    bbStruct = createBbStruct( listOfBBs );
    connections = parseConnections( connectionString );
    checkBBconditions( bbStruct );
    calculatePassiveRatesForBBs( connections, bbStruct );
    
end