
extern bool Entry_TrendRestrict = true;                   // Long follows Short, Short follows Long.

/**
 * Entry Trend Restrict.
 */
bool entryTrendRestrict(int type)
{
    if (Entry_TrendRestrict) return(true);
    
    int ticket = fxOrderFindLast(Symbol(), FXOP_ALL, Magic);
    if (ticket < 0) return(true);
    
    bool ret = true;
    OrderSelect(ticket, SELECT_BY_TICKET);
    if (type == OrderType())
    {
        ret = false;
    }
    
    return(ret);
}