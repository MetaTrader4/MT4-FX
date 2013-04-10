
/**
 * Calculate total OrderProfit() of the order_jar.
 */
int fxOrderJarProfit(int order_jar[])
{
    int size = ArraySize(order_jar);
    if (size == 0) return(0);
    
    int i;
    double profit = 0;
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET) == false) continue;
        profit += OrderProfit();
    }
    
    return(profit);
}