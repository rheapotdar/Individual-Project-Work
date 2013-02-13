function appendToCellArrayWithinMap(map, key, valueToAppend)
% helper function in 'addToProcessStructure(..)'
    
    if ~isKey(map, key)
        map(key) = { valueToAppend };
    else
        % This use of temp is due a syntactical limitation in Matlab
        temp = map(key);
        temp{ end + 1 } = valueToAppend;
        map(key) = temp;
    end
end