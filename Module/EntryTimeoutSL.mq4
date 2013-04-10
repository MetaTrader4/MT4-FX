
extern int     Entry_Timeout_SL = 0;                      // In candles. Stop trading after SL.

/**
 * Entry timeout after stoploss order.
 */
bool entryTimeoutSL()
{
    if (Entry_Timeout_SL <= 0) return(true);
    
    int ticket = fxOrderFindLastClosed(Symbol(), FXOP_ALL, Magic);
    if (ticket < 0) return(true);
    bool ret = true;
    OrderSelect(ticket, SELECT_BY_TICKET);
    if (StringFind(OrderComment(), "[sl]") != -1 && Time[0] - OrderCloseTime() < Entry_Timeout_SL * Period() * 60)
    {
        ret = false;
    }
    
    return(ret);
}