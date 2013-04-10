
extern bool Order_EntryReport = false;                // Send mail to report new entry order.

/**
 * Module: Order_EntryReport.
 */
void fxOrderEntryReport(int order_jar[])
{
    if (!Order_EntryReport) return;

    int size = ArraySize(order_jar);
    if (size == 0) return;

    string text = "";
    int i;
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET) == false) continue;
        
        text = Advisor + " New Entry at " + Symbol();
        SendMail(text, text);
    }
}