/**
 * Trade Time Filter.
 *
 * @see http://kolier.li/example/script-function-trade-time-filter.
 */
bool tradeTime()
{
    if (TTFilter_On) {
        datetime time_now, time_begin[0], time_end[0];
        explodeToDateTime(time_begin, TTFilter_TradeBegin);
        explodeToDateTime(time_end, TTFilter_TradeEnd);

        int not = 0;
        int i;
        int size = ArraySize(time_begin);
        time_now = TimeCurrent();
        for (i = 0; i < size; i++) {
            if (time_end[i] < time_begin[i])
            {
                if (time_now < time_end[i])
                {
                    time_begin[i] -= 86400;
                }
                else if (time_now > time_end[i])
                {
                    time_end[i] += 86400;
                }
            }

            if (time_now < time_begin[i] || time_now > time_end[i])
            {
                not++;
            }
        }

        if (not >= size)
        {
            return(false);
        }
    }

    return(true);
}