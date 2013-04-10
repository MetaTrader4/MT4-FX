/*
name = FX_Order_price
dependencies[] = FX_Market_Price
*/

//---------- fxOrderPrice ----------//

/**
 * @file
 * Contains the price preparation for order operation.
 */

/**
 * Used by fxOrderPricePrepare() to identify the input variable mode of the price, usually ptp and psl.
 */
#define PRICE_PRICE 0
#define PRICE_PIPS 5
#define PRICE_POINTS 10
#define PRICE_PERCENT 20

/**
 * Prepare the price for opening order.
 *
 * Usually for market order without setting it.
 * @see fxOrderOpen().
 * @see fxOrderBuy().
 * @see fxOrderSell().
 */
void fxOrderPriceOpen(string sym, int &cmd, double &po, int &po_mode)
{
    switch (po_mode)
    {
        case PRICE_PRICE:
            if (po > 0)
            {
                return;
            }
            // Only allow market order to set 0.
            else if (po <= 0)
            {
                switch (cmd)
                {
                    case OP_BUY:
                        po = marketPrice(sym, 0, MODE_ASK);
                        break;
                    case OP_SELL:
                        po = marketPrice(sym, 0, MODE_BID);
                        break;
                }
                
            }
            break;
        case PRICE_PIPS:
        case PRICE_POINTS:
            fxOrderPricePrepare(sym, po, po_mode);
            double price;
            if (cmd == FXOP_PEND_BUY)
            {
                price = marketPrice(sym, 0, MODE_ASK);
                po += price;
                if (po > price)
                {
                    cmd = OP_BUYSTOP;
                }
                else if (po < price)
                {
                    cmd = OP_BUYLIMIT;
                }
            }
            else if (cmd == FXOP_PEND_SELL)
            {
                price = marketPrice(sym, 0, MODE_BID);
                po += price;
                if (po > price)
                {
                    cmd = OP_SELLLIMIT;
                }
                else if (po < price)
                {
                    cmd = OP_SELLSTOP;
                }
            }
            break;
    }
}

/**
 * Helper function to prepare a price by pips_mode.
 */
void fxOrderPricePrepare(string sym, double &price, int &price_mode)
{
    if (price_mode == PRICE_PIPS)
    {
        price = marketPipsToPoints(sym, price);
        price_mode = PRICE_POINTS;
    }
}

/**
 * Helper function to get the order takeprofit price for order operation.
 *
 * @see fxOrderOpen().
 */
void fxOrderPriceTakeProfit(string sym, int cmd, double po, double &ptp, int &ptp_mode, bool real = false)
{
    // Don't need to set if it really not set.
    if (ptp_mode == PRICE_PRICE)
    {
        return(ptp);
    }
    fxOrderPricePrepare(sym, ptp, ptp_mode);
    
    if (real || ptp != 0)
    {
        switch (cmd)
        {
            case OP_BUY:
            case OP_BUYLIMIT:
            case OP_BUYSTOP:
                if (ptp_mode == PRICE_PERCENT)
                {
                    ptp = po * (1 + ptp / 100);
                }
                else
                {
                    ptp = po + ptp;
                }
                break;
            case OP_SELL:
            case OP_SELLLIMIT:
            case OP_SELLSTOP:
                if (ptp_mode == PRICE_PERCENT)
                {
                    ptp = po * (1 - ptp / 100);
                }
                else
                {
                    ptp = po - ptp;
                }
                break;
        }
    }
    
    ptp_mode = PRICE_PRICE;
}

/**
 * Helper function to get the order stoploss price for order operation.
 *
 * @see fxOrderOpen().
 */
void fxOrderPriceStopLoss(string sym, int cmd, double po, double &psl, int &psl_mode, bool real = false)
{
    // Don't need to set if it really not set.
    if (psl_mode == PRICE_PRICE)
    {
        return(psl);
    }
    fxOrderPricePrepare(sym, psl, psl_mode);
    
    if (real || psl != 0)
    {
        switch (cmd)
        {
            case OP_BUY:
            case OP_BUYLIMIT:
            case OP_BUYSTOP:
                if (psl_mode == PRICE_PERCENT)
                {
                    psl = po * (1 - psl / 100);
                }
                else
                {
                    psl = po - psl;
                }
                break;
            case OP_SELL:
            case OP_SELLLIMIT:
            case OP_SELLSTOP:
                if (psl_mode == PRICE_PERCENT)
                {
                    psl = po * (1 + psl / 100);
                }
                else
                {
                    psl = po + psl;
                }
                break;
        }
    }
    
    psl_mode = PRICE_PRICE;
}