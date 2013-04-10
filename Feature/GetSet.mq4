
#define GET 1
#define SET 2

double value(int op = GET)
{
    if (op == GET)
    {
    
    }
    else if (op == SET)
    {
    
    }
}


/**
 * Get the level settled value.
 */
double tcLevelSettled(int op = GET, double value = 0)
{
    if (op == GET)
    {
        return(GlobalVariableGet(tcPrefix() + "LevelSettled"));
    }
    else if (op == SET)
    {
        GlobalVariableSet(tcPrefix() + "LevelSettled", value);
        return(value);
    }
}