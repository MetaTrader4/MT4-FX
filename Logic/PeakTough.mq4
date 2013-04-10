Simulation

Peak
1. A potential peak point which higher than the beside two points.
2. This potential peak point still higher than the points within 2 steps.


/**
 * Find the recent peak and check if price cross.
 */
int ma1PeakCross()
{
    int ret = -1;
    int i, j;
    int count = 0;
    int test = 3;
    int cross_i = 0;
    for (i = test; i < Bars; i++)
    {
        for (j = 1; j <= test; j++)
        {
            if (ma1Value(i) > ma1Value(i+j) && ma1Value(i) > ma1Value(i-j))
            {
                count++;
            }
        }
        if (count == test)
        {
            cross_i = i;
            break;
        }
    }
    
    if (Close[0] > ma1Value(cross_i) && Open[0] < ma1Value(cross_i))
    {
        ret = cross_i;
    }
    
    return(ret);
}