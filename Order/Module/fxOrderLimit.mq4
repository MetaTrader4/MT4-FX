

extern int     Order_MaxOpening = 4;                      // Global opening order limit.


/**
 * OrderOpening Max Limit.
 */
bool orderOpeningMax(int op_type = FXOP_ALL, int max = 1)
{
    switch (op_type)
    {
        case FXOP_ALL:
            int order_type[4] = {FXOP_OPENING, FXOP_ALL, FXOP_ALL, FXOP_ALL};
            order_jar_ea_size = fxOrderFind(order_jar_ea, order_type, PROFIT_ALL, Symbol(), Magic);
            if (order_jar_ea_size < max)
            {
                return(true);
            }
            break;
        case OP_BUY:
            int order_type_buy[4] = {FXOP_OPENING, FXOP_MARKET, FXOP_ALL, OP_BUY};
            order_jar_ea_buy_size = fxOrderFind(order_jar_ea_buy, order_type_buy, PROFIT_ALL, Symbol(), Magic);
            if (order_jar_ea_buy_size < max)
            {
                return(true);
            }
            break;
        case OP_SELL:
            int order_type_sell[4] = {FXOP_OPENING, FXOP_MARKET, FXOP_ALL, OP_SELL};
            order_jar_ea_sell_size = fxOrderFind(order_jar_ea_sell, order_type_sell, PROFIT_ALL, Symbol(), Magic);
            if (order_jar_ea_sell_size < max)
            {
                return(true);
            }
            break;
    }
    
    return(false);
}