
/**
 * Check if number of bars go with the same type.
 */
bool candlesType(int op_type, int number)
{
    int i;
    bool ret = false;
    int count = 0;
    for (i = 0; i < number; i++)
    {
        if (op_type == OP_BUY)
        {
            if (Close[i] >= Open[i])
            {
                count++;
            }
        }
        else if (op_type == OP_SELL)
        {
            if (Close[i] <= Open[i])
            {
                count++;
            }
        }
    }
    
    if (count == number)
    {
        ret = true;
    }
    
    return(ret);
}