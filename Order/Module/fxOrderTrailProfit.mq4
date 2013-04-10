
// Order Operation - Trailing Stop
extern string   TrailProfit = "--- Trailing Stop ---";
extern bool          TRP_On = false;                   // Whether using TrailProfit.
extern bool TRP_StealthMode = false;                   // Whether using TrailProfit in Stealth Mode.
extern int        TRP_Start = 20;                      // In Pips. Set to big negative value like -10 to immediately trigger. Any positive amount as loss achievement.
extern double      TRP_Away = 20;                      // In Pips. TakeProfit away from the current price.
extern double      TRP_Move = 0;                       // In Pips. e.g. for set it as 5 pips, The new TakeProfit will be 5 pips away from the previous TakeProfit, default 0 decend every movement.


/**
 * Module: TrailProfit.
 * 
 * TrailProfit the order.
 */
void trailProfit(int ticket)
{
    if (!TRP_On) return;
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) return;
    if (OrderType() > 1) return;
    
    string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int cmd = OrderType();
    double po, ptp, p_start, p_move, pc;
    po = OrderOpenPrice();
    ptp = TRP_Away;
    int ptp_mode = PRICE_PIPS;
    p_start = TRP_Start;
    p_move = marketPipsToPoints(sym, TRP_Move);
    int p_start_mode = PRICE_PIPS;
    fxOrderPriceStopLoss(sym, cmd, po, p_start, p_start_mode, true);
    if (TRP_StealthMode)
    {
        pc = stealthModeGetClose("TrailProfit", ticket);
    }
    else
    {
        pc = OrderTakeProfit();
    }
    if (cmd == OP_BUY)
    {
        double bid = marketPrice(sym, 0, MODE_BID);
        fxOrderPriceTakeProfit(sym, cmd, bid, ptp, ptp_mode, true);
        if (bid <= p_start && (ptp < pc - p_move || pc == 0 || pc == -1))
        {
            if (TS_StealthMode)
            {
                stealthModeSetClose("TrailProfit", ticket, ptp);
            }
            else
            {
                // @todo handle error. But ignore don't have known problem.
                OrderModify(OrderTicket(), po, OrderStopLoss(), ptp, OrderExpiration(), Blue);
            }
        }
    }
    else if (cmd == OP_SELL)
    {
        double ask = marketPrice(sym, 0, MODE_ASK);
        fxOrderPriceTakeProfit(sym, cmd, ask, ptp, ptp_mode, true);
        if (ask >= p_start && ptp > pc + p_move)
        {
            if (TS_StealthMode)
            {
                stealthModeSetClose("TrailProfit", ticket, ptp);
            }
            else
            {
                // @todo handle error. But ignore don't have known problem.
                OrderModify(OrderTicket(), po, OrderStopLoss(), ptp, OrderExpiration(), Orange);
            }
        }
    }
}