
#define FXOF_TIME_CLOSE_LAST 1
#define FXOF_TIME_OPEN_FIRST 2
#define FXOF_TIME_OPEN_LAST 3

/**
 * Find the last order.
 */
int fxOrderFindTime(int order_jar[], int cond_time)
{
    int size = ArraySize(order_jar);
    if (size <= 0) return(-1);
    
    int ticket = -1;
    int i;
    datetime time_order = 0;
    if (cond_time == FXOF_TIME_OPEN_FIRST)
    {
        time_order = EMPTY_VALUE;
    }
    
    for (i = 0; i < size; i++)
    {
        if (!OrderSelect(order_jar[i], SELECT_BY_TICKET)) continue;
        switch (cond_time)
        {
            case FXOF_TIME_CLOSE_LAST:
                if (OrderCloseTime() > time_order)
                {
                    time_order = OrderCloseTime();
                    ticket = OrderTicket();
                }
                break;
            case FXOF_TIME_OPEN_FIRST:
                if (OrderOpenTime() < time_order)
                {
                    time_order = OrderOpenTime();
                    ticket = OrderTicket();
                }
                break;
            case FXOF_TIME_OPEN_LAST:
                if (OrderOpenTime() > time_order)
                {
                    time_order = OrderOpenTime();
                    ticket = OrderTicket();
                }
                break;
        }
    }
    
    return(ticket);
}