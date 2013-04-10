
* Level

- Type
- Price
- Amount

- FlagNew: If it is new level
- FlagInitiate: If it is the first time run through level


//---------- Level:Start ----------//  

/**
 * Level prefix.
 */
string levelPrefix(string module)
{
    return(AdvisorName + "|" + Symbol() + "|" + Period() + "|" + Magic + "|" + module + "|Level|");
}

/**
 * Check if the level function active.
 */
bool levelActive(string module)
{
    if (GlobalVariableCheck(levelPrefix(module) + "Type"))
    {
        return(true);
    }
    
    return(false);
}

/**
 * Reset the level information.
 */
void levelReset(string module)
{
    levelType(module, DEL);
    levelPrice(module, DEL);
    levelAmount(module, DEL);
    levelFlagNew(module, DEL);
    levelFlagInitiate(module, DEL);
}

/**
 * Level type Get/Set.
 */
int levelType(string module, int op = GET, int value = 0)
{
    if (op == GET)
    {
        return(GlobalVariableGet(levelPrefix(module) + "Type"));
    }
    else if (op == SET)
    {
        GlobalVariableSet(levelPrefix(module) + "Type", value);
    }
    else if (op == DEL)
    {
        GlobalVariableDel(levelPrefix(module) + "Type");
    }

    return(GlobalVariableGet(levelPrefix(module) + "Type"));
}

/**
 * Level price Get/Set.
 */
double levelPrice(string module, int op = GET, double value = 0)
{
    if (op == GET)
    {
        return(GlobalVariableGet(levelPrefix(module) + "Price"));
    }
    else if (op == SET)
    {
        GlobalVariableSet(levelPrefix(module) + "Price", value);
    }
    else if (op == DEL)
    {
        GlobalVariableDel(levelPrefix(module) + "Price");
    }

    return(GlobalVariableGet(levelPrefix(module) + "Price"));
}

/**
 * Level traded amount Get/Set.
 */
int levelAmount(string module, int op = GET, int value = 0)
{
    if (op == GET)
    {
        return(GlobalVariableGet(levelPrefix(module) + "Amount"));
    }
    else if (op == SET)
    {
        GlobalVariableSet(levelPrefix(module) + "Amount", value);
    }
    else if (op == DEL)
    {
        GlobalVariableDel(levelPrefix(module) + "Amount");
    }

    return(GlobalVariableGet(levelPrefix(module) + "Amount"));
}

/**
 * New level flag, used for roll back if no new order successfully get opened.
 */
bool levelFlagNew(string module, int op = GET, bool value = true)
{
    if (op == GET)
    {
        return(GlobalVariableGet(levelPrefix(module) + "FlagNew"));
    }
    else if (op == SET)
    {
        GlobalVariableSet(levelPrefix(module) + "FlagNew", value);
    }
    else if (op == DEL)
    {
        GlobalVariableDel(levelPrefix(module) + "FlagNew");
    }

    return(GlobalVariableGet(levelPrefix(module) + "FlagNew"));
}

/**
 * Level initiate flag, used for roll back if no new order successfully get opened for the initiate.
 */
bool levelFlagInitiate(string module, int op = GET, bool value = true)
{
    if (op == GET)
    {
        return(GlobalVariableGet(levelPrefix(module) + "FlagInitiate"));
    }
    else if (op == SET)
    {
        GlobalVariableSet(levelPrefix(module) + "FlagInitiate", value);
    }
    else if (op == DEL)
    {
        GlobalVariableDel(levelPrefix(module) + "FlagInitiate");
    }

    return(GlobalVariableGet(levelPrefix(module) + "FlagInitiate"));
}

/**
 * Save temporary level information for rolling back.
 */
void levelTemporarySave(string module)
{
    levelType(module + "|tmp", SET, levelType(module));
    levelPrice(module + "|tmp", SET, levelPrice(module));
    levelAmount(module + "|tmp", SET, levelAmount(module));
}

/**
 * Set new level.
 */
void levelNewSave(string module, int type, double price, int amount = 0, bool initiate = false)
{
    levelType(module, SET, type);
    levelPrice(module, SET, price);
    levelAmount(module, SET, amount);
    levelFlagNew(module, SET, true);
    if (initiate) levelFlagInitiate(module, SET, true);
    //Print("Another new " + module + " level");
}

/**
 * Level roll back.
 */
void levelRollback(string module)
{    
    if (levelFlagNew(module))
    {
        // Remove flag new.
        levelFlagNew(module, DEL);
        if (!levelFlagInitiate(module))
        {
            // Get information back from tmp.
            levelType(module, SET, levelType(module + "|tmp"));
            levelPrice(module, SET, levelPrice(module + "|tmp"));
            levelAmount(module, SET, levelAmount(module + "|tmp"));
        }
    }

    if (levelFlagInitiate(module))
    {
        levelFlagInitiate(module, DEL);
        levelReset(module);
    }
}

//---------- Level:End ----------//