
int calculateWeekendGap()
{
    int i;
    int day = 0, day_old = 0;
    for (i = 0; i < Bars; i++)
    {
        day = TimeDayOfWeek(Time[i]);
        if (day_old == 0) day_old = day;
        // Encounter previous week.
        if (day > day_old)
        {
            return(Time[i-1] - Time[i] - Period() * 60);
        }
        day_old = day;
    }
}