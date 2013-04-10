
/**
 * Implode array into string.
 */
string implodeString(string arr[], string separator = ", ")
{
    int size = ArraySize(arr);
    string text = "";
    int i;
    for (i = 0; i < size; i++)
    {
        if (i < size - 1)
        {
            text = StringConcatenate(text, arr[i], separator);
        }
        else
        {
            text = StringConcatenate(text, arr[i]);
        }
    }

    return(text);
}