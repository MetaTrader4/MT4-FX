
// iRSI
extern string RSI_iRSI = "--- iRSI ---";
extern int  RSI_Period = 14;             // Period setting.
extern int   RSI_Price = 0;              // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.


double rsi;


/**
 * iRSI().
 */
double rsiValue(int index)
{
    rsi = iRSI(NULL, 0, RSI_Period, RSI_Price, index);
}


extern double RSI_Overbought = 85;
extern double   RSI_Oversold = 15;


double rsi = iRSI(NULL, 0, RSI_Period, RSI_Price, 0);