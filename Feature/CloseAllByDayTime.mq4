
// Close Orders By Day Time
extern string CloseAllByDayTime = "--- Close Orders By Day Time ---";
extern bool            CABDT_On = false;                              // If use CloseAllByDayTime.
extern int            CABDT_Day = 5;                                  // Choose the week day. 0 = Sunday, 1 = Monday, etc.
extern string        CABDT_Time = "20:00";                            // After the time, the EA will close all orders.


/**
 * Module: Close Orders By Day Time.
 */
void closeAllByDayTime()
{
    if (DayOfWeek() >= CABDT_Day)
    {
        string time_text = StringConcatenate(TimeToStr(TimeCurrent(), TIME_DATE), " ", CABDT_Time);
        if (TimeCurrent() >= StrToTime(time_text))
        {
            // Close the orders.
            ArrayCopy(order_queue_exit, order_jar_ea);
        }
    }
}