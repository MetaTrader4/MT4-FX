
Prepare the EA's Order Jars.

/**
 * Module: EA Order Jar Prepare.
 *
 * Prepare the EA's Order Jars.
 */
void fxOrderJarEA()
{
    ArrayResize(order_jar_ea, 0);
    ArrayResize(order_jar_ea_long, 0);
    ArrayResize(order_jar_ea_short, 0);

    int i;
    for (i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
        
        if (
            OrderSymbol() == Symbol()
            && OrderMagicNumber() == Magic
        )
        {
            arrayPushInt(order_jar_ea, OrderTicket());
            switch (OrderType())
            {
                case OP_BUY:
                case OP_BUYLIMIT:
                case OP_BUYSTOP:
                    arrayPushInt(order_jar_ea_long, OrderTicket());
                    break;
                case OP_SELL:
                case OP_SELLLIMIT:
                case OP_SELLSTOP:
                    arrayPushInt(order_jar_ea_short, OrderTicket());
                    break;
            }
        }
    }
    
    order_jar_ea_size = ArraySize(order_jar_ea);
    order_jar_ea_long_size = ArraySize(order_jar_ea_long);
    order_jar_ea_short_size = ArraySize(order_jar_ea_short);
}