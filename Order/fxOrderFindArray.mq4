/*
name = FX_ORDER_FIND
dependencies[] = FX_MARKET_SYMBOL
dependencies[] = FX_ORDER_TYPE
dependencies[] = FX_ORDER_CHECK
// Need to deal dependencies[] = FX_ORDER_PROFIT
*/

// Profit type.
#define PROFIT_ALL 100
#define PROFIT_EVEN 0
#define PROFIT_POSITIVE 1
#define PROFIT_NEGATIVE -1

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
int fxOrderFindA(int &order_jar[],
    string syms[], int types[], int magics[], string cmts[],
    int profit_type = PROFIT_ALL,
    bool reset = true)
{
    // Make sure it's new.
    if (reset)
    {
        ArrayResize(order_jar, 0);
    }
    
    int i, ticket, cmd, magic;
    string sym, cmt;
    double profit;
    for (i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
        sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
        ticket = OrderTicket();
        magic = OrderMagicNumber();
        cmd = OrderType();
        cmt = OrderComment();
        profit = OrderProfit();
        if (
            fxOrderProfitCheck(profit, profit_type)
            && inArrayInt(cmd, types) != -1
            && inArrayInt(magic, magics) != -1
            && inArrayString(sym, syms) != -1
            && inArrayString(cmt, cmts) != -1
        )
        {
            arrayPushInt(order_jar, ticket);
            
            // Hook: hook_order_find_a().
            hook_order_find_a();
        }
    }
    
    return(ArraySize(order_jar));
}

/**
 * Hook: hook_order_find_a().
 */
void hook_order_find_a()
{
}

/**
 * Check the profit type.
 */
bool fxOrderProfitCheck(double profit, int profit_type = PROFIT_ALL)
{
    if (
        profit_type == PROFIT_ALL
        || (profit_type == PROFIT_POSITIVE && profit > 0) 
        || (profit_type == PROFIT_NEGATIVE && profit < 0)
        || (profit_type == PROFIT_EVEN && profit == 0)
    )
    {
        return(true);
    }
    
    return(false);
}