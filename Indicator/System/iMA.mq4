System Moving Average - iMA()
=============================


Simple
------

// iMA
extern string MA_iMA = "--- iMA ---";
extern int MA_Period = 14;            // MA Period.
extern int  MA_Shift = 0;             // MA Shift.
extern int MA_Method = 0;             // 0=sma, 1=ema, 2=smma, 3=lwma.
extern int  MA_Price = 0;             // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.


double ma;

   
/**
 * Indicaor: iMA().
 */
double maValue(int index)
{
    ma = iMA(NULL, 0, MA_Period, MA_Shift, MA_Method, MA_Price, index);
    
    return(ma);
}


Multi-Timeframe
---------------

// iMA
extern string MA_iMA = "--- iMA ---";
extern int     MA_TF = 0;             // TimeFrame, 0 = Current TF, 1 = M1, 5 = M5, 15 = M15, 60 = H1, 240 = H4, 1440 = D1, 10080 = W1, 43200 = MN1.
extern int MA_Period = 14;            // MA Period.
extern int  MA_Shift = 0;             // MA Shift.
extern int MA_Method = 0;             // 0=sma, 1=ema, 2=smma, 3=lwma.
extern int  MA_Price = 0;             // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.


double ma;


/**
 * Indicaor: iMA().
 */
double maValue(int index, bool mtf = true)
{
    int shift = index;
    if (mtf)
    {
        shift = iBarShift(NULL, MA_TF, Time[index]);
    }
    ma = iMA(NULL, MA_TF, MA_Period, MA_Shift, MA_Method, MA_Price, shift);
    
    return(ma);
}


Simple Compact
--------------

// iMA
extern string         MA_iMA = "MA(Period, Shift, Method, Price)";
extern string MA_Paramerters = "14,0,0,0";                         // Method: 0=sma, 1=ema, 2=smma, 3=lwma. Price: 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.

double ma, ma_param[4];


