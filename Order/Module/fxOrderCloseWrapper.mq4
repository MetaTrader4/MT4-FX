
/**
 * Wrapper for fxOrderClose().
 */
bool fxOrderClose2(string cmt)
{
    int cmd;
    if (StringFind(cmt, "Buy") != -1)
    {
        cmd = OP_BUY;
    }
    else
    {
        cmd = OP_SELL;
    }
    int counter = fxOrderCloseBy(Symbol(), cmd, Magic, cmt);

    if (counter == 0)
    {
        return(false);
    }
    return(true);
}

