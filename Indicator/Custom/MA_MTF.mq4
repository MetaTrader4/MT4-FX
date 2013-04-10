

// Information
extern string MAMTF_Information = "--- Information ---";
extern string     MAMTF_Advisor = "MA_MTF";              // For Logging.
extern string     MAMTF_Version = "1.0";                 // The version number of this script.
// Settings
extern int  MAMTF_BarsToCount = 0;                     // How many bars on chart to calculate, 0 = All.
extern int          MAMTF_MTF = 0;                     // 0 = Current TF, 1 = M1, 5 = M5, 15 = M15, 60 = H1, 240 = H4, 1440 = D1, 10080 = W1, 43200 = MN1.
extern bool MAMTF_MTF_BackFix = true;                  // If backfix the outdated value from MTF.
// iMA
extern string MAMTF_MA_iMA = "--- iMA ---";
extern int MAMTF_MA_Period = 14;            // MA Period.
extern int  MAMTF_MA_Shift = 0;             // MA Shift.
extern int MAMTF_MA_Method = 0;             // 0=sma, 1=ema, 2=smma, 3=lwma.
extern int  MAMTF_MA_Price = 0;             // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.


double ma_mtf;


/**
 * Get the MA_MTF value.
 */
double maMTFValue(int index)
{
    ma_mtf = iCustom(NULL, 0, MAMTF_Advisor, MAMTF_Information, MAMTF_Advisor, MAMTF_Version,
        MAMTF_BarsToCount, MAMTF_MTF, MAMTF_MTF_BackFix,
        MAMTF_MA_iMA, MAMTF_MA_Period, MAMTF_MA_Shift, MAMTF_MA_Method, MAMTF_MA_Price, 0, index);
    
    return(ma_mtf);
}