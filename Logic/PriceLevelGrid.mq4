
API
* Find out which grid the specific price locates.
* Find out what's  trading orders amount of a specific type in the specific grid.

/**
 * Find out which grid the specific price locates.
 */
bool levelGridLocate(double &pr[], double price, double gap)
{
    ArrayResize(pr, 2);
    ArrayInitialize(pr, 0);
    int i = 0, j = 0;
    i = MathFloor(price / gap);
    j = i + 1;
    pr[0] = gap * i;
    pr[1] = gap * j;

    bool ret = false;
    if (i > 0)
    {
        ret = true;
    }
    return(ret);
}


/**
 * Find out how many orders get trade with a pr.
 */
int levelOrderAmount(int cmd, double pr[], string cmt = "")
{
    int i;
    int counter = 0;
    for (i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
        if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic || OrderType() != cmd || StringFind(OrderComment(), cmt) == -1) continue;
        if (cmd == OP_BUY)
        {
            if (OrderOpenPrice() >= pr[0] && OrderOpenPrice() < pr[1])
            {
                counter++;
            }
        }
        else if (cmd == OP_SELL)
        {
            if (OrderOpenPrice() <= pr[1] && OrderOpenPrice() > pr[0])
            {
                counter++;
            }
        }
    }
    for (i = 0; i < OrdersHistoryTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == false) continue;
        if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic || OrderType() != cmd || StringFind(OrderComment(), cmt) == -1) continue;
        if (cmd == OP_BUY)
        {
            if (OrderOpenPrice() >= pr[0] && OrderOpenPrice() < pr[1])
            {
                counter++;
            }
        }
        else if (cmd == OP_SELL)
        {
            if (OrderOpenPrice() <= pr[1] && OrderOpenPrice() > pr[0])
            {
                counter++;
            }
        }
    }

    return(counter);
}

