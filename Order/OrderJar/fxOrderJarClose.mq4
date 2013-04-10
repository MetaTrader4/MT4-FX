
/**
 * Close specific orders in the order_jar.
 *
 * @return count How many orders will get closed.
 */
int fxOrderJarClose(int &order_jar[], string signal = "")
{
    int size = ArraySize(order_jar);
    if (size == 0) return(0);
    
    int i;
    int count = 0;
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET) == false) continue;
        if (StringFind(OrderComment(), signal) != -1)
        {
            arrayPushInt(order_queue_exit, order_jar[i]);
            count++;
        }
    }
    
    return(count);
}