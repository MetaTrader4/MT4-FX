ZigZag

1. Period
2. Deviation
    A. Deviation Type
    B. Deviation Value
3. BackStep



// From AB-3_Level_ZZ_Semafor_TRO_MODIFIED_VERSION.mq4
int CountZZ( double& ExtMapBuffer[], double& ExtMapBuffer2[], int ExtDepth, int ExtDeviation, int ExtBackstep)
{
    int shift, back, lasthighpos, lastlowpos;
    double val, res;
    double curlow, curhigh, lasthigh, lastlow;

    for (shift = Bars - ExtDepth; shift >= 0; shift--)
    {
        // Low.
        val = Low[Lowest(NULL, 0, MODE_LOW, ExtDepth, shift)];
        if (val == lastlow)
        {
            val = 0.0;
        }
        else 
        { 
            lastlow = val;
            if (Low[shift] - val > ExtDeviation * Point)
            {
                // It must not a Through.
                val = 0.0;
            }
            else
            {
                // Repaint the history.
                for (back = 1; back <= ExtBackstep; back++)
                {
                    res = ExtMapBuffer[shift + back];
                    if (res != 0 && res > val)
                    {
                        ExtMapBuffer[shift + back] = 0.0; 
                    }
                }
            }
        } 

        ExtMapBuffer[shift] = val;
        
        // High.
        val = High[Highest(NULL, 0, MODE_HIGH, ExtDepth, shift)];
        if (val == lasthigh)
        {
            val = 0.0;
        }
        else 
        {
            lasthigh = val;
            if (val - High[shift] > ExtDeviation * Point)
            {
                val = 0.0;
            }
            else
            {
                for (back = 1; back <= ExtBackstep; back++)
                {
                    res = ExtMapBuffer2[shift + back];
                    if(res != 0 && res < val)
                    {
                        ExtMapBuffer2[shift + back] = 0.0; 
                    }
                }
            }
        }
        
        ExtMapBuffer2[shift] = val;
    }
     
    // final cutting 
    lasthigh = -1; lasthighpos = -1;
    lastlow = -1;  lastlowpos = -1;

    for(shift = Bars - ExtDepth; shift >= 0; shift--)
    {
        curlow = ExtMapBuffer[shift];
        curhigh = ExtMapBuffer2[shift];
        if(curlow == 0 && curhigh == 0) continue;
        //---
        if (curhigh != 0)
        {
            if (lasthigh > 0) 
            {
                if (lasthigh < curhigh)
                {
                    ExtMapBuffer2[lasthighpos] = 0;
                }
                else
                {
                    ExtMapBuffer2[shift] = 0;
                }
            }
            //---
            if (lasthigh < curhigh || lasthigh < 0)
            {
                lasthigh = curhigh;
                lasthighpos = shift;
            }
            lastlow = -1;
        }
        //----
        if (curlow != 0)
        {
            if (lastlow > 0)
            {
                if(lastlow > curlow)
                {
                    ExtMapBuffer[lastlowpos] = 0;
                }
                else
                {
                    ExtMapBuffer[shift] = 0;
                }
            }
            //---
            if (curlow < lastlow || lastlow < 0)
            {
                lastlow = curlow;
                lastlowpos = shift;
            }
            lasthigh = -1;
        }
    }
  
    for (shift = Bars - 1; shift >= 0; shift--)
    {
        if(shift >= Bars - ExtDepth)
        {
            ExtMapBuffer[shift] = 0.0;
        }
        else
        {
            res = ExtMapBuffer2[shift];
            if (res != 0.0) ExtMapBuffer2[shift] = res;
        }
    }
}