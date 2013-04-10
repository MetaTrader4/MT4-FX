
// See MH_EMAChannel_EA.

// Order Operation - Break Even
extern string    BreakEven = "--- Break Even ---";
extern bool          BE_On = false;                // Whether using BreakEven.
extern bool BE_StealthMode = false;                // Whether using BreakEven in Stealth Mode.
extern bool   BE_CloseHalf = false;                // Only close half of the order lots with BE, only work when BE_StealthMode is true, because if explictly set the StopLoss, will close the whole order.
extern double     BE_Start = 20;                   // In Pips. How much should the current price above/below the open price.
extern double       BE_Add = 0;                    // In Pips. Add a deviation to the Order Open Price, positive value for profit.


/**
 * Module: StealthMode.
 * 
 * Stealth close order.
 * string plugins[2] = {"BreakEven", "TrailStop"};
 */
void stealthMode(int ticket, string plugins[])
{
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) return;
    // Run General StealthMode, if turn on.
    if (SM_On) stealthModeGeneral(ticket);
    
    int plugins_size = ArraySize(plugins);
    
    string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int i;
    double tp, sl;
    double lots;
    for (i = 0; i < plugins_size; i++)
    {
        tp = stealthModeGet("TP", plugins[i], ticket);
        sl = stealthModeGet("SL", plugins[i], ticket);
        if (
            (
                tp > 0
                && ((OrderType() == OP_BUY && marketPrice(sym, 0, MODE_BID) >= tp)
                    || (OrderType() == OP_SELL && marketPrice(sym, 0, MODE_ASK) <= tp))
            )
            ||
            (
                sl > 0
                && ((OrderType() == OP_BUY && marketPrice(sym, 0, MODE_BID) <= sl)
                    || (OrderType() == OP_SELL && marketPrice(sym, 0, MODE_ASK) >= sl))
            )
        )
        {
            // BE_CloseHalf feature.
            // Ignore already haft closed orders.
            if (plugins[i] == "BreakEven" && BE_CloseHalf && StringFind(OrderComment(), "from #") == -1)
            {
                lots = OrderLots() / 2;
                lots = fxOrderLots(OrderSymbol(), lots);
            }
            if (fxOrderClose(ticket, lots))
            {
                stealthModeDel("TP", plugins[i], ticket);
                stealthModeDel("SL", plugins[i], ticket);
            }
        }
    }
}