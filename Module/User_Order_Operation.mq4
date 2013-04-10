//dependencies[] = FX_Order_Open

// Order Operation
extern string Order_Operation = "--- Order Operation ---";
extern int              Magic = 222222;                    // For identify trades belong to this EA, set to unique on different chart when using at the same time.
extern int           Slippage = 3;                         // Allow slippage.
extern double            Lots = 0.1;                       // Fixed trade lots without using MoneyManagement.
extern double      TakeProfit = 0;                         // In Pips. Take Profit, Change to 0 if you don't want to use.
extern double        StopLoss = 0;                         // In Pips. Stop Loss, Change to 0 if you don't want to use.


void hook_order_pre_open(string &sym, int &cmd, double &lots, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode, int &slippage,
    string &cmt, int &magic, datetime &expire, color &col)
{
    // Module: User Order Operation. Override with the user input.
    sym = StringConcatenate(SymbolPrefix, sym, SymbolSuffix);
    if (magic == 0)
    {
        magic = Magic;
    }
    slippage = Slippage;
    if (lots == 0)
    {
        lots = Lots;
        if (MM_On)
        {
            lots = mmLots(sym);
        }
    }
    if (
        (ptp <= 0 && TakeProfit > 0)
    )
    {
        ptp = TakeProfit;
        ptp_mode = PRICE_PIPS;
    }
    if (
        (psl <= 0 && StopLoss > 0)
    )
    {
        psl = StopLoss;
        psl_mode = PRICE_PIPS;
    }
}