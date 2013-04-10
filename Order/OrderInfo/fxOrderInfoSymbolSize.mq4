

/**
 * Calculate how many symbols in the order_info[,16] and the symbols list.
 */
int fxOrderInfoSymbolSize(string order_info[,16], string &symbol[])
{
    int size = 0;
    ArrayResize(symbol, 0);
    int size_order_info = ArrayRange(order_info, 0);
    for (int i = 0; i < size_order_info; i++)
    {
        if (inArray(order_info[i][1], symbol) < 0)
        {
            size = arrayPushString(symbol, order_info[i][1]);
        }
    }

    return(size);
}