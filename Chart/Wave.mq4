Use a price as a level, look back to search a price (1) lower than the level and (2) the lowest.

Use iHighest() as a level to test through, a lowest to test peak.

It's best to add a before hand condition that as a high/low breakout


//---------- Indicator ----------//
- SteveMob_SRE-Alert.mq4


//---------- EA ----------//
- WinfriedHuf_EC_EA.mq4


//---------- Implementation ----------//

// Find the Highest/Lowest before breach.
double findPT(string type, int tf, int bar, double level)
{
    double price = level, price_tmp;
    int i;
    if (type == "through")
    {
        for (i = 0; i < 100; i++)
        {
            price_tmp = iLow(NULL, tf, bar + i);
            if (price_tmp > level) break;
            if (price_tmp < price)
            {
                price = price_tmp;
            }
        }
    }
    else if (type == "peak")
    {
        for (i = 0; i < 100; i++)
        {
            price_tmp = iHigh(NULL, tf, bar + i);
            if (price_tmp < level) break;
            if (price_tmp > price)
            {
                price = price_tmp;
            }
        }
    }
    
    return(price);
}