/*
name = FX_ORDER_CLOSE
dependencies[] = FX_MARKET_SYMBOL
dependencies[] = FX_MARKET_PRICE
*/


//---------- fxOrderClose ----------//

// OrderClose(int ticket, double lots, double price, int slippage, color Color = CLR_NONE);
// OrderDelete(int ticket);

/**
 * Wrapper function for OrderClose() and OrderDelete().
 *
 * Make an order easier.
 *
 * @param int ticket
 * @param double lots(Optional)
 * @param double pc(Optional)
 * @param int slippage(Optional)
 * @param color col(Optional)
 */
bool fxOrderClose(int ticket, double lots = 0, double pc = 0, int slippage = 3, color col = White)
{
    // Hook: hook_order_pre_close().
    hook_order_pre_close(ticket, lots, pc, slippage, col);
    
    bool result = false;
    
    // Only deal if order exit and opening.
    if (OrderSelect(ticket, SELECT_BY_TICKET) && OrderCloseTime() == 0)
    {
        string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER);
        int cmd = OrderType();
        
        // Hook: hook_order_close().
        result = hook_order_close(ticket, sym, cmd, lots, pc, slippage, col);
        
    }
    
    // Hook: hook_order_post_close().
    hook_order_post_close(result, ticket, sym, cmd, lots, pc, slippage, col);
    
    return(result);
}

/**
 * Implements hook_order_pre_close().
 */
void hook_order_pre_close(int &ticket, double &lots, double &pc, int &slippage, color &col)
{

}

/**
 * Implements hook_order_close().
 */
bool hook_order_close(int &ticket, string &sym, int &cmd, double &lots, double &pc, int &slippage, color &col)
{
    bool result = false;
    
    // Pending orders.
    if (OrderType() > 1)
    {
        result = OrderDelete(ticket);
    }
    else
    {
        if (lots <= 0)
        {
            lots = OrderLots();
        }
        if (pc <= 0)
        {
            switch (cmd)
            {
                case OP_BUY:
                    pc = marketPrice(marketSymbol(sym, SYMBOL_ORDER_MARKET), 0, MODE_BID);
                    break;
                case OP_SELL:
                    pc = marketPrice(marketSymbol(sym, SYMBOL_ORDER_MARKET), 0, MODE_ASK);
                    break;
            }
        }
    
        result = OrderClose(ticket, lots, pc, slippage, col);
    }
    
    return(result);
}

/**
 * Implements hook_order_post_close().
 */
void hook_order_post_close(bool result, int ticket, string sym, int cmd, double lots, double pc, int slippage, color col)
{

}