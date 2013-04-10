1. Collect the salient points.
    Three points can confirm a salient point at most time.
    If the central values are equal, keep add up side value to check.
2. Find the relative two if want to format a trendline.



// Normal 0
#define PEAK 1
#define TROUGH -1

/**
 * Find and collect the salient points.
 */
void fxSalientPoints(int type, double vals[], double &pts[])
{
    ArrayResize(pts, 0);
    int size = ArraySize(vals);
    int i;
    if (type == PEAK)
    {
        for (i = 1; i < size - 1; i++)
        {
            // Simple. If encounter twins, need to use complex method.
            if (vals[i] > vals[i+1] && vals[i] > vals[i-1])
            {
                arrayPushInt(pts, i);
            }
            else if (vals[i] == vals[i+1] || vals[i] == vals[i-1])
            {
                // Log, check next, if one brother is, then add all.
            }
        }
    }
    else if (type == TROUGH)
    {
        for (i = 1; i < size - 1; i++)
        {
            if (vals[i] < vals[i+1] && vals[i] < vals[i-1])
            {
                arrayPushInt(pts, i);
            }
        }
    }
}

/**
 * Find the points from a value array.
 *
 * cnt = 0 means get all points, if set to 2, will only get the maximum two points.
 */
void fxPeakTrough(int type, double vals[], double &pts[], int cnt = 0)
{
    ArrayResize(pts, 0);
    
}