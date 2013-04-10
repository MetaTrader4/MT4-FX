/*
dependencies[] = FX_MARKET_SYMBOL;
*/

/**
 * Price identifier. In system.
 */
//#define PRICE_OPEN 1
//#define PRICE_HIGH 2
//#define PRICE_LOW 3
//#define PRICE_CLOSE 0
//#define PRICE_MEDIAN 4
//#define PRICE_TYPICAL 5
//#define PRICE_WEIGHTED 6
//#define MODE_BID 9
//#define MODE_ASK 10

/**
 * Get market price.
 *
 * Return close price of the current by default.
 *
 * @param string sym(Optional) Chart symbol.
 * @param int tf(Optional) TimeFrame.
 * @param int type(Optional) Price type. PRICE_OPEN, PRICE_HIGH, PRICE_LOW, PRICE_CLOSE, PRICE_MEDIAN, PRICE_TYPICAL, PRICE_WEIGHTED, MODE_BID, MODE_ASK.
 * @param int index(Optional) Index of price series array.
 * @return double price The getting price.
 */
double marketPrice(string sym = "", int tf = 0, int type = PRICE_CLOSE, int shift = 0)
{
    sym = marketSymbol(sym);
    double price;
    switch (type)
    {
        case PRICE_OPEN:
            price = iOpen(sym, tf, shift);
            break;
        case PRICE_HIGH:
            price = iHigh(sym, tf, shift);
            break;
        case PRICE_LOW:
            price = iLow(sym, tf, shift);
            break;
        case PRICE_CLOSE:
            price = iClose(sym, tf, shift);
            break;
        case PRICE_MEDIAN:
            price = (iHigh(sym, tf, shift) + iLow(sym, tf, shift)) / 2;
            break;
        case PRICE_TYPICAL:
            price = (iHigh(sym, tf, shift) + iLow(sym, tf, shift) + iClose(sym, tf, shift)) / 3;
            break;
        case PRICE_WEIGHTED:
            price = (iHigh(sym, tf, shift) + iLow(sym, tf, shift) + iClose(sym, tf, shift) * 2) / 4;
            break;
        case MODE_ASK:
            price = MarketInfo(sym, MODE_ASK);
            break;
        case MODE_BID:
            price = MarketInfo(sym, MODE_BID);
            break;
    }
    
    return(price);
}