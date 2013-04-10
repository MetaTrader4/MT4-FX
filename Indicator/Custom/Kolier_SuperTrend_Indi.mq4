
// Kolier_SuperTrend_Indi
extern string    KSTI_AdvisorName = "Kolier_SuperTrend_Indi";
extern string KSTI_AdvisorVersion = "2.1.8";            // The version number of this script
extern string    KSTI_ProjectPage = "http://kolier.li/project/kolier-supertrend-indi";            // The project landing page
extern int       KSTI_BarsToCount = 0;    // Set to 0 to count all bars, if >0, set more to calculate more bars
extern int         KSTI_TrendMode = 0;    // 0=Show line same as SuperTrend.mq4, 1=New way to show trend line
extern bool        KSTI_EA_Export = true; // Export value for EA to trade.
// iATR
extern string KSTI_ATR_Indicator = "http://kolier.li/example/mt4-iatr-system-average-true-range";
extern int       KSTI_ATR_Period = 10;
extern double KSTI_ATR_Multiplier = 3.0;

// 0 = Main, 1 = Up, 2 = Down.
double ksti[3];



/**
 * Indicator: Value of Kolier_SuperTrend_Indi.
 */
double kstiValue(int mode, int index)
{
    ksti[mode] = iCustom(NULL, 0, KSTI_AdvisorName, KSTI_AdvisorName, KSTI_AdvisorVersion, KSTI_ProjectPage,
        KSTI_BarsToCount, KSTI_TrendMode, KSTI_EA_Export, KSTI_ATR_Indicator, KSTI_ATR_Period, KSTI_ATR_Multiplier, mode, index);
    
    return(ksti[mode]);
}


//----- Usage -----//
* Trend Identification
Up (Lime): kstiValue(0, 0) < Low[0]
Down (Red): kstiValue(0, 0) > High[0]

/**
 * Kolier_SuperTrend_Indi Entry Cond.
 */
bool entryCondST(int type)
{
    if (!Entry_SuperTrend) return(true);
    
    bool ret = false;
    if (type == OP_BUY && kstiValue(0, 0) < Low[0])
    {
        ret = true;
    }
    else if (type == OP_SELL && kstiValue(0, 0) > High[0])
    {
        ret = true;
    }
    
    return(ret);
}


* Trend Change (Color Change)




