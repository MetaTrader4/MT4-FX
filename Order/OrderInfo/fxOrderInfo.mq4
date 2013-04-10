
string order_info[0,16];

Order Info Structure

0. OrderTicket()
1. OrderSymbol()
2. OrderMagicNumber()
3. OrderComment()
4. OrderType()
5. OrderLots()
6. OrderTakeProfit()
7. OrderStopLoss()
8. OrderProfit()
9. OrderOpenPrice()
10. OrderOpenTime()
11. OrderClosePrice()
12. OrderCloseTime()
13. OrderExpiration()
14. OrderCommission()
15. OrderSwap()

/**
 * Load the order information from its ticket.
 */
bool fxOrderInfoImport(int ticket, string &order_info[,])
{
    if (OrderSelect(ticket, SELECT_BY_TICKET) == false) return(false);

    int size = ArrayRange(order_info, 0);
    ArrayResize(order_info, size + 1);
    string sym = marketSymbol(OrderSymbol(), SYMBOL_MARKET);
    int digi = marketDigits(sym);
    order_info[size][0] = OrderTicket();
    order_info[size][1] = sym;
    order_info[size][2] = OrderMagicNumber();
    order_info[size][3] = OrderComment();
    order_info[size][4] = OrderType();
    order_info[size][5] = DoubleToStr(OrderLots(), marketLotsPrecision(sym));
    order_info[size][6] = DoubleToStr(OrderTakeProfit(), digi);
    order_info[size][7] = DoubleToStr(OrderStopLoss(), digi);
    order_info[size][8] = DoubleToStr(OrderProfit(), 2);
    order_info[size][9] = DoubleToStr(OrderOpenPrice(), digi);
    order_info[size][10] = OrderOpenTime();
    order_info[size][11] = DoubleToStr(OrderClosePrice(), digi);
    order_info[size][12] = OrderCloseTime();
    order_info[size][13] = OrderExpiration();
    order_info[size][14] = OrderCommission();
    order_info[size][15] = OrderSwap();
    
    return(true);
}

/**
 * Multiple wrapper of fxOrderInfoImport().
 */
int fxOrderInfoImportMultiple(int order_jar[], string &order_info[,], bool reset = true)
{
    if (reset)
    {
        ArrayResize(order_info, 0);
    }
    int count = 0;
    int size = ArraySize(order_jar);
    int i;
    for (i = 0; i < size; i++)
    {
        if (fxOrderInfoImport(order_jar[i], order_info))
        {
            count++;
        }
    }
    
    return(count);
}