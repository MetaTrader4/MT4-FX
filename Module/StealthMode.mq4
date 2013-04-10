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
            if (fxOrderClose(ticket))
            {
                stealthModeDel("TP", plugins[i], ticket);
                stealthModeDel("SL", plugins[i], ticket);
            }
        }
    }
}

/**
 * Module: StealthMode.
 * 
 * General stealth close.
 */
void stealthModeGeneral(int ticket)
{
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) return;
    if (OrderType() > 1) return;
    
    string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int cmd = OrderType();
    double po, ptp, psl;
    po = OrderOpenPrice();
    ptp = SM_TakeProfit;
    psl = SM_StopLoss;
    int ptp_mode = PRICE_PIPS;
    int psl_mode = PRICE_PIPS;
    fxOrderPriceTakeProfit(sym, cmd, po, ptp, ptp_mode, false);
    fxOrderPriceStopLoss(sym, cmd, po, psl, psl_mode, false);
    if (cmd == OP_BUY)
    {
        double bid = marketPrice(sym, 0, MODE_BID);
        if ((bid >= ptp && ptp > 0) || bid <= psl)
        {
            fxOrderClose(ticket);
        }        
    }
    else if (cmd == OP_SELL)
    {
        double ask = marketPrice(sym, 0, MODE_ASK);
        if (ask <= ptp || (ask >= psl && psl > 0))
        {
            fxOrderClose(ticket);
        }
    }
}

/**
 * Module: StealthMode.
 * 
 * Helper function for getting close price.
 */
double stealthModeGet(string type, string plugin, int ticket)
{
    string name = ticket + "_" + type + "_" + plugin;
    if (IsTesting()) name = StringConcatenate("Test_", name);
    double value = -1;
    if (GlobalVariableCheck(name))
    {
        value = GlobalVariableGet(name);
    }
    
    return(value);
}

/**
 * Module: StealthMode.
 * 
 * Helper function for setting close price.
 */
void stealthModeSet(string type, string plugin, int ticket, double value)
{
    string name = ticket + "_" + type + "_" + plugin;
    if (IsTesting()) name = StringConcatenate("Test_", name);
    GlobalVariableSet(name, value);
}

/**
 * Module: StealthMode.
 * 
 * Helper function for deleting the close price setting.
 */
void stealthModeDel(string type, string plugin, int ticket)
{
    string name = ticket + "_" + type + "_" + plugin;
    if (IsTesting()) name = StringConcatenate("Test_", name);
    GlobalVariableDel(name);
}

/**
 * Module: StealthMode.
 * 
 * Clear the junk parameters.
 * string plugins[2] = {"BreakEven", "TrailStop"};
 */
void stealthModeClear(string plugins[])
{
    string name = "";
    int plugins_size = ArraySize(plugins);
    int i, j;
    for (i = 0; i < plugins_size; i++)
    {
        for (j = 0; j < OrdersHistoryTotal(); j++)
        {
            if (OrderSelect(j, SELECT_BY_POS, MODE_HISTORY) == false) continue;
            stealthModeDel("TP", plugins[i], OrderTicket());
            stealthModeDel("SL", plugins[i], OrderTicket());
        }
    }
}