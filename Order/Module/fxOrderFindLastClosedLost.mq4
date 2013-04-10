

/**
 * Find the last lost closed order.
 */
int fxOrderFindlastClosedLost(int ph, string cmt)
{
    int ticket = -1;
    int i;
    string sym = marketSymbol("", SYMBOL_MARKET_ORDER);
    for (i = OrdersHistoryTotal() - 1; i >= 0; i--)
    {
        OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
        // Only find very recently closed.
        if (TimeCurrent() - OrderCloseTime() > 60) break;

        if (OrderProfit() > 0) continue;
        if (
            OrderSymbol() == sym
            && OrderMagicNumber() == Magic
            // it may contain [tp]/[sl]
            && StringFind(OrderComment(), cmt) != -1
            && OrderType() == ord[ph]
            && OrderProfit() < 0
        )
        {
            ticket = OrderTicket();
        }
    }
    
    return(ticket);
}

