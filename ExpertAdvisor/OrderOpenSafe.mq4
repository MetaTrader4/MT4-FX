
int fxOrderOpen(int cmd = FXOP_ALL, double lots = 0, double po = 0, int po_mode = PRICE_PRICE,
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE,
    int slippage = 3, string sym = "", int magic = 0, string cmt = "",
    datetime expire = 0, color col = CLR_NONE)

int ticket = fxOrderOpen(OP_BUY);