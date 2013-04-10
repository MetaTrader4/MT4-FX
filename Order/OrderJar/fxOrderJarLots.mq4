
/**
 * Calculate the lots amount from the order_jar.
 */
double fxOrderJarLots(int order_jar[])
{
    double lots = 0;
    for (int i = 0; i < ArraySize(order_jar); i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET) == false) continue;
        
        lots += OrderLots();
    }
    
    return(lots);
}