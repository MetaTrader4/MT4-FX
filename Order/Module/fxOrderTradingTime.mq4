
/**
 * Calculate the order has being opened for how long.
 */
int fxOrderTradingTimeHours(int ticket)
{
    if (OrderSelect(ticket, SELECT_BY_TICKET) == false) return(-1);

    int hours = 0;
    
    
    return(hours);
}

int marketOffGap()
{
    
}