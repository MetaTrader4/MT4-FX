
/**
 * Remove string values from an array by indexes and resort it.
 */
void array2DRemoveAndSortMultiString(string &arr[,], string arr_tmp[,], int indexes[])
{
    if (ArraySize(indexes) == 0) return;
    int i;
    int arr_size = ArrayRange(arr, 0);
    int arr_col_size = ArrayRange(arr, 1);
    Print(arr_col_size);
    int arr_tmp_size;
    ArrayResize(arr_tmp, 0);
    
    for (i = 0; i < arr_size; i++)
    {
        if (inArrayInt(i, indexes))
        {
            continue;
        }
        // Untouch value.
        arr_tmp_size = ArrayRange(arr_tmp, 0);
        ArrayResize(arr_tmp, arr_tmp_size + 1);
        ArrayCopy(arr_tmp, arr, arr_tmp_size * arr_col_size, i * arr_col_size, arr_col_size);
    }
    
    ArrayResize(arr, 0);
    arr_tmp_size = ArrayRange(arr_tmp, 0);
    for (i = 0; i < arr_tmp_size; i++)
    {
        arr_size = ArrayRange(arr, 0);
        ArrayResize(arr, arr_size + 1);
        ArrayCopy(arr, arr_tmp, arr_size * arr_col_size, i * arr_col_size, arr_col_size);
    }
}