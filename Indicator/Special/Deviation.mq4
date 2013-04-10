

/**
 * Indiator: Value + Deviation.
 */
double devValue(double value, double dev, int step)
{
    return(value * (1 + dev / 100 * step));
}



/**
 * Indiator: iMA() + Deviation.
 */
double maDevValue(double value, double dev, int step)
{
    return(value * (1 + dev / 100 * step));
}