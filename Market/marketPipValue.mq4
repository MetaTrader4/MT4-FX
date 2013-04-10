/*
name = FX_Market_PipValue
dependencies[] = FX_Market_Symbol
dependencies[] = FX_Market_Pips
*/

/**
 * Get a PipValue.
 */
double marketPipValue(string sym, int pips = 1, double lots = 1)
{
    return(MarketInfo(sym, MODE_TICKVALUE) * marketPipsFactor(sym) * pips * lots);
}

