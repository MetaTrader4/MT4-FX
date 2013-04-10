/*
PointStart->PointEnd
<: less than
>: bigger than
condiion_1>->condition_2
*/

/**
 * Prepare the interval condition for checking.
 */
void intervalPrepareCondition(string &condition_arr[], string condition)
{
    if (StringLen(condition) > 0)
    {
        // Assure it's clean.
        ArrayResize(condition_arr, 0);
        int separate = StringFind(condition, "->");
        if (separate != -1)
        {
            arrayPushString(condition_arr, StringSubstr(condition, 0, separate));
            arrayPushString(condition_arr, StringSubstr(condition, separate + 1));
        }
    }
}

bool intervalCheckDouble(double value, string condition)
{
    if (StringLen(condition) == 0)
    {
        return(TRUE);
    }
    string condition_arr[0];
    intervalPrepareCondition(condition_arr, condition);
    int condition_size = ArraySize(condition_arr);
    bool result = FALSE;
    switch (condition_size)
    {
        case 0:
            if (compareDouble(value, StrToDouble(condition)))
            {
                result = TRUE;
            }
            break;
        case 2:
            if ()
            {
                result = TRUE;
            }
            break;
    }
    
    return(result);
}

bool intervalCheckDatetime(datetime value, string condition)
{
    
}

bool intervalCheckInt(int value, string condition)
{
    
}