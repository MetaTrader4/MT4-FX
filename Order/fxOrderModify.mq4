/*
name = FX_ORDER_MODIFY
dependencies[] = FX_MARKET_SYMBOL
dependencies[] = FX_ORDER_PRICE
*/

// OrderModify(int ticket, double price, double stoploss, double takeprofit, datetime expiration, color Color = CLR_NONE);

/**
 * Function wrapper for OrderModify().
 */
bool fxOrderModify(int ticket, double po = -1, int po_mode = PRICE_PRICE,
    double ptp = -1, int ptp_mode = PRICE_PRICE, double psl = -1, int psl_mode = PRICE_PRICE, 
    datetime expiration = -1, color col = CLR_NONE)
{
    // Hook: hook_order_pre_modify().
    hook_order_pre_modify(ticket, po, po_mode, ptp, ptp_mode, psl, psl_mode, expiration, col);
    
    if (OrderSelect(ticket, SELECT_BY_TICKET))
    {
        string sym_m = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
        int cmd = OrderType();
        if (po == -1)
        {
            po = OrderOpenPrice();
        }
        else
        {
            fxOrderPriceOpen(sym_m, cmd, po, po_mode);
        }
        if (ptp == -1)
        {
            ptp = OrderTakeProfit();
        }
        else
        {
            fxOrderPriceTakeProfit(sym_m, cmd, po, ptp, ptp_mode);
        }
        if (psl == -1)
        {
            psl = OrderStopLoss();
        }
        else
        {
            fxOrderPriceStopLoss(sym_m, cmd, po, psl, psl_mode);
        }
        if (expiration == -1)
        {
            expiration = OrderExpiration();
        }        
        
        // Hook: hook_order_modify().
        bool result = hook_order_modify(ticket, po, po_mode, ptp, ptp_mode, psl, psl_mode, expiration, col);
    }
    else
    {
        // @todo Handle error.
        return(false);
    }
    
    // Hook: hook_order_post_modify().
    hook_order_post_modify(result, ticket, po, po_mode, ptp, ptp_mode, psl, psl_mode, expiration, col);
    
    return(result);
}

/**
 * Implements hook_order_pre_modify().
 */
void hook_order_pre_modify(int &ticket, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    datetime &expiration, color &col)
{
    
}

/**
 * Implements hook_order_modify().
 */
bool hook_order_modify(int &ticket, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    datetime &expiration, color &col)
{
    if (
        (po != OrderOpenPrice() && OrderType() > 1)
        || ptp != OrderTakeProfit()
        || psl != OrderStopLoss()
        || (expiration != OrderExpiration() && OrderType() > 1)
    )
    {
        return(OrderModify(ticket, po, psl, ptp, expiration, col));
    }
    
    return(false);
}

/**
 * Implements hook_order_post_modify().
 */
void hook_order_post_modify(bool result, int &ticket, double &po, int &po_mode, 
    double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    datetime &expiration, color &col)
{
    // @todo error handle.
}


