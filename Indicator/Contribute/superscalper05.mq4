// superscalper05
extern string SS_Indicator = "superscalper05";
extern int SS_SignalPeriod = 28;
extern int SS_NR_SLIPE = 3;
extern double SS_FilterNumber = 3.0;
extern int SS_lineWidth = 3;
extern int SS_barsToDrawLine = 10000;
extern bool SS_skipSingleBarSignal = FALSE;
extern int SS_aTake_Profit = 150;
extern int SS_aStop_Loss = 150;
extern bool SS_aAlerts = false;
extern bool SS_EmailOn = false;


double ss[3];


/**
 * Indicator: superscalper05.
 */
double ssValue(int mode, int index)
{
    ss[mode] = iCustom(NULL, 0, SS_Indicator, SS_SignalPeriod, SS_NR_SLIPE, SS_FilterNumber, SS_lineWidth, SS_barsToDrawLine,
        SS_skipSingleBarSignal, SS_aTake_Profit, SS_aStop_Loss, SS_aAlerts, SS_EmailOn, mode, index);

    return(ss[mode]);
}

/**
 * Calculate the condition of superscalper05.
 */
bool ssCond(int type)
{
    bool ret = false;
    
    if (type == OP_SELL)
    {
        if (
            (SS_skipSingleBarSignal == FALSE && ssValue(2,1) != EMPTY_VALUE && ssValue(2,2) == EMPTY_VALUE)
            || (SS_skipSingleBarSignal == TRUE && ssValue(2,1) != EMPTY_VALUE && ssValue(2,2) != EMPTY_VALUE && ssValue(2,3) == EMPTY_VALUE)
        )
        {
            ret = true;
        }
    }
    else if (type == OP_BUY)
    {
        if (
            (SS_skipSingleBarSignal == FALSE && ssValue(0,1) != EMPTY_VALUE && ssValue(0,2) == EMPTY_VALUE)
            || (SS_skipSingleBarSignal == TRUE && ssValue(0,1) != EMPTY_VALUE && ssValue(0,2) != EMPTY_VALUE && ssValue(0,3) == EMPTY_VALUE)
        )
        {
            ret = true;
        }
    }

    return(ret);
}