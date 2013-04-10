/*
name = FX_Order_Open
dependencies[] = FX_Market_Symbol
dependencies[] = FX_Market_Price
dependencies[] = FX_Order_Price
*/

/**
 * A wrapper function for OrderSend().
 * 
 * @param int cmd(Optional) OrderSend command: OP_BUY, OP_SELL, OP_BUYLIMIT, OP_BUYSTOP, OP_SELLLIMIT, OP_SELLSTOP and extension.
 * @param double po(Optional) Order open price.
 * @param int po_mode(Optional) Detect what kind of po it is. PRICE_PRICE, PRICE_PIPS, PRICE_POINTS.
 * @param double lots(Optional) Order trading volume.
 * @param double ptp(Optional) Order TakeProfit.
 * @param int ptp_mode(Optional) Detect what kind of ptp it is. PRICE_PRICE, PRICE_PIPS, PRICE_POINTS.
 * @param double psl(Optional) Order StopLoss.
 * @param int psl_mode(Optional) Detect what kind of psl it is. PRICE_PRICE, PRICE_PIPS, PRICE_POINTS.
 * @param int slippage(Optional) Allow trading slippage.
 * @param string sym(Optional) Trading symbol, current chart by default.
 * @param int magic(Optional) MagicNumber identifier for the order.
 * @param string cmt(Optional) Comment attached to the order.
 * @param datetime expire(Optional) The expiration datetime for pending order to delete.
 * @param color col(Optional) On chart mark for this order.
 *
 * @return ticket Ticket number if successful, -1 if not fail.
 */
int fxOrderOpen(int cmd = FXOP_ALL, double lots = 0, double po = 0, int po_mode = PRICE_PRICE,
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE,
    int slippage = 3, string sym = "", int magic = 0, string cmt = "",
    datetime expire = 0, color col = CLR_NONE)
{
    // Prepare the symbol.
    sym = marketSymbol(sym, SYMBOL_ORDER);
    
    // If it isn't market order and without setting po, return -1 and log error.
    // @todo handle error.
    fxOrderPriceOpen(sym, cmd, po, po_mode);
    if (po <= 0)
    {
        return(-1);
    }
    
    // Hook: hook_pre_order_open().
    hook_order_pre_open(sym, cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, cmt, magic, expire, col);
    
    // Hook: hook_order_open().
    int ticket = hook_order_open(sym, cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, cmt, magic, expire, col);
    
    // Hook: hook_post_order_open().
    hook_order_post_open(ticket, sym, cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, cmt, magic, expire, col);
    
    return(ticket);
}

/**
 * Implements hook_order_pre_open().
 */
void hook_order_pre_open(string &sym, int &cmd, double &lots, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode, int &slippage,
    string &cmt, int &magic, datetime &expire, color &col)
{
    // If no cmd, give a random one. :D
    if (cmd == FXOP_ALL)
    {
        if (MathMod(MathRand(), 2) == 0)
        {
            cmd = OP_BUY;
        }
        else
        {
            cmd = OP_SELL;
        }
    }
    // If not set lots, help initiate it.
    if (lots <= 0)
    {
        lots = MarketInfo(sym, MODE_MINLOT);
    }
}

/**
 * Implements hook_order_open().
 */
int hook_order_open(string &sym, int &cmd, double &lots,
    double &po, int &po_mode, double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    int &slippage, string &cmt, int &magic, datetime &expire, color &col)
{
    // Prepare the TakeProfit price and StopLoss price.
    fxOrderPriceTakeProfit(sym, cmd, po, ptp, ptp_mode);
    fxOrderPriceStopLoss(sym, cmd, po, psl, psl_mode);

    int ticket;
    ticket = OrderSend(sym, cmd, lots, po, slippage, psl, ptp, cmt, magic, expire, col);
    
    return(ticket);
}

/**
 * Implements hook_order_post_open().
 */
void hook_order_post_open(int ticket, string sym, int cmd, double lots,
    double po, int po_mode, double ptp, int ptp_mode, double psl, int psl_mode,
    int slippage, string cmt, int magic, datetime expire, color col)
{
    // @todo error handle.
    if (ticket < 0)
    {
    
    }
}


// ---------- OrderSend Implementation ---------- //
/**
 * Order interface for OP_BUY.
 *
 * @see fxOrderOpen().
 */
int fxOrderBuy(double lots = 0, string sym = "", int magic = 0, string cmt = "",
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE, int slippage = 3, color col = Lime)
{
    return(fxOrderOpen(OP_BUY, lots, 0, PRICE_PRICE, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, 0, col));
}

/**
 * Order interface for OP_SELL.
 *
 * @see fxOrderOpen().
 */
int fxOrderSell(double lots = 0, string sym = "", int magic = 0, string cmt = "",
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE, int slippage = 3, color col = Red)
{
    return(fxOrderOpen(OP_SELL, lots, 0, PRICE_PRICE, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, 0, col));
}

/**
 * Order interface for OP_BUYLIMIT && OP_BUYSTOP.
 *
 * @see fxOrderOpen().
 */
int fxOrderPendBuy(double po, double lots = 0, string sym = "", int magic = 0, string cmt = "",
    double ptp = 0, double psl = 0, int price_mode = PRICE_PRICE, int slippage = 3, color col = Lime)
{
    int cmd;
    if (po > marketPrice(sym, Period()))
    {
        cmd = OP_BUYSTOP;
    }
    else if (po < marketPrice(sym, Period()))
    {
        cmd = OP_BUYLIMIT;
    }
    
    return(fxOrderOpen(cmd, po, lots, ptp, psl, price_mode, slippage, sym, magic, cmt, 0, col));
}

int fxOrderBuyLimit() {}

int fxOrderBuyStop() {}

/**
 * Order interface for OP_SELLLIMIT && OP_SELLSTOP.
 *
 * @see fxOrderOpen().
 */
int fxOrderPendSell(double po, double lots = 0, string sym = "", int magic = 0, string cmt = "",
    double ptp = 0, double psl = 0, int price_mode = PRICE_PRICE, int slippage = 3, color col = Red)
{
    int cmd;
    if (po > marketPrice(sym, Period()))
    {
        cmd = OP_SELLLIMIT;
    }
    else if (po < marketPrice(sym, Period()))
    {
        cmd = OP_SELLSTOP;
    }
    
    return(fxOrderOpen(cmd, po, lots, ptp, psl, price_mode, slippage, sym, magic, cmt, 0, col));
}

int fxOrderSellLimit() {}

int fxOrderSellStop() {}



