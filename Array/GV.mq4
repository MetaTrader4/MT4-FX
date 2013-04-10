
/**
 * Get Global Variables into an array.
 */
void arrayGVGet(string name, double &arr[])
{
    int i;
    int size = ArraySize(arr);
    for (i = 0; i < size; i++)
    {
        arr[i] = GlobalVariableGet(name + "_" + i);
    }
}

/**
 * Save an array as Global Variables.
 */
void arrayGVSet(string name, double arr[])
{
    int i;
    int size = ArraySize(arr);
    for (i = 0; i < size; i++)
    {
        GlobalVariableSet(name + "_" + i, arr[i]);
    }
}


