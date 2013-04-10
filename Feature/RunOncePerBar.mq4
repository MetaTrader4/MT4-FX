
extern bool Run_Once_PerBar = false; // If only run EA once per bar.


/**
 * Run_Once_PerBar.
 */
bool runOncePerBar()
{
    static datetime time_run_once_per_bar = 0;
    bool ret = false;
    
    if (time_run_once_per_bar < Time[0])
    {
        time_run_once_per_bar = Time[0];
        ret = true;
    }
    
    return(ret);
}


int start()
{
    if (!runOncePerBar())
    {
        return(0);
    }
}