
// Module: Order Queue.
int order_queue_entry_junk[0], order_queue_exit[0], order_queue_exit_junk[0];
string order_queue_entry[0,14];

/**
 * Create a new order queue.
 */
void fxOrderImportEntryQueue(string &order_queue[,], int cmd, string cmt = "",
    double po = 0, int po_mode = PRICE_PRICE, double lots = 0,
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE,
    int slippage = 3, string sym = "",
    int magic = 0, datetime expire = 0, color col = CLR_NONE)
{
    int size = ArrayRange(order_queue, 0);
    ArrayResize(order_queue, size + 1);
    sym = marketSymbol(sym, SYMBOL_ORDER);
    int digi = marketDigits(sym);
    order_queue[size][0] = cmd;
    order_queue[size][1] = DoubleToStr(po, digi);
    order_queue[size][2] = po_mode;
    order_queue[size][3] = DoubleToStr(lots, marketLotsPrecision(sym));
    order_queue[size][4] = DoubleToStr(ptp, digi);
    order_queue[size][5] = ptp_mode;
    order_queue[size][6] = DoubleToStr(psl, digi);
    order_queue[size][7] = psl_mode;
    order_queue[size][8] = slippage;
    order_queue[size][9] = sym;
    order_queue[size][10] = magic;
    order_queue[size][11] = cmt;
    order_queue[size][12] = expire;
    order_queue[size][13] = col;
}

/**
 * Prepare the order open metadata.
 */
void fxOrderExportEntryQueue(string order_queue[,], int index, int &cmd,
    double &po, int &po_mode, double &lots,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode, int &slippage, string &sym,
    int &magic, string &cmt, datetime &expire, color &col)
{
    cmd = StrToInteger(order_queue[index][0]);
    po = StrToDouble(order_queue[index][1]);
    po_mode = StrToInteger(order_queue[index][2]);
    lots = StrToDouble(order_queue[index][3]);
    ptp = StrToDouble(order_queue[index][4]);
    ptp_mode = StrToInteger(order_queue[index][5]);
    psl = StrToDouble(order_queue[index][6]);
    psl_mode = StrToInteger(order_queue[index][7]);
    slippage = StrToInteger(order_queue[index][8]);
    sym = order_queue[index][9];
    magic = StrToInteger(order_queue[index][10]);
    cmt = "" + order_queue[index][11];
    expire = StrToInteger(order_queue[index][12]);
    col = StrToInteger(order_queue[index][13]);
}

/**
 * Count number of order in order_queue.
 */
int countOrderQueue(string order_queue[,], string cmt)
{
    int i;
    int count = 0;
    int size = ArrayRange(order_queue, 0);
    
    for (i = 0; i < size; i++)
    {
        if (order_queue[i,11] == cmt)
        {
            count += 1;
        }
    }
    
    return(count);
}

/**
 * Process order_queue_entry.
 */
void fxOrderQueueEntryProcess()
{
    bool flag_order_jar_ea = false;
    int i, j, size, ticket;
    // Variables of order metadata.
    int cmd, po_mode, ptp_mode, psl_mode, slippage, magic, expire, col;
    double po, lots, ptp, psl;
    string sym, cmt;
    // OrderSend order_queue_entry.
    size = ArrayRange(order_queue_entry, 0);
    for (i = 0; i < size; i++)
    {
        fxOrderExportEntryQueue(order_queue_entry, i, cmd, po, po_mode, lots, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        ticket = fxOrderOpen(cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        if (ticket > 0 || (ticket < 0 && GetLastError() != 146))
        {
            // Order queue process sucessfully, add to junk.
            arrayPushInt(order_queue_entry_junk, i);
        }
    }
    
    // Deal order_queue_entry with order_queue_entry_junk.
    string order_queue_entry_tmp[,14];
    array2DRemoveAndSortMultiString(order_queue_entry, order_queue_entry_tmp, order_queue_entry_junk);
    ArrayResize(order_queue_entry_junk, 0);
}

/**
 * Process order_queue_exit.
 */
void fxOrderQueueExitProcess()
{
    bool flag_order_jar_ea = false;
    int i;
    // OrderClose order_queue_exit.
    int size = ArraySize(order_queue_exit);
    for (i = 0; i < size; i++)
    {
        bool result = fxOrderClose(order_queue_exit[i]);
        if (result || (!result && GetLastError() == 4108))
        {
            // Order queue process sucessfully, add to junk.
            arrayPushInt(order_queue_exit_junk, i);
            
            flag_order_jar_ea = true;
        }
    }
    
    // Deal order_queue_exit with order_queue_exit_junk.
    arrayRemoveAndSortMultiInt(order_queue_exit, order_queue_exit_junk);
    ArrayResize(order_queue_exit_junk, 0);
}