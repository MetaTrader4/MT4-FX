

// Money Management
extern string MoneyManagement = "--- Money Management ---";
extern bool             MM_On = false;                      // Whether using Simple Money Management for trading lots. Need to explicit set the StopLoss value bigger than 0.
extern int            MM_Mode = 0;                          // 0 = Equity; 1 = Balance.
extern double         MM_Risk = 5;                          // In Percentage. Risk as equity (for MM_RiskPips), in percent of total account equity.
extern double     MM_RiskPips = 100;                        // Use this pips value as object for calculating the MM_Risk. 100 pips stoploss = 5% equity of your account.


/**
 * Open lots base on the percent of equity and MM_RiskPips.
 */
double mmLots(string sym)
{
    sym = marketSymbol(sym);
    double lots_equity;
    if (MM_Mode == 0)
    {
        lots_equity = AccountEquity() * MM_Risk / 100;
    }
    else if (MM_Mode == 1)
    {
        lots_equity = AccountBalance() * MM_Risk / 100;
    }
    double lots_min = MarketInfo(Symbol(), MODE_MINLOT);
    double lots_max = MarketInfo(Symbol(), MODE_MAXLOT);
    int lots_precision = marketLotsPrecision(sym);
    double lots = NormalizeDouble(lots_equity / marketPipValue(sym, MM_RiskPips), lots_precision);
    if (lots < lots_min)
    {
        lots = lots_min;
    }
    if (lots > lots_max)
    {
        lots = lots_max;
    }

    return(lots);
}