/*
Unshift: Add a value to the beginning
Push: Add a value to the end
Shift: Remove a value from the beginning
Pop: Remove a value from the end
RemoveAndSort: Remove a specific index and sort the array.
*/

/**
 * Add a int value to the end, return new size.
 */
int arrayPushInt(int &arr[], int val)
{
    int arr_size = ArraySize(arr);
    int arr_size_new = arr_size + 1;
    ArrayResize(arr, arr_size_new);
    arr[arr_size] = val;
    
    return(arr_size_new);
}

/**
 * Add a string value to the end, return new size.
 */
int arrayPushString(string &arr[], string val)
{
    int arr_size = ArraySize(arr);
    int arr_size_new = arr_size + 1;
    ArrayResize(arr, arr_size_new);
    arr[arr_size] = val;
    
    return(arr_size_new);
}

/**
 * Add a double value to the end, return new size.
 */
int arrayPushDouble(double &arr[], double val)
{
    int arr_size = ArraySize(arr);
    int arr_size_new = arr_size + 1;
    ArrayResize(arr, arr_size_new);
    arr[arr_size] = val;
    
    return(arr_size_new);
}


/**
 * Add a string value to the end.
 */
int arrayUnShiftString(string &arr[], string val)
{
    int arr_size = ArraySize(arr);
    string arr_tmp[0];
    ArrayResize(arr_tmp, arr_size);
    ArrayCopy(arr_tmp, arr);
    int arr_size_new = arr_size + 1;
    ArrayResize(arr, arr_size_new);
    arr[0] = val;
    ArrayCopy(arr, arr_tmp, 1, 0);
    
    return(arr_size_new);
}

/**
 * Remove a int value from an array by index and resort it.
 */
void arrayRemoveAndSortInt(int &arr[], int index)
{
    int i;
    int arr_size = ArraySize(arr);
    if (index >= arr_size) return;
    int arr_tmp[0], arr_tmp_size;
    ArrayResize(arr_tmp, 0);
    
    if (arr_size <= 1 && index == 0)
    {
        ArrayResize(arr, 0);
    }
    else
    {
        for(i = 0; i < arr_size; i++)
        {
            if(i == index)
            {
                continue;
            }
            arr_tmp_size = ArraySize(arr_tmp);
            ArrayResize(arr_tmp, arr_tmp_size+1);
            arr_tmp[arr_tmp_size] = arr[i];
        }
        ArrayInitialize(arr, 0);
        ArrayResize(arr, 0);
        arr_tmp_size = ArraySize(arr_tmp);
        for(i = 0; i < arr_tmp_size; i++)
        {
            arr_size = ArraySize(arr);
            ArrayResize(arr, arr_size + 1);
            arr[arr_size] = arr_tmp[i];
        }
    }
}

/**
 * Remove a int value from an array by index and resort it.
 */
void arrayRemoveAndSortDouble(double &arr[], int index)
{
    int i;
    int arr_size = ArraySize(arr);
    if (index >= arr_size) return;
    double arr_tmp[0];
    int arr_tmp_size;
    ArrayResize(arr_tmp, 0);
    
    if (arr_size <= 1 && index == 0)
    {
        ArrayResize(arr, 0);
    }
    else
    {
        for(i = 0; i < arr_size; i++)
        {
            if(i == index)
            {
                continue;
            }
            arr_tmp_size = ArraySize(arr_tmp);
            ArrayResize(arr_tmp, arr_tmp_size+1);
            arr_tmp[arr_tmp_size] = arr[i];
        }
        ArrayInitialize(arr, 0);
        ArrayResize(arr, 0);
        arr_tmp_size = ArraySize(arr_tmp);
        for(i = 0; i < arr_tmp_size; i++)
        {
            arr_size = ArraySize(arr);
            ArrayResize(arr, arr_size + 1);
            arr[arr_size] = arr_tmp[i];
        }
    }
}

/**
 * Remove a int value from an array by index and resort it. Return the array size.
 */
int arrayRemoveAndSortDouble(double &arr[], int index)
{
    int i;
    int arr_size = ArraySize(arr);
    if (index >= arr_size) return(arr_size);
    double arr_tmp[0];
    int arr_tmp_size;
    ArrayResize(arr_tmp, 0);
    
    if (arr_size <= 1 && index == 0)
    {
        ArrayResize(arr, 0);
    }
    else
    {
        for(i = 0; i < arr_size; i++)
        {
            if(i == index)
            {
                continue;
            }
            arr_tmp_size = ArraySize(arr_tmp);
            ArrayResize(arr_tmp, arr_tmp_size+1);
            arr_tmp[arr_tmp_size] = arr[i];
        }
        ArrayInitialize(arr, 0);
        ArrayResize(arr, 0);
        arr_tmp_size = ArraySize(arr_tmp);
        for(i = 0; i < arr_tmp_size; i++)
        {
            arr_size = ArraySize(arr);
            ArrayResize(arr, arr_size + 1);
            arr[arr_size] = arr_tmp[i];
        }
    }
    
    return(arr_tmp_size);
}

/**
 * Remove a int value from an array by index and resort it.
 */
void arrayRemoveAndSortString(string &arr[], int index)
{
    int i;
    int arr_size = ArraySize(arr);
    if (index >= arr_size) return;
    string arr_tmp[0]
    int arr_tmp_size;
    ArrayResize(arr_tmp, 0);
    
    if (arr_size <= 1 && index == 0)
    {
        ArrayResize(arr, 0);
    }
    else
    {
        for(i = 0; i < arr_size; i++)
        {
            if(i == index)
            {
                continue;
            }
            arr_tmp_size = ArraySize(arr_tmp);
            ArrayResize(arr_tmp, arr_tmp_size+1);
            arr_tmp[arr_tmp_size] = arr[i];
        }
        ArrayInitialize(arr, 0);
        ArrayResize(arr, 0);
        arr_tmp_size = ArraySize(arr_tmp);
        for(i = 0; i < arr_tmp_size; i++)
        {
            arr_size = ArraySize(arr);
            ArrayResize(arr, arr_size + 1);
            arr[arr_size] = arr_tmp[i];
        }
    }
}


/**
 * Remove int values from an array by indexes and resort it.
 */
void arrayRemoveAndSortMultiInt(int &arr[], int indexes[])
{
    if (ArraySize(indexes) == 0) return;
    int i;
    int arr_size = ArraySize(arr);
    int arr_tmp[0], arr_tmp_size;
    ArrayResize(arr_tmp, 0);

    for(i = 0; i < arr_size; i++)
    {
        if(inArrayInt(i, indexes))
        {
            continue;
        }
        arr_tmp_size = ArraySize(arr_tmp);
        ArrayResize(arr_tmp, arr_tmp_size+1);
        arr_tmp[arr_tmp_size] = arr[i];
    }
    ArrayInitialize(arr, 0);
    ArrayResize(arr, 0);
    arr_tmp_size = ArraySize(arr_tmp);
    for(i = 0; i < arr_tmp_size; i++)
    {
        arr_size = ArraySize(arr);
        ArrayResize(arr, arr_size + 1);
        arr[arr_size] = arr_tmp[i];
    }
}