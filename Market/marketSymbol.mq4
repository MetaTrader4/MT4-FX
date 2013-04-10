

//---------- 1.x ----------//

/**
 * Check and validate the Symbol.
 */
void marketSymbol(string &sym)
{
    if (StringLen(sym) == 0)
    {
        sym = Symbol();
    }
}


//---------- 2.x ----------//

/**
 * Check and validate the Symbol.
 *
 * Use ordersym_prefix, ordersym_suffix to subtract the symbol text.
 */
void marketSymbol(string &sym, string ordersym_prefix = "", string ordersym_suffix = "")
{
    int len = StringLen(sym);
    if (len == 0)
    {
        sym = Symbol();
    }
    
    int len_fix = StringLen(ordersym_prefix);
    if (len_fix > 0)
    {
        sym = StringSubstr(sym, len_fix);
    }
    
    len = StringLen(sym);
    len_fix = StringLen(ordersym_suffix);
    if (len_fix > 0)
    {
        sym = StringSubstr(sym, 0, len - len_fix);
    }
}


//---------- 3.x ----------//
// Module: FX_Market_Symbol.
// Prepare for what.
#define SYMBOL_MARKET 0
#define SYMBOL_ORDER 1
#define SYMBOL_MARKET_ORDER 2
#define SYMBOL_ORDER_MARKET 3

/**
 * Check and validate the Symbol.
 *
 * Use ordersym_prefix, ordersym_suffix to subtract the symbol text.
 */
string marketSymbol(string sym = "", int mode = SYMBOL_MARKET)
{
    if (StringLen(sym) == 0)
    {
        sym = Symbol();
    }
    
    // Hook: hook_market_symbol_post_process().
    hook_market_symbol_post_process(sym, mode);
    
    return(sym);
}

/**
 * Implements hook_market_symbol_post_process().
 */
void hook_market_symbol_post_process(string &sym, int mode)
{
}


//---------- 3.x with Module: Broker Compatity ----------//

// Module: FX_Market_Symbol.
// Prepare for what.
#define SYMBOL_MARKET 0
#define SYMBOL_ORDER 1
#define SYMBOL_MARKET_ORDER 2
#define SYMBOL_ORDER_MARKET 3


// Broker Compatible
extern string Broker_Compatible = "--- Broker Compatible ---";
//extern bool            AutoPips = true;                        // Pips related settings are auto fitted. Deal with 4/5 digits compatible automatically. If false, every pips value will set as points. Turn it off if not trade on forex symbol.
//extern bool           ECNBroker = true;                       // Whether using ECN broker, for the limitation which not allow setting tp/sl when open an order.
extern string      SymbolPrefix = "";                          // Prefix to the symbol for the opening order if differ from the chart name on the trading server.
extern string      SymbolSuffix = "";                          // Suffix to the symbol for the opening order if differ from the chart name on the trading server.


/**
 * Check and validate the Symbol.
 *
 * Use ordersym_prefix, ordersym_suffix to subtract the symbol text.
 */
string marketSymbol(string sym = "", int mode = SYMBOL_MARKET, string prefix = "", string suffix = "")
{
    string sym_source = sym;
    
    if (StringLen(sym) == 0)
    {
        sym = Symbol();
    }
    
    // Hook: hook_market_symbol_post_process().
    hook_market_symbol_post_process(sym, mode, sym_source, prefix, suffix);
    
    return(sym);
}

/**
 * Implements hook_market_symbol_post_process().
 */
void hook_market_symbol_post_process(string &sym, int mode, string sym_source, string prefix, string suffix)
{
    // Module: Broker Compatity.
    // marketSymbol("", SYMBOL_MARKET_ORDER);
    // marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int len_prefix = StringLen(prefix);
    int len_suffix = StringLen(suffix);
    int len_fix = len_prefix + len_suffix;
    // No fix setting.
    if (len_fix == 0) return;
    
    int len = StringLen(sym);
    int len_source = StringLen(sym_source);
    int len_chart = StringLen(Symbol());
    
    switch (mode)
    {
        case SYMBOL_MARKET:
            // If it's "" or match chart.
            if (len_source == 0 || len_source == len_chart)
            {
                break;
            }
        // Delegate to SYMBOL_ORDER_MARKET.
        case SYMBOL_ORDER_MARKET:
            if (len_prefix > 0)
            {
                sym = StringSubstr(sym, len_prefix);
            }
            if (len_suffix > 0)
            {
                sym = StringSubstr(sym, 0, StringLen(sym) - len_suffix);
            }
            break;
        case SYMBOL_ORDER:
            // If it is already a Symbol for Order.
            if (len_source > 0 && len_source > len_chart)
            {
                break;
            }
        case SYMBOL_MARKET_ORDER:
            sym = StringConcatenate(prefix, sym, suffix);
            break;
        
    }
}

