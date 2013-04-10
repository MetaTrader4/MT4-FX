/*
name = FX_ORDER_CHECK
*/

/*
OrderTicket()
OrderSymbol()
OrderMagicNumber()
OrderComment()
OrderLots()
OrderCommission()
OrderSwap()
OrderTakeProfit()
OrderStopLoss()
OrderOpenPrice()
OrderClosePrice()
OrderOpenTime()
OrderCloseTime()
*/

/*
bool fxOrderCheck(int ticket, string sym = "", int magic = 0, string cmt = "",
    string lots_interval = "", string profit_interval = "",
    string commission_interval = "", string swap_interval = "",
    string ptp_interval = "", string psl_interval = "", int price_mode = PRICE_PRICE,
    string op_interval = "", string cp_interval = "",
    string ot_interval = "", string ct_interval = "")
{
    OrderSelect(ticket, SELECT_BY_TICKET);
    if (
        (StringLen(sym) == 0 || OrderSymbol() == sym)
        && OrderMagicNumber() == magic
        && (StringLen(cmt) == 0 || OrderComment() == cmt)
        && intervalCheckDouble(OrderLots(), lots_interval)
        && intervalCheckDouble(OrderCommission(), commission_interval)
        && intervalCheckDouble(OrderSwap(), swap_interval)
        && intervalCheckDouble(OrderTakeProfit(), ptp_interval, price_mode)
        && intervalCheckDouble(OrderStopLoss(), psl_interval, price_mode)
        && intervalCheckDouble(OrderOpenPrice(), op_interval)
        && intervalCheckDouble(OrderClosePrice(), cp_interval)
        && intervalCheckDatetime(OrderOpenTime(), ot_interval)
        && intervalCheckDatetime(OrderCloseTime(), ct_interval)
    )
    {
        return(true);
    }
    
    return(false);
}
*/

// @todo Complete the conditions feature.

/**
 * Check if the order match the conditions.
 */
bool fxOrderCheck(int ticket, string sym = "", int magic = 0, string cmt = "", string conditions = "")
{
    OrderSelect(ticket, SELECT_BY_TICKET);
    if (
        (StringLen(sym) == 0 || OrderSymbol() == sym)
        && OrderMagicNumber() == magic
        && (StringLen(cmt) == 0 || OrderComment() == cmt || OrderComment() == StringConcatenate(cmt, "[tp]") || OrderComment() == StringConcatenate(cmt, "[sl]"))
    )
    {
        return(true);
    }
    
    return(false);
}