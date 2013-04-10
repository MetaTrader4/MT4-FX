
/**
 * Format the lots to avoid error.
 *
 * @return lots Formatted lots value.
 */
double fxOrderLots(string sym, double lots)
{
    // Don't deal with 0.
    if (lots <= 0) return(lots);
    
    sym = marketSymbol(sym, SYMBOL_ORDER_MARKET);
    double lots_min = MarketInfo(Symbol(), MODE_MINLOT);
    double lots_max = MarketInfo(Symbol(), MODE_MAXLOT);
    int lots_precision = marketLotsPrecision(sym);
    lots = NormalizeDouble(lots, lots_precision);
    if (lots < lots_min)
    {
        lots = lots_min;
    }
    if (lots > lots_max)
    {
        lots = 0;
    }
    
    return(lots);
}