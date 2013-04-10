

/**
 * Check if the orders in the order_jar all get closed.
 */
bool fxOrderJarClosed(int order_jar[])
{
    int i;
    int size = ArraySize(order_jar);
    bool ret = true;
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET))
        {
            if (OrderCloseTime() == 0)
            {
                ret = false;
            }
        }
    }
    
    return(ret);
}