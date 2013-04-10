


string arrayPrintValueDouble(double arr[], string name = "", bool print_content = true)
{
    int size = ArraySize(arr);
    int i;
    string content = name + "{";
    if (size == 0) content = StringConcatenate(content, "}");
    
    for (i = 0; i < size; i++)
    {
        if (i == size - 1)
        {
            content = StringConcatenate(content, "\"" + arr[i] + "\"}");
        }
        else
        {
            content = StringConcatenate(content, "\"" + arr[i] + "\", ");
        }
    }
    
    if (print_content)
    {
        Print(content);
    }
    
    return(content);
}