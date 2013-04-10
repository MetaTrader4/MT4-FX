

int fxOrderJarCountType(int order_jar[], int type)
{
    int size = ArraySize(order_jar);
    if (size == 0) return(0);
    
    int i;
    int count = 0;
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET) == false) continue;
        switch (type)
        {
            case FXOP_BUY:
                if (OrderType() == OP_BUY || OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT)
                {
                    count++;
                }
                break;
            case FXOP_SELL:
                if (OrderType() == OP_SELL || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT)
                {
                    count++;
                }
                break;
        }
        if (OrderType() == type)
        {
            count++;
        }
    }
    
    return(count);
}