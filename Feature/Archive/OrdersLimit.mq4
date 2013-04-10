OrdersLimit
===========

extern int       OrdersLimit = 0;                      // Max opening orders, 0 = no limit.


/**
 * OrdersLimit.
 */
bool ordersLimit()
{
    if (OrdersLimit <= 0) return(true);
    
    bool ret = false;
    if (order_jar_ea_size < OrdersLimit)
    {
        ret = true;
    }

    return(ret);
}