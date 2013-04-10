

extern bool   TrendRestrict = true;                   // Buy follows sell, sell follows buy only.

/**
 * TrendRestrict feature.
 *
 * @todo Will have problem if the last order is pending order.
 */
bool trendRestrict(int type)
{
    if (!TrendRestrict) return(true);
    
    int ticket = fxOrderFindLast(Symbol(), FXOP_ALL, Magic);
    if (ticket < 0) return(true);
    
    OrderSelect(ticket, SELECT_BY_TICKET);
    bool ret = true;
    if (type == OP_BUY && OrderType() == OP_BUY)
    {
        ret = false;
    }
    else if (type == OP_SELL && OrderType() == OP_SELL)
    {
        ret = false;
    }
    
    return(ret);
}