/**
 * Get the Digits of the Symbol.
 */
int marketDigits(string sym)
{
    return(MarketInfo(sym, MODE_DIGITS));
}