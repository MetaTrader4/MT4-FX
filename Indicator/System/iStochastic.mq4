
// iStochastic
extern string Stoch_Indicator = "--- iStochastic ---";
extern int            Stoch_K = 5;
extern int            Stoch_D = 3;
extern int      Stoch_Slowing = 3;
extern int       Stoch_Method = 0;                     // 0=sma, 1=ema, 2=smma, 3=lwma
extern int   Stoch_PriceField = 0;                     // 0 - Low/High or 1 - Close/Close


double stoch[2];

/**
 * iStochastic().
 */
double stochValue(int mode, int index)
{
    stoch[mode] = iStochastic(NULL, 0, Stoch_K, Stoch_D, Stoch_Slowing, Stoch_Method, Stoch_PriceField, mode, index);
    
    return(stoch[mode]);
}

bool stochCross(int type, int shift)
{
    bool ret = false;
    if (type == OP_BUY)
    {
        if (stochValue(0,shift+1) < stochValue(1,shift+1) && stochValue(0,shift) >= stochValue(1,shift))
        {
            ret = true;
        }
    }
    else if (type == OP_SELL)
    {
        if (stochValue(0,shift+1) > stochValue(1,shift+1) && stochValue(0,shift) <= stochValue(1,shift))
        {
            ret = true;
        }
    }
    
    return(ret);
}

// iStochastic
extern string Stoch_Indicator = "---- iStochastic ----";
extern int            Stoch_K = 5;
extern int            Stoch_D = 3;
extern int      Stoch_Slowing = 3;
extern int       Stoch_Method = 0;                       // 0=sma, 1=ema, 2=smma, 3=lwma
extern int   Stoch_PriceField = 0;                       // 0 - Low/High or 1 - Close/Close


extern int            Stoch_TF = PERIOD_M1;
extern double Stoch_Overbought = 80;
extern double   Stoch_Oversold = 20;


double stoch = iStochastic(NULL, 0, Stoch_K, Stoch_D, Stoch_Slowing, Stoch_Method, Stoch_PriceField, MODE_MAIN, 0);
double stoch_sig = iStochastic(NULL, 0, Stoch_K, Stoch_D, Stoch_Slowing, Stoch_Method, Stoch_PriceField, MODE_SIGNAL, 0);