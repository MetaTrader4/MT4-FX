
MODE_MAIN = 0
MODE_UPPER = 1
MODE_LOWER = 2

// iBands
extern string    BB_iBands = "--- iBands ---";
extern int       BB_Period = 14;
extern int    BB_Deviation = 2;
extern int        BB_Shift = 0;
extern int        BB_Price = 0;                // 0=close, 1=open, 2=high, 3=low, 4=median, 5=typical, 6=weighted


double bb[3];


/**
 * iBands().
 */
double bbValue(int mode, int index)
{
    bb[mode] = iBands(Symbol(), 0, BB_Period, BB_Deviation, BB_Shift, BB_Price, mode, index);
    
    return(bb[mode]);
}