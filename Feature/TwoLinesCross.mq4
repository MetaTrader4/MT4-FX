
int phase = PHASE_NONE;
datetime time_phase_ma = 0;

/**
 * Calculate phase_me.
 */
void calPhaseMA()
{
    if (phase_ma != PHASE_UP)
    {
        if (mafaValue(0) > maslValue(0) && mafaValue(1) < maslValue(1))
        {
            phase_ma = PHASE_UP;
            time_phase_ma = Time[0];
        }
    }
    if (phase_ma != PHASE_DOWN)
    {
        if (mafaValue(0) < maslValue(0) && mafaValue(1) > maslValue(1))
        {
            phase_ma = PHASE_DOWN;
            time_phase_ma = Time[0];
        }
    }
    
    // Reset
    if (phase_ma == PHASE_UP && mafaValue(0) < maslValue(0))
    {
        phase_ma = PHASE_NONE;
        time_phase_ma = 0;
    }
    if (phase_ma == PHASE_DOWN && mafaValue(0) > maslValue(0))
    {
        phase_ma = PHASE_NONE;
        time_phase_ma = 0;
    }
}