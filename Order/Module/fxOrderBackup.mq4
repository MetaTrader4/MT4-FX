
if (ticket < 0)
{
    fxOrderBackup(order_queue_entry, order_queue_entry_junk, i, GetLastError());
}


/**
 * Backup some error fxOrderOpen() process.
 */
void fxOrderBackup(string &order_queue[,12], int &order_queue_junk[], int index, int error)
{
    int cmd, po_mode, ptp_mode, psl_mode, slippage, magic, expire, col;
    double po, lots, ptp, psl;
    string sym, cmt;
    int ticket = -1;
    
    fxOrderExportEntryQueue(order_queue, index, cmd, po, po_mode, lots, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
    
    fxOrderPriceOpen(sym, cmd, po, po_mode);
    
    // Suppor Pend to Market.
    if (
        (cmd == OP_BUYSTOP && marketPrice(sym, 0, MODE_ASK) >= po)
        || (cmd == OP_BUYLIMIT && marketPrice(sym, 0, MODE_ASK) <= po)
    )
    {
        ticket = fxOrderOpen(OP_BUY, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        if (ticket > 0)
        {
            arrayPushInt(order_queue_junk, index);
        }
    }
    if (
        (cmd == OP_SELLSTOP && marketPrice(sym, 0, MODE_BID) <= po)
        || (cmd == OP_SELLLIMIT && marketPrice(sym, 0, MODE_BID) >= po)
    )
    {
        ticket = fxOrderOpen(OP_SELL, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        if (ticket > 0)
        {
            arrayPushInt(order_queue_junk, index);
        }
    }
}

