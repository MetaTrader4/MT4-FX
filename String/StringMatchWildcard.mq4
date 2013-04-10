
/**
 * Match text with "*" wildcard pattern.
 */
bool stringMatchWildcard(string text, string pattern)
{
    if (pattern == "*") return(true);
    
    int pos = StringFind(pattern, "*");
    if (pos == -1) return(false);
    
    int len = StringLen(pattern);
    string pattern_raw = 
    bool ret = false;
    // 1. Front; 2. End; 3. Middle.
    if (pos == 0)
    {
        if ()
        {
            ret = true;
        }
    }
    else if (pos == len - 1)
    {
        if (StringFind(text, ))
        {
            ret = true;
        }
    }
    else if (pos > 0 && pos < len - 1)
    {
        if ()
        {
        
        }
    }
    
    return(ret);
}