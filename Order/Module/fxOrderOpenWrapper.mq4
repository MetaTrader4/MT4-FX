
/**
 * Wrapper for fxOrderOpen().
 */
int fxOrderOpen2(int cmd, double lots, double po, int po_mode, string cmt = "")
{
    return(fxOrderOpen(cmd, lots, po, po_mode, 0, PRICE_PRICE, 0, PRICE_PRICE, Slippage, "", 0, cmt, 0, CLR_NONE));
}

/**
 * Wrapper for fxOrderOpen().
 */
int fxOrderOpen2(int cmd, double lots, string cmt = "")
{
    return(fxOrderOpen(cmd, lots, 0, PRICE_PRICE, 0, PRICE_PRICE, 0, PRICE_PRICE, Slippage, "", 0, cmt, 0, CLR_NONE));
}

/**
 * Wrapper for fxOrderOpen().
 */
int fxOrderOpen2(int cmd, string cmt = "")
{
    return(fxOrderOpen(cmd, 0, 0, PRICE_PRICE, 0, PRICE_PRICE, 0, PRICE_PRICE, Slippage, "", 0, cmt, 0, CLR_NONE));
}