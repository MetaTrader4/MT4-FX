extern string        Match_Symbol = "";               // Mathch the symbols to open blade orders. Coma separated, e.g. "EURUSD,USDJPY". Leave empty to unlimited.
extern string         Match_Magic = "";               // Like Match_Symbol.
extern string       Match_Comment = "";               // Like Match_Comment.


// FX order match
string match_symbol[0], match_comment[0];
int match_magic[0];

    // FX order match
    explodeToString(match_symbol, Match_Symbol);
    explodeToInt(match_comment, Match_Comment);
    explodeToString(match_magic, Match_Magic);


    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
        if (inArrayString(OrderSymbol(), match_symbol) != -1 && ArraySize(match_symbol) > 0) continue;
        if (inArrayInt(OrderMagicNumber(), match_magic) != -1 && ArraySize(match_magic) > 0) continue;
        if (inArrayString(OrderComment(), match_comment) != -1 && ArraySize(match_comment) > 0) continue;
        
    }