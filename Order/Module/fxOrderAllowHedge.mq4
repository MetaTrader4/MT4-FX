

extern bool  Order_AllowHedge = true;                      // If allow hedge order to be opened.

/**
 * Module: Order_AllowHedge.
 */
bool fxOrderAllowHedge(int type)
{
    if (Order_AllowHedge) return(true);

    bool ret = false;
    if (type == OP_BUY)
    {
        if (order_jar_ea_short_size == 0)
        {
            ret = true;
        }
    }
    else if (type == OP_SELL)
    {
        if (order_jar_ea_long_size == 0)
        {
            ret = true;
        }
    }

    return(ret);
}