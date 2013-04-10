

string arrayPrintSentence(string arr[], string separator = " ", string prefix = "", string suffix = ".", bool is_print = true)
{
    int size = ArraySize(arr);
    string content = "";
    for (int i = 0; i < size; i++)
    {
        if (i == 0)
        {
            content = StringConcatenate(prefix, arr[i]);
        }
        else
        {
            content = StringConcatenate(content, separator, arr[i]);
        }
    }
    content = StringConcatenate(content, suffix);
    
    if (is_print)
    {
        Print(content);
    }
    
    return(content);
}


string arrayPrintString(string arr[])
{
    int size = ArraySize(arr);
    int i;
    for (i = 0; i < size; i++)
    {
        Print(arr[i]);
    }
}