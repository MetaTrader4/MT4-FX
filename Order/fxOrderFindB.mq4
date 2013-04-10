/*
name = FX_ORDER_FIND
dependencies[] = FX_MARKET_SYMBOL
dependencies[] = FX_ORDER_TYPE
dependencies[] = FX_ORDER_CHECK
// Need to deal dependencies[] = FX_ORDER_PROFIT
*/

//---------- fxOrderFind ----------//
/*
ByTicket
ByOrderType
BySymbol
ByCMD
ByLots
ByOpenPrice
ByOpenTime
ByTakeProfit, ByProfit
ByStopLoss, ByLoss
ByMagic
ByComment
*/

/*
1. Use Magic to group the 
Comment format. Parse comment.
1_[Entry_Reason]
2_[Entry_Reason]_[Time_To_Exit]
N_*_*_*
*/

/*
order_type[4]
order_type[0] = OP_ALL, OP_OPENING, OP_HISTORY.
order_type[1] = OP_ALL, OP_MARKET, OP_PEND.
order_type[2] = OP_STOP, OP_LIMIT.
order_type[3] = OP_ALL, OP_BUY, OP_SELL.
*/

/*
interval
Within datetime1->datetime2
Support has '->' or not.
*/

/*
Conditions[]
Condition[]
    [0]ConditionType
    [1]Value
    [2]Operator;
*/

/*
options:
- Comment_Wildcard
    Match '*' to any string.
- 

e.g. Comment_Wildcard|xxx|yyy|zzz
*/

/**
 * Find orders and put into an order_jar.
 * 
 */
int fxOrderFind(int &order_jar[],
    int order_type[],
    int order_profit = PROFIT_ALL,
    string sym = "", int magic = 0, string cmt = "",
    string options = "", bool reset = true)
{
    // Make sure it's new.
    if (reset)
    {
        ArrayResize(order_jar, 0);
    }
    if (StringLen(sym) > 0)
    {
        sym = marketSymbol(sym, SYMBOL_ORDER);
    }
    int i, ticket, cmd;
    double profit;
    // if space == FXOP_TOTAL, FXOP_ALL, FXOP_OPENING.
    if (order_type[0] != FXOP_HISTORY)
    {
        for (i = 0; i < OrdersTotal(); i++)
        {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
            ticket = OrderTicket();
            cmd = OrderType();
            profit = OrderProfit();
            if (
                fxOrderProfitCheck(profit, order_profit)
                && fxOrderTypeCheck(FXOP_OPENING, cmd, order_type)
                && fxOrderCheck(ticket, sym, magic, cmt, options)
            )
            {
                arrayPushInt(order_jar, ticket);
            }
        }
    }
    // if space == FXOP_TOTAL, FXOP_ALL, FXOP_HISTORY.
    if (order_type[0] != FXOP_OPENING)
    {
        for (i = 0; i < OrdersHistoryTotal(); i++)
        {
            OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
            ticket = OrderTicket();
            cmd = OrderType();
            profit = OrderProfit();
            if (
                fxOrderProfitCheck(profit, order_profit)
                && fxOrderTypeCheck(FXOP_HISTORY, cmd, order_type)
                && fxOrderCheck(ticket, sym, magic, cmt, options)
            )
            {
                arrayPushInt(order_jar, ticket);
            }
        }
    }
    
    return(ArraySize(order_jar));
}

/**
 * Check if the order match the conditions.
 */
bool fxOrderCheck(int ticket, string sym = "", int magic = 0, string cmt = "", string options = "")
{
    OrderSelect(ticket, SELECT_BY_TICKET);
    if (
        (StringLen(sym) == 0 || OrderSymbol() == sym)
        && OrderMagicNumber() == magic        
    )
    {
        if (StringFind(options, "Comment_Wildcard") != -1)
        {
            if (StringLen(cmt) == 0 || StringFind(OrderComment(), cmt) != -1)
            {
                return(true);
            }
        }
        else
        {
            if (StringLen(cmt) == 0 || OrderComment() == cmt || OrderComment() == StringConcatenate(cmt, "[tp]") || OrderComment() == StringConcatenate(cmt, "[sl]"))
            {
                return(true);
            }
        }
    }
    
    return(false);
}

/**
 * Check the profit type.
 */
bool fxOrderProfitCheck(double profit, int order_profit = PROFIT_ALL)
{
    if (
        order_profit == PROFIT_ALL
        || (order_profit == PROFIT_POSITIVE && profit > 0) 
        || (order_profit == PROFIT_NEGATIVE && profit < 0)
        || (order_profit == PROFIT_EVEN && profit == 0)
    )
    {
        return(true);
    }
    
    return(false);
}

/**
 * if space = FXOP_TOTAL don't check.
 */
bool fxOrderTypeCheck(int space_raw, int op_type_raw, int order_type[])
{
    if (order_type[0] == FXOP_TOTAL)
    {
        return(true);
    }
    
    int space = order_type[0], time = order_type[1], time_extra = order_type[2], side = order_type[3];
    int time_raw, time_extra_raw, side_raw;
    switch (op_type_raw)
    {
        case OP_BUY:
            time_raw = FXOP_MARKET;
            time_extra_raw = FXOP_ALL;
            side_raw = OP_BUY;
            break;
        case OP_SELL:
            time_raw = FXOP_MARKET;
            time_extra_raw = FXOP_ALL;
            side_raw = OP_SELL;
            break;
        case OP_BUYLIMIT:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_LIMIT;
            side_raw = OP_BUY;
            break;
        case OP_BUYSTOP:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_STOP;
            side_raw = OP_BUY;
            break;
        case OP_SELLLIMIT:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_LIMIT;
            side_raw = OP_SELL;
            break;
        case OP_SELLSTOP:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_STOP;
            side_raw = OP_SELL;
            break;
    }
    
    if (
        (space == FXOP_ALL || space_raw == space)
        && (time == FXOP_ALL || time_raw == time)
        && (time_extra == FXOP_ALL || time_extra_raw == time_extra)
        && (side == FXOP_ALL || side_raw == side)
    )
    {
        return(true);
    }
    
    return(false);
}