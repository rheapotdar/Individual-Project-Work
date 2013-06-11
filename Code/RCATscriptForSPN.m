function bbStruct = RCATscriptForSPN( listOfBBs, connectionString )

    bbStruct = createBbStruct( listOfBBs );
    connections = parseConnections( connectionString );
    calculatePassiveRatesForBBs( connections, bbStruct );
    
end