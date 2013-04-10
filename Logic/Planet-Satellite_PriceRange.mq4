
* Limit = 1, only use Planet.
* Limit > 1, use Planet and Satellite.

API
* GET, SET, DEL Planet, Satellite by Module.



#define GET 0
#define SET 1
#define DEL -1

/**
 * Prepare the module prefix.
 */
string psName(string module, string plugin)
{
    string name = StringConcatenate(AdvisorName, "|", Symbol(), "|", Magic, "|", module, "|");

    return(name);
}

/**
 * Planet operation, get/set/del.
 */
int psPlanet(string module, int op = GET, int val = 0)
{
    string name = psName(module, "Planet");
    int value = val;
    switch (op)
    {
        case GET:
            value = GlobalVariableGet(name);
            break;
        case SET:
            GlobalVariableSet(name, value);
            break;
        case DEL:
            GlobalVariableDel(name);
            break;
    }

    return(value);
}

/**
 * Satellite operation, get/set/del.
 */
int psSatellite(string module, int op = GET, int val = 0)
{
    string name = psName(module, "Satellite");
    int value = val;
    switch (op)
    {
        case GET:
            value = GlobalVariableGet(name);
            break;
        case SET:
            GlobalVariableSet(name, value);
            break;
        case DEL:
            GlobalVariableDel(name);
            break;
    }

    return(value);
}

/**
 * 
 */
void psPlanetNew()
{

}

/**
 * Calculate the total amount of orders after the planet order and within a specific price range.
 */
int psAmount(int planet_ticket, double range, string sym = "", cmd = FXOP_ALL, int magic = -1, string cmt = "")
{
    // Check wrong ticket.
    if (OrderSelect(planet_ticket, SELECT_BY_TICKET) == false)
    {
        return(-1);
    }
    int planet_cmd = OrderType();
    double planet_po = OrderOpenPrice();
    datetime planet_to = OrderOpenTime();
    int cnt = -1;
    int i;
    for (i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
        if (OrderTicket() == planet_ticket || OrderOpenTime() < planet_to) continue;
        if (
            (sym != "" && OrderSymbol() != sym)
            || (cmd != FXOP_ALL && OrderType() != cmd) 
            || (magic != -1 && OrderMagicNumber() != magic)
            || StringFind(OrderComment(), cmt) == -1
        )
        {
            continue;
        }
        
        if (MathAbs(planet_po - OrderOpenPrice()) <= range)
        {
            cnt++;
        }
    }
    
    return(cnt);
}

