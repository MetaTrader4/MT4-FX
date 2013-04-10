Pros:
- If lost in the middle, level will still move again if price away from the pivot order.

Cons:
- 


#define GET 0
#define SET 1
#define DEL -1

/**
 * Level prefix.
 */
string levelPrefix(string module)
{
    return(AdvisorName + "|" + Symbol() + "|" + Period() + "|" + Magic + "|" + module + "|Level|");
}

/**
 * Operation of the level order.
 */
int levelOrder(string module, int op = GET, double value)
{
    module = levelPrefix(module);
    switch (op)
    {
        case GET:
            
            break;
        case SET:
            
            break;
        case DEL:
            
            break;
    }
}

/**
 * Calculate the traded amount since the level order.
 * mode: 0 = Total, 1 = Buy, -1 = Sell.
 * ignore is a order comment wildcard check to ignore consider in amount.
 */
int levelAmount(int ticket, int mode = 0, string ignore = "")
{
    if (ticket <= 0) return(0);
    OrderSelect(ticket, SELECT_BY_TICKET);
    double level_price = OrderOpenPrice();
    datetime level_time = OrderOpenTime();
    int amount_buy = 0, amount_sell = 0;
    // Loop the orders to find out.
    int i;
    for (i = 0; i < OrdersTotal(); i++)
    {
        
    }
    for (i = 0; i < OrdersHistoryTotal(); i++)
    {
        
    }
}

