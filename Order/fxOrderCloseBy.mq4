
// @todo Temporary solution.

/**
 * Close orders by condition. Return affected orders number.
 */
int fxOrderCloseBy(string sym, int cmd, int magic, string cmt, bool retry = false)
{
    if (retry) RefreshRates();
    
    sym = marketSymbol(sym, SYMBOL_ORDER);

    int number = 0;
    int fail = 0;
    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false)
        {
            fail++;
            continue;
        }

        if (
            OrderSymbol() == sym
            && OrderType() == cmd
            && OrderMagicNumber() == magic
            && StringFind(OrderComment(), cmt) != -1
        )
        {
            if (fxOrderClose(OrderTicket()) == false)
            {
                fail++;
            }
            else
            {
                number++;
            }
        }
    }
    
    if (fail > 0)
    {
        number += fxOrderCloseBy(sym, cmd, magic, cmt, true);
    }

    return(number);
}