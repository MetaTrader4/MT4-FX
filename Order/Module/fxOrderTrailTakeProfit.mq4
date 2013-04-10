
// Order Operation - Trail TakeProfit
extern string    TrailTP = "--- Trail TakeProfit ---";
extern bool          TTP_On = false;                // Whether using TrailStop.
extern bool TTP_StealthMode = false;                // Whether using TrailStop in Stealth Mode.
extern int        TTP_Start = 20;                   // In Pips. Set to big negative value like -10 to immediately trigger. Any positive amount as profit achievement.
extern double      TTP_Away = 20;                   // In Pips. StopLoss away from the current price.
extern double      TTP_Move = 0;                    // In Pips. e.g. for set it as 5 pips, The new stoploss will be 5 pips away from the previous stoploss, default 0 advances every movement.


/**
 * Module: Trail TakeProfit.
 * 
 * Trail TakeProfit the order.
 */
void trailTP(int ticket)
{
    if (!TTP_On) return;
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) return;
    if (OrderType() > 1) return;
    
    string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int cmd = OrderType();
    double po, ptp, p_start, p_move, pc;
    po = OrderOpenPrice();
    ptp = TTP_Away;
    int ptp_mode = PRICE_PIPS;
    p_start = TTP_Start;
    p_move = marketPipsToPoints(sym, TTP_Move);
    int p_start_mode = PRICE_PIPS;
    fxOrderPriceStopLoss(sym, cmd, po, p_start, p_start_mode, true);
    if (TTP_StealthMode)
    {
        pc = stealthModeGet("TP", "TrailTP", ticket);
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
            if (TTP_StealthMode)
            {
                stealthModeSet("TP", "TrailTP", ticket, ptp);
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
            if (TTP_StealthMode)
            {
                stealthModeSet("TP", "TrailTP", ticket, ptp);
            }
            else
            {
                // @todo handle error. But ignore don't have known problem.
                OrderModify(OrderTicket(), po, OrderStopLoss(), ptp, OrderExpiration(), Orange);
            }
        }
    }
}