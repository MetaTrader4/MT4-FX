
/**
 * Get the lots precision.
 */
int marketLotsPrecision(string sym)
{
    double lots_step = MarketInfo(sym, MODE_LOTSTEP);
    int lots_precision = 0;
    
    if (lots_step == 0.1)
    {
        lots_precision = 1;
    }
    if (lots_step == 0.01)
    {
        lots_precision = 2;
    }
    
    return(lots_precision);
}