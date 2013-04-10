
Phase maybe an alias of Status.


#define PHASE_NONE 0
#define PHASE_UP 1
#define PHASE_DOWN -1


int phaseN()
{
    static phase_n = PHASE_NONE;
    
    if (phase_n != PHASE_UP)
    {
        // Here can plugin check function which has once per bar limit.
        if ()
        {
            phase_n = PHASE_UP;
        }
    }
    if (phase_n != PHASE_DOWN)
    {
        if ()
        {
            phase_n = PHASE_DOWN;
        }
    }
    if (phase_n != PHASE_NONE)
    {
        if ()
        {
            phase_n = PHASE_NONE;
        }
    }
    
    return(phase_n);
}