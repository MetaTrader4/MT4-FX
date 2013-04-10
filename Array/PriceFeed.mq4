
/**
 * Prepare a price array within a specific period.
 * Price type. PRICE_OPEN, PRICE_HIGH, PRICE_LOW, PRICE_CLOSE, PRICE_MEDIAN, PRICE_TYPICAL, PRICE_WEIGHTED, MODE_BID, MODE_ASK.
 */
int fxPriceFeed(double &vals[], string sym, int tf, int type, datetime start, datetime end)
{
    ArrayResize(vals, 0);
    int bar_start = iBarShift(sym, tf, start);
    int bar_end = iBarShift(sym, tf, end);
    int bar_count = bar_start - bar_end + 1;
    ArrayResize(vals, bar_count);
    for (int i = 0; i < bar_count; i++)
    {
        vals[i] = marketPrice(sym, tf, type, bar_start - i);
    }
}

/**
 * Prepare a price array within a specific period.
 * Price type. PRICE_OPEN, PRICE_HIGH, PRICE_LOW, PRICE_CLOSE, PRICE_MEDIAN, PRICE_TYPICAL, PRICE_WEIGHTED, MODE_BID, MODE_ASK.
 */
int fxPriceFeedA(double &vals[], string sym, int tf, int type, int bar_start, int bar_end)
{
    ArrayResize(vals, 0);
    int bar_count = bar_start - bar_end + 1;
    ArrayResize(vals, bar_count);
    for (int i = 0; i < bar_count; i++)
    {
        vals[i] = marketPrice(sym, tf, type, bar_start - i);
    }
}

/**
 * Prepare a price array within a specific period.
 * Price type. PRICE_OPEN, PRICE_HIGH, PRICE_LOW, PRICE_CLOSE, PRICE_MEDIAN, PRICE_TYPICAL, PRICE_WEIGHTED, MODE_BID, MODE_ASK.
 */
int fxPriceFeedB(double &vals[], string sym, int tf, int type, int bar_start, int bar_count)
{
    ArrayResize(vals, bar_count);
    for (int i = 0; i < bar_count; i++)
    {
        vals[i] = marketPrice(sym, tf, type, bar_start - i);
    }
}