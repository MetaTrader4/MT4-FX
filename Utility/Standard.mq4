/**
 * Better solution to compare two double values.
 */
bool compareDouble(double value_1, double value_2, int precision = 8)
{
    if (NormalizeDouble(value_1 - value_2, precision) == 0)
    {
        return(TRUE);
    }
    else
    {
        return(FALSE);
    }
}


/**
 * Better solution to compare two double values.
 */
int compareDouble(double value_1, double value_2, int precision = 8)
{
    double result = NormalizeDouble(value_1 - value_2, precision);
    if (result > 0)
    {
        return(1);
    }
    else if (result < 0)
    {
        return(-1);
    }
    
    return(0);
}

