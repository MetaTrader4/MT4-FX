
// NonLagZigZag_v2
extern string ZZ_Indicator = "NonLagZigZag_v2"; // Indicator file name.
extern int        ZZ_Price = 0;                 // Apply to Price(0-Close;1-Open;2-High;3-Low;4-Median price;5-Typical price;6-Weighted Close) 
extern int       ZZ_Length = 100;               // Period of NonLagMA
extern double ZZ_PctFilter = 2;                 // Dynamic filter in decimals


double zz;


/**
 * Get ZZ value.
 */
double zzValue(int index)
{
    zz = iCustom(NULL, 0, ZZ_Indicator, ZZ_Price, ZZ_Length, ZZ_PctFilter, 0, index);

    return(zz);
}

// NonLagZigZag_v2
#define ZZ_PEAK 1
#define ZZ_TROUGH -1

/**
 * Get the previous pivot point by the setting bar.
 *
 * Return the type of pivot point.
 */
int zzValuePrevious(int bar_check, int &bar, double &value)
{
    int type;
    for (int i = bar_check + 1; i < Bars; i++)
    {
        value = zzValue(i);
        if (value > 0)
        {
            bar = i;
            if (value == High[i])
            {
                type = ZZ_PEAK;
            }
            else if (value == Low[i])
            {
                type = ZZ_TROUGH;
            }
            return(type);
        }
    }
}