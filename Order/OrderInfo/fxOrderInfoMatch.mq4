
/**
 * Check match of the order_info element.
 */
bool fxOrderInfoMatch(string order_info[,16], int index, int mode, string match, string options = "")
{
    // Exceed the range.
    int size = ArrayRange(order_info, 0);
    if (index >= size) return(false);
    // -1 means loop all the array to match any.
    if (index == -1)
    {
        int i;
        for (i = 0; i < size; i++)
        {
            if (fxOrderInfoMatch(order_info, i, mode, match, options))
            {
                return(true);
            }
        }
        
        return(false);
    }
    // Normal check.
    bool ret = false;
    if (StringFind(options, "Wildcard") != -1)
    {
        if (StringFind(order_info[index,mode], match) != -1)
        {
            ret = true;
        }
    }
    else
    {
        if (order_info[index,mode] == match)
        {
            ret = true;
        }
    }
    
    return(ret);
}