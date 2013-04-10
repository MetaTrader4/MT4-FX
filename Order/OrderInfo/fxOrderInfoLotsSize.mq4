
/**
 * Calculate how many lots in the order_info[,16] specified.
 */
double fxOrderInfoLotsSize(string order_info[,16], string sym, int cmd)
{
    double lots = 0;
    int size_order_info = ArrayRange(order_info, 0);
    for (int i = 0; i < size_order_info; i++)
    {
        if (
            order_info[i][1] == sym
            && StrToInteger(order_info[i][4]) == cmd
        )
        {
            lots += StrToDouble(order_info[i][5]);
        }
    }

    return(lots);
}