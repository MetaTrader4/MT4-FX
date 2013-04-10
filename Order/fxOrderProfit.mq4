

#define PROFIT_ALL 100
#define PROFIT_POSITIVE 1
#define PROFIT_EVEN 0
#define PROFIT_NEGATIVE -1
//
#define PROFIT_PRICE 5
#define PROFIT_PIPS 10

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
 * Get the profit as return prepare for print.
 */
string fxOrderProfitString(int ticket, int type = PROFIT_PRICE, bool prefix = true)
{
    double profit = 0;
    string profit_string = "";
    OrderSelect(ticket, SELECT_BY_TICKET);
    string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int precision = marketDigits(sym);
    profit = OrderProfit();
    
    if (type == PROFIT_PIPS)
    {
        precision = 2;
        if (OrderType() == OP_BUY)
        {
            profit = marketPointsToPips(sym, marketPrice(sym, 0, MODE_BID) - OrderOpenPrice(), POINTS_PRICE, POINTS_INPUT);
        }
        else if (OrderType() == OP_SELL)
        {
            profit = marketPointsToPips(sym, OrderOpenPrice() - marketPrice(sym, 0, MODE_ASK), POINTS_PRICE, POINTS_INPUT);
        }
    }
    
    profit_string = DoubleToStr(profit, precision);
    
    if (prefix && profit > 0)
    {
        profit_string = StringConcatenate("+", profit_string);
    }
    
    return(profit_string);
}

