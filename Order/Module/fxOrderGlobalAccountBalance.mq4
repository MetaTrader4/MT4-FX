// Global Account Balance TP/SL
extern string    GABTPSL = "--- Global Account Balance TP/SL ---";
extern bool   GABTPSL_On = true;                                   // Whether TakeProfit and StopLoss base on account balance change.
extern double GABTPSL_TP = 10;                                     // In percentage. Takeprofit by comparing account equity to account balance.
extern double GABTPSL_SL = -10;                                    // In percentage. StopLoss by comparing account equity to account balance.

/**
 * Module: Global Account Balance TP/SL.
 */
void fxOrderGABTPSL()
{
    int i;
    double profit = 0;
    for (i = 0; i < order_jar_ea_size; i++)
    {
        if (OrderSelect(order_jar_ea[i], SELECT_BY_TICKET) != false)
        {
            profit += OrderProfit();
        }
    }
    
    if (
        profit / AccountBalance() >= GABTPSL_TP / 100
        || profit / AccountBalance() <= GABTPSL_SL / 100
    )
    {
        ArrayCopy(order_queue_exit, order_jar_ea);
    }
}