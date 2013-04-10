
/**
 * Find the last closed order.
 */
int fxOrderFindLastClosed(string sym = "", int op_type = FXOP_ALL, int magic = 0, string cmt = "", datetime time_last = 0)
{
    int ticket = -1;
    int i;
    datetime time_order = 0;
    for (i = OrdersHistoryTotal() - 1; i >= 0; i--)
    {
        OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
        
        if (time_last > 0 && TimeCurrent() <= time_last) break;
        
        if (
            (StringLen(sym) == 0 || OrderSymbol() == sym)
            && (op_type == FXOP_ALL || OrderType() == op_type)
            && (magic == 0 || OrderMagicNumber() == magic)
            && (StringLen(cmt) == 0 || OrderComment() == cmt || OrderComment() == StringConcatenate(cmt, "[tp]") || OrderComment() == StringConcatenate(cmt, "[sl]"))
            && time_order < OrderCloseTime()
        )
        {
            time_order = OrderCloseTime();
            ticket = OrderTicket();
        }
    }

    return(ticket);
}


