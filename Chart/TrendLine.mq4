
// TrendLine
#define SUPPORT 1
#define RESISSTANT -1


/**
 * Draw a trend line within a specific time period (two datetime).
 */
void fxTrendLineDrawA(int type, datetime start, datetime end)
{
    double prices[0];
    ArrayResize(prices, 0);
    int bar_start = iBarShift(NULL, 0, start);
    int bar_end = iBarShift(NULL, 0, end);
    int bar_count = bar_start - bar_end + 1;
    int i, bar_i;
    // Prepare values.
    if (type == SUPPORT)
    {
        for (i = 0; i < bar_count; i++)
        {
            bar_i = bar_start - i;
            arrayPushDouble(prices, Low[bar_i]);
        }
    }
    else if (type == RESISSTANT)
    {
        for (i = 0; i < bar_count; i++)
        {
            bar_i = bar_start - i;
            arrayPushDouble(prices, High[bar_i]);
        }
    }
    // Find the sailient points.
    int pts[2], bar_pts[2];
    ArrayInitialize(pts, -1);
    ArrayInitialize(bar_pts, -1);
    fxTrendLinePts(type, prices, pts);
    // Draw.
    if (pts[0] >= 0 && pts[1] >= 0)
    {
        bar_pts[0] = bar_start - pts[0];
        bar_pts[1] = bar_start - pts[1];
        if (type == SUPPORT)
        {
            objTrendLine("TrendLine|Support", Time[bar_pts[0]], Low[bar_pts[0]], Time[bar_pts[1]], Low[bar_pts[1]], 0, 1, Blue);
        }
        else if(type == RESISSTANT)
        {
            objTrendLine("TrendLine|Resisstant", Time[bar_pts[0]], High[bar_pts[0]], Time[bar_pts[1]], High[bar_pts[1]], 0, 1, Red);
        }
    }
}

/**
 * Draw a trend line within a specific time period (two datetime).
 */
void fxTrendLineDrawB(int type, datetime start, datetime end)
{
    double prices[0];
    ArrayResize(prices, 0);
    int bar_start = iBarShift(NULL, 0, start);
    int bar_end = iBarShift(NULL, 0, end);
    int bar_count = bar_start - bar_end + 1;
    int i, bar_i;
    // Prepare values.
    if (type == SUPPORT)
    {
        fxPriceFeedB(prices, Symbol(), 0, PRICE_LOW, bar_start, bar_count);
    }
    else if (type == RESISSTANT)
    {
        fxPriceFeedB(prices, Symbol(), 0, PRICE_HIGH, bar_start, bar_count);
    }
    // Find the sailient points.
    int pts[2], bar_pts[2];
    ArrayInitialize(pts, -1);
    ArrayInitialize(bar_pts, -1);
    fxTrendLinePts(type, prices, pts);
    // Draw.
    if (pts[0] >= 0 && pts[1] >= 0)
    {
        bar_pts[0] = bar_start - pts[0];
        bar_pts[1] = bar_start - pts[1];
        if (type == SUPPORT)
        {
            objTrendLine("TrendLine|Support", Time[bar_pts[0]], Low[bar_pts[0]], Time[bar_pts[1]], Low[bar_pts[1]], 0, 1, Blue);
        }
        else if(type == RESISSTANT)
        {
            objTrendLine("TrendLine|Resisstant", Time[bar_pts[0]], High[bar_pts[0]], Time[bar_pts[1]], High[bar_pts[1]], 0, 1, Red);
        }
    }
}

/**
 * Input values array, find two sailient points for drawing TrendLine.
 */
void fxTrendLinePts(int type, double vals[], int &pts[])
{
    int size = ArraySize(vals);
    ArrayResize(pts, 2);
    ArrayInitialize(pts, -1);

    double a, b, y;
    int i;
    if (type == SUPPORT)
    {
        for (i = 0; i < size; i++)
        {
            // Initiate the point(1).
            if (i == 0)
            {
                pts[0] = i;
                pts[1] = -1;
            }
            else
            {
                // No TrendLine.
                if (pts[1] < 0)
                {
                    // New low, or equal value.
                    if (vals[i] <= vals[pts[0]])
                    {
                        pts[0] = i;
                    }
                    // Bar is older than the point(1).
                    // Have a higher low. (Previous condition checked)
                    if (i > pts[0])
                    {
                        pts[1] = i;
                    }
                }
                // TrendLine exists, check status.
                else if (pts[0] >= 0 && pts[1] >= 0)
                {
                    // New low or equal value.
                    // (*) Equal value means a must cross.
                    // Need to form a new trendline.
                    if (vals[i] <= vals[pts[0]])
                    {
                        pts[0] = i;
                        pts[1] = -1;
                    }
                    // No need to form a new trendline.
                    if (pts[0] >= 0 && pts[1] >= 0)
                    {
                        // Calculate the y = a * x + b.
                        a = (vals[pts[1]] - vals[pts[0]]) / (pts[1] - pts[0]);
                        b = vals[pts[0]] - a * pts[0];
                        y = a * i + b;
                        // But if the old trendline cross the new candle body?
                        if (y > vals[i])
                        {
                            // Not a new low.
                            // New low get checked before.
                            // Just move the point(2) to it.
                            pts[1] = i;
                        }
                    }
                }
            }
        }
    }
    else if (type == RESISSTANT)
    {
        for (i = 0; i < size; i++)
        {
            // Initiate the point(1).
            if (i == 0)
            {
                pts[0] = i;
                pts[1] = -1;
            }
            else
            {
                // No TrendLine.
                if (pts[1] < 0)
                {
                    // New high, or equal value.
                    if (vals[i] >= vals[pts[0]])
                    {
                        pts[0] = i;
                    }
                    // Bar is older than the point(1).
                    // Have a lower high. (Previous condition checked)
                    if (i > pts[0])
                    {
                        pts[1] = i;
                    }
                }
                // TrendLine exists, check status.
                else if (pts[0] >= 0 && pts[1] >= 0)
                {
                    // New high or equal value.
                    // (*) Equal value means a must cross.
                    // Need to form a new trendline.
                    if (vals[i] >= vals[pts[0]])
                    {
                        pts[0] = i;
                        pts[1] = -1;
                    }
                    // No need to form a new trendline.
                    if (pts[0] >= 0 && pts[1] >= 0)
                    {
                        // Calculate the y = a * x + b.
                        a = (vals[pts[1]] - vals[pts[0]]) / (pts[1] - pts[0]);
                        b = vals[pts[0]] - a * pts[0];
                        y = a * i + b;
                        // But if the old trendline cross the new candle body?
                        if (y < vals[i])
                        {
                            // Not a new high.
                            // New high get checked before.
                            // Just move the point(2) to it.
                            pts[1] = i;
                        }
                    }
                }
            }
        }
    }
}