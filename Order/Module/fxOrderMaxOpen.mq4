
extern int      Order_MaxOpen = 0;                         // Max opening orders allowd, 0 = No limit.


/**
 * Module: Order_MaxOpen.
 *
 * Max opening orders allowd.
 */
bool fxOrderMaxOpen(int &order_jar[], int max = 0)
{
    if (max == 0) return(true);
    
    bool ret = false;
    int size = ArraySize(order_jar);
    if (size < max)
    {
        ret = true;
    }
    
    return(ret);
}