
/**
 * Create a new order queue.
 */
void fxOrderImportEntryQueue(int cmd, double po = 0, double lots = 0, double ptp = 0,
    double psl = 0, int price_mode = PRICE_PIPS, int slippage = 3, string sym = "",
    int magic = 0, string cmt = "", datetime expire = 0, color col = CLR_NONE)
{
    int size = ArraySize(order_entry_queue);
    ArrayResize(order_entry_queue, size + 1);
    marketSymbol(sym);
    int digi = marketDigits(sym);
    order_entry_queue[size][0] = cmd;
    order_entry_queue[size][1] = DoubleToStr(po, digi);
    order_entry_queue[size][2] = DoubleToStr(lots, marketLotsPrecision(sym));
    order_entry_queue[size][3] = DoubleToStr(ptp, digi);
    order_entry_queue[size][4] = DoubleToStr(psl, digi);
    order_entry_queue[size][5] = price_mode;
    order_entry_queue[size][6] = slippage;
    order_entry_queue[size][7] = sym;
    order_entry_queue[size][8] = magic;
    order_entry_queue[size][9] = cmt;
    order_entry_queue[size][10] = expire;
    order_entry_queue[size][11] = col;
}

/**
 * Prepare the order open metadata.
 */
void fxOrderExportEntryQueue(int index, int &cmd, double &po, double &lots,
    double &ptp, double &psl, int &price_mode, int &slippage, string &sym,
    int &magic, string &cmt, datetime &expire, color &col)
{
    cmd = StrToInteger(order_entry_queue[index][0]);
    po = StrToDouble(order_entry_queue[index][1]);
    lots = StrToDouble(order_entry_queue[index][2]);
    ptp = StrToDouble(order_entry_queue[index][3]);
    psl = StrToDouble(order_entry_queue[index][4]);
    price_mode = StrToInteger(order_entry_queue[index][5]);
    slippage = StrToInteger(order_entry_queue[index][6]);
    sym = order_entry_queue[index][7];
    magic = StrToInteger(order_entry_queue[index][8]);
    cmt = order_entry_queue[index][9];
    expire = StrToInteger(order_entry_queue[index][10]);
    col = StrToInteger(order_entry_queue[index][11]);
}