

void function()
{
    static time_check = 0;
    if (time_check == Time[0]) return;
    // Ignore the first check if away from the start for 15 seconds.
    // if (time_check == Time[0] || TimeCurrent() - Time[0] > 15) return;
    
    time_check = Time[0];
}