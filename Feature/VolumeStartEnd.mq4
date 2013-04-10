
Use volume to start/end the market in/out operation.



/**
 * Volume Start/End.
 */
bool volumeStartEnd(int quote)
{
    if (!) return(true);
    
    bool ret = false;
    if (Volume[1] >= quote)
    {
        ret = true;
    }
    
    return(ret);
}