

// iEnvelopes
extern string ENV_iEnvelopes = "--- iEnvelopes ---";
extern int     ENV_MA_Period = 14;                   // MA Period.
extern int     ENV_MA_Method = 0;                    // 0=sma, 1=ema, 2=smma, 3=lwma.
extern int      ENV_MA_Shift = 0;                    // MA Shift.
extern int      ENV_MA_Price = 0;                    // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.
extern double  ENV_Deviation = 0.10;                 // Percent deviation from the main MA line in setting.


double env_ma = iMA(NULL, 0, Env_MA_Period, ENV_MA_Shift, ENV_MA_Method, ENV_MA_Price, i);

double env_upper = iEnvelopes(NULL, 0, Env_MA_Period, ENV_MA_Method, ENV_MA_Shift, ENV_MA_Price, ENV_Deviation, MODE_UPPER, i);
double env_lower = iEnvelopes(NULL, 0, Env_MA_Period, ENV_MA_Method, ENV_MA_Shift, ENV_MA_Price, ENV_Deviation, MODE_LOWER, i);



