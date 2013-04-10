

void orderCloseByTradingHours(int ticket, int hours_limit, int time_gap)
{
    OrderSelect(ticket, SELECT_BY_TICKET);
    int time_opened = TimeCurrent() - OrderOpenTime();
    int time_limit = hours_limit * 60 * 60;
    if (OrderOpenTime() > 0 && time_opened >= time_limit)
    {
        // Same week.
        if (time_opened <= PERIOD_W1 * 60 && DayOfWeek() > TimeDayOfWeek(OrderOpenTime()))
        {
            fxOrderClose(ticket);
        }
        // Just one weekend.
        else if (time_opened <= PERIOD_W1 * 60 && DayOfWeek() < TimeDayOfWeek(OrderOpenTime()))
        {
            if (time_opened - time_gap >= time_limit)
            {
                fxOrderClose(ticket);
            }
        }
        else if (time_opened <= PERIOD_W1 * 60 && DayOfWeek() == TimeDayOfWeek(OrderOpenTime()))
        {
            // Same day.
            if (time_opened < PERIOD_D1 * 60)
            {
                fxOrderClose(ticket);
            }
            // Cross weekend.
            if (time_opened > PERIOD_D1 * 60)
            {
                if (time_opened - time_gap >= time_limit)
                {
                    fxOrderClose(ticket);
                }
            }
        }
        else if (time_opened > PERIOD_W1 * 60)
        {
            // @todo Temporary solution, close directly.
            fxOrderClose(ticket);
        }
    }
}