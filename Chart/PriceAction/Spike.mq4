
// Spike_Plan
extern string        Spike_Plan = "---- Spike ----";
extern bool            Spike_On = true;              // If trade spike logic.
extern double        Spike_Pips = 10;                // >= 10 pips.
extern int           Spike_Time = 60;                // <= 60 seconds.


double spike_price[0];
int spike_time[0];

/**
 * Log the spike information.
 */
void spikeLog()
{
    // Log spike_price and spike_time every tick.
    int size = arrayPushDouble(spike_price, Close[0]);
    arrayPushInt(spike_time, TimeCurrent());
    
    // @debug
    /*
    Print(size);
    if (size > 10)
    {
        Print(size + ": " + (spike_time[size - 1] - spike_time[0]));
        Print(TimeToStr(spike_time[size - 1], TIME_SECONDS) + " " + TimeToStr(spike_time[0], TIME_SECONDS));
        int i_h = ArrayMaximum(spike_price);
        int i_l = ArrayMinimum(spike_price);
        Print("H(" + i_h + ")" + DoubleToStr(spike_price[i_h], Digits));
        Print("L(" + i_l + ")" + DoubleToStr(spike_price[i_l], Digits));
    }
    */
    
    if (size > 2 * Spike_Time && spike_time[size - 1] - spike_time[0] > Spike_Time)
    {
        int i = 0;
        int junk[0];
        while (spike_time[size - 1] - spike_time[i] > Spike_Time)
        {
            arrayPushInt(junk, i);
            i++;
        }
        arrayRemoveAndSortMultiDouble(spike_price, junk);
        arrayRemoveAndSortMultiInt(spike_time, junk);
    }
}

/**
 * Reset the spike log.
 */
void spikeReset()
{
    ArrayResize(spike_price, 0);
    ArrayResize(spike_time, 0);
}

/**
 * Check the spike status.
 */
bool spikeCheck(int op_type)
{
    if (ArraySize(spike_price) < 2) return(false);
    bool result = false;
    double spike_points = marketPipsToPoints(Symbol(), Spike_Pips);
    int i_h = ArrayMaximum(spike_price);
    int i_l = ArrayMinimum(spike_price);
    
    if (
        op_type == OP_BUY
        && i_h > i_l && spike_price[i_h] - spike_price[i_l] >= spike_points
        && spike_time[i_h] - spike_time[i_l] <= Spike_Time
    )
    {
        result = true;
    }
    else if (
        op_type == OP_SELL
        && i_l > i_h && spike_price[i_h] - spike_price[i_l] >= spike_points
        && spike_time[i_l] - spike_time[i_h] <= Spike_Time
    )
    {
        result = true;
    }
    
    // reset.
    if (result) spikeReset();
    
    return(result);
}