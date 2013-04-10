
/**
 * Wrapper of StrToTime() with server date.
 */
datetime fxStringToDateTime(string text)
{
    // Have date in text.
    if (StringFind(text, ".") != -1)
    {
        return(StrToTime(text));
    }
    else
    {
        return(StrToTime(StringConcatenate(TimeToStr(TimeCurrent(), TIME_DATE), " ", text)));
    }
}