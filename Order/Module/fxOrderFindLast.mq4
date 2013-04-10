
/**
 * Find the last order.
 */
int fxOrderFindLast(string sym = "", int op_type = FXOP_ALL, int magic = 0, string cmt = "", string options = "")
{
    int ticket = -1;
    int i;
    datetime time_order = 0;
    
    for (i = 0; i < OrdersTotal(); i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
        if (
            (StringLen(sym) == 0 || OrderSymbol() == sym)
            && (op_type == FXOP_ALL || OrderType() == op_type)
            && (magic == 0 || OrderMagicNumber() == magic)
            && (StringLen(cmt) == 0 || OrderComment() == cmt || (StringFind(options, "Comment_Wildcard") != -1 && StringFind(OrderComment(), cmt) != -1))
            && time_order < OrderOpenTime()
        )
        {
            time_order = OrderOpenTime();
            ticket = OrderTicket();
        }
    }
    
    for (i = OrdersHistoryTotal() - 1; i >= 0; i--)
    {
        if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
        if (
            (StringLen(sym) == 0 || OrderSymbol() == sym)
            && (op_type == FXOP_ALL || OrderType() == op_type)
            && (magic == 0 || OrderMagicNumber() == magic)
            && (StringLen(cmt) == 0 || OrderComment() == cmt || OrderComment() == StringConcatenate(cmt, "[tp]") || OrderComment() == StringConcatenate(cmt, "[sl]") || (StringFind(options, "Comment_Wildcard") != -1 && StringFind(OrderComment(), cmt) != -1))
            && time_order < OrderOpenTime()
        )
        {
            time_order = OrderOpenTime();
            ticket = OrderTicket();
        }
    }
    
    return(ticket);
}