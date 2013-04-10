MA_Angle.mq4
============

// Information
extern string MAA_Information = "--- Information ---";
extern string     MAA_Advisor = "MA_Angle";            // Reference to the MA_Angle.mq4 file name.
extern string     MAA_Version = "1.2";                 // The version number of this script.
// Setting
extern int         MAA_BarsToCount = 0;                     // How many bars on chart to calculate, 0 = All.
extern int                 MAA_MTF = 0;                     // 0 = Current TF, 1 = M1, 5 = M5, 15 = M15, 60 = H1, 240 = H4, 1440 = D1, 10080 = W1, 43200 = MN1.
extern bool        MAA_MTF_BackFix = true;                  // If backfix the outdated value from MTF.
extern int         MAA_Angle_Point = 5;                     // Use which bar before as angle point.
extern double MAA_Value_Multiplier = 100000000;             // Multiplier to the counting value.
// iMA
extern string MAA_MA_iMA = "--- iMA ---";
extern int MAA_MA_Period = 14;            // MA Period.
extern int  MAA_MA_Shift = 0;             // MA Shift.
extern int MAA_MA_Method = 0;             // 0=sma, 1=ema, 2=smma, 3=lwma.
extern int  MAA_MA_Price = 0;             // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted.


double maa;


/**
 * Indicator: MA_Angle.
 */
double maaValue(int index)
{
    maa = iCustom(NULL, 0, MAA_Advisor, MAA_Information, MAA_Advisor, MAA_Version, MAA_BarsToCount,
        MAA_MTF, MAA_MTF_BackFix, MAA_Angle_Point, MAA_Value_Multiplier,
        MAA_MA_iMA, MAA_MA_Period, MAA_MA_Shift, MAA_MA_Method, MAA_MA_Price, 0, index);
    
    return(maa);
}


Entry Condition by Continuously Trendy
--------------------------------------

/**
 * MA_Angle.
 */
bool entryCondMAA(int type)
{
    bool ret = false;
    if (type == OP_BUY)
    {
        if (
            maaTrendy(OP_BUY, 0, MAA_Fa_Bars)
            && maaTrendy(OP_BUY, 1, MAA_Sl_Bars)
            && (!MAFi_On || (MAFi_On && maaTrendy(OP_BUY, 2, MAA_Fi_Bars)))
        )
        {
            ret = true;
        }
    }
    else if (type == OP_SELL)
    {
        if (
            maaTrendy(OP_SELL, 0, MAA_Fa_Bars)
            && maaTrendy(OP_SELL, 1, MAA_Sl_Bars)
            && (!MAFi_On || (MAFi_On && maaTrendy(OP_SELL, 2, MAA_Fi_Bars)))
        )
        {
            ret = true;
        }
    }
    
    return(ret);
}

/**
 * Calculate the MA_Angle trendy status.
 */
bool maaTrendy(int type, int mode, int count)
{
    if (count == 0) return(true);
    
    bool ret = true;
    int i;
    if (type == OP_BUY)
    {
        for (i = 0; i < count; i++)
        {
            if (maaValue(mode, i) < maaValue(mode, i + 1))
            {
                ret = false;
                break;
            }
        }
    }
    else if (type == OP_SELL)
    {
        for (i = 0; i < count; i++)
        {
            if (maaValue(mode, i) > maaValue(mode, i + 1))
            {
                ret = false;
                break;
            }
        }
    }
    
    return(ret);
}


Value Wrapper
-------------

/**
 * Indicator: MA_Angle.
 */
double maafaValue(int index)
{
    maa[0] = iCustom(NULL, 0, MAAFa_Advisor, MAAFa_Information, MAAFa_Advisor, MAAFa_Version, MAAFa_BarsToCount,
        MAAFa_MTF, MAAFa_MTF_BackFix, MAAFa_Angle_Point, MAAFa_Value_Multiplier,
        MAFa_iMA, MAFa_Period, MAFa_Shift, MAFa_Method, MAFa_Price, 0, index);
    
    return(maa[0]);
}

/**
 * Indicator: MA_Angle.
 */
double maaslValue(int index)
{
    maa[1] = iCustom(NULL, 0, MAASl_Advisor, MAASl_Information, MAASl_Advisor, MAASl_Version, MAASl_BarsToCount,
        MAASl_MTF, MAASl_MTF_BackFix, MAASl_Angle_Point, MAASl_Value_Multiplier,
        MASl_iMA, MASl_Period, MASl_Shift, MASl_Method, MASl_Price, 0, index);
    
    return(maa[1]);
}

/**
 * Indicator: MA_Angle.
 */
double maafiValue(int index)
{
    maa[2] = iCustom(NULL, 0, MAAFi_Advisor, MAAFi_Information, MAAFi_Advisor, MAAFi_Version, MAAFi_BarsToCount,
        MAAFi_MTF, MAAFi_MTF_BackFix, MAAFi_Angle_Point, MAAFi_Value_Multiplier,
        MAFi_iMA, MAFi_Period, MAFi_Shift, MAFi_Method, MAFi_Price, 0, index);
    
    return(maa[2]);
}

/**
 * MAA wrapper.
 */
double maaValue(int mode, int index)
{
    double value;
    
    switch (mode)
    {
        case 0:
            value = maafaValue(index);
            break;
        case 1:
            value = maaslValue(index);
            break;
        case 2:
            value = maafiValue(index);
            break;
    }
    
    return(value);
}