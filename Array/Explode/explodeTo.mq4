/**
 * Explode string into integer array.
 */
int explodeToInt(int &arr[], string text_arr, string separator = ",")
{
    int start = 0, length, array_size;
    bool eos = false;
    ArrayResize(arr, 0);
    
    while (eos == false)
    {
        length = StringFind(text_arr, separator, start) - start;
        if (length < 0)
        {
           // Avoid empty string.
           if (StringLen(text_arr) == 0)
           {
              return(ArraySize(arr));
           }
           eos = true;
           length = StringLen(text_arr) - start;
        }
      
        array_size = ArraySize(arr);
        ArrayResize(arr, array_size + 1);
        arr[array_size] = StrToInteger(StringSubstr(text_arr, start, length));
        start += length + 1;
    }
    
    return(ArraySize(arr));
}

/**
 * Explode string into string array.
 */
int explodeToString(string &arr[], string text_arr, string separator = ",")
{
    int start = 0, length, array_size;
    bool eos = false;
    ArrayResize(arr, 0);
    
    while (eos == false)
    {
        length = StringFind(text_arr, separator, start) - start;
        if (length < 0)
        {
           // Avoid empty string.
           if (StringLen(text_arr) == 0)
           {
              return(ArraySize(arr));
           }
           eos = true;
           length = StringLen(text_arr) - start;
        }
      
        array_size = ArraySize(arr);
        ArrayResize(arr, array_size + 1);
        arr[array_size] = StringSubstr(text_arr, start, length);
        start += length + 1;
    }
    
    return(ArraySize(arr));
}

/**
 * Explode string into double array.
 */
int explodeToDouble(double &arr[], string text_arr, string separator = ",")
{
    int start = 0, length, array_size;
    bool eos = false;
    ArrayResize(arr, 0);
    
    while (eos == false)
    {
        length = StringFind(text_arr, separator, start) - start;
        if (length < 0)
        {
           // Avoid empty string.
           if (StringLen(text_arr) == 0)
           {
              return(ArraySize(arr));
           }
           eos = true;
           length = StringLen(text_arr) - start;
        }
      
        array_size = ArraySize(arr);
        ArrayResize(arr, array_size + 1);
        arr[array_size] = StrToDouble(StringSubstr(text_arr, start, length));
        start += length + 1;
    }
    
    return(ArraySize(arr));
}
  
/**
 * Explode string into datetime array.
 */
int explodeToDateTime(datetime &arr[], string text_arr, string separator = ",")
{
    int    start = 0, length, array_size;
    bool   eos = false;
    string time_text;
    
    ArrayResize(arr, 0);
    
    while (eos == false)
    {
        length = StringFind(text_arr, separator, start) - start;
        if (length < 0)
        {
           // Avoid empty string.
           if (StringLen(text_arr) == 0)
           {
              return;
           }
           eos = true;
           length = StringLen(text_arr) - start;
        }
      
        array_size = ArraySize(arr);
        ArrayResize(arr, array_size + 1);
        time_text = StringSubstr(text_arr, start, length);
        if (StringLen(time_text) < 18)
        {
            time_text = StringConcatenate(TimeToStr(TimeCurrent(), TIME_DATE), " ", time_text);
        }
        arr[array_size] = StrToTime(time_text);
        start += length + 1;
    }
    
    return(ArraySize(arr));
}

/**
 * Explode string into market points array.
 */
int explodeToPoints(double &arr[], string text_arr, string separator = ",")
{
    int start = 0, length, array_size;
    bool eos = false;
    ArrayResize(arr, 0);
    
    while (eos == false)
    {
        length = StringFind(text_arr, separator, start) - start;
        if (length < 0)
        {
           // Avoid empty string.
           if (StringLen(text_arr) == 0)
           {
              return(ArraySize(arr));
           }
           eos = true;
           length = StringLen(text_arr) - start;
        }
      
        array_size = ArraySize(arr);
        ArrayResize(arr, array_size + 1);
        arr[array_size] = marketPipsToPoints(Symbol(), StrToDouble(StringSubstr(text_arr, start, length)));
        start += length + 1;
    }
    
    return(ArraySize(arr));
}