

// Order Operation - Break Even TakeProfit
extern string    BreakEvenTP = "--- Break Even TakeProfit ---";
extern bool          BETP_On = false;                // Whether using BreakEven TakeProfit.
extern bool BETP_StealthMode = false;                // Whether using BreakEven TakeProfit in Stealth Mode.
extern double     BETP_Start = -20;                  // In Pips. How much should the current price above/below the open price.
extern double       BETP_Add = 0;                    // In Pips. Add a deviation to the Order Open Price, positive value for profit.


/**
 * Module: BreakEven.
 * 
 * BreakEven the order.
 */
void breakEvenTP(int ticket)
{
    if (!BETP_On) return;
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) return;
    if (OrderType() > 1) return;
    // Alread set.
    if (BETP_StealthMode && stealthModeGet("TP", "BreakEvenTP", ticket) > 0) return;
    
    string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int cmd = OrderType();
    double po, ptp, p_start, pc;
    // @todo Seems not needed.
    if (BETP_StealthMode)
    {
        pc = stealthModeGet("TP", "BreakEvenTP", ticket);
    }
    else
    {
        pc = OrderTakeProfit();
    }
    po = OrderOpenPrice();
    ptp = BETP_Add;
    p_start = BETP_Start;
    int ptp_mode = PRICE_PIPS;
    int p_start_mode = PRICE_PIPS;
    fxOrderPriceTakeProfit(sym, cmd, po, ptp, ptp_mode, true);
    fxOrderPriceTakeProfit(sym, cmd, po, p_start, p_start_mode, true);
    if (cmd == OP_BUY)
    {
        if (marketPrice(sym, 0, MODE_BID) <= p_start && (pc > ptp || pc == 0 || pc == -1))
        {
            if (BETP_StealthMode)
            {
                stealthModeSet("TP", "BreakEvenTP", ticket, ptp);
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
        if (marketPrice(sym, 0, MODE_ASK) >= p_start && pc < ptp )
        {
            if (BETP_StealthMode)
            {
                stealthModeSet("TP", "BreakEvenTP", ticket, ptp);
            }
            else
            {
                // @todo handle error. But ignore don't have known problem.
                OrderModify(OrderTicket(), po, OrderStopLoss(), ptp, OrderExpiration(), Orange);
            }
        }
    }
}