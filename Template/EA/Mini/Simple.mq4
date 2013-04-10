/**
 * MT4/MT5 Custom Programming, Contact Me At: kolier.li@gmail.com
 */


//---------- Property ----------//
#property copyright "Copyright 2012, [Client] & Kolier Li."
#property link      "http://kolier.li"
// Author: Kolier Li (http://kolier.li)
// Client: 
// Tags:


//---------- Change Log ----------//
/*
1.0 (2012-) Initiate version.

*/


//---------- User Input ----------//
extern string  AdvisorInformation = "--- Information ---";
extern string         AdvisorName = "EA"; // For Logging.
extern string      AdvisorVersion = "1.0";                 // The version number of this script.

// Entry & Exit
extern string       Entry_Exit = "--- Entry & Exit ---";
extern bool    Entry_AtBarOpen = true;                   // Whether to wait for new bar to confirm the signal for entry.
extern bool Exit_CloseOpposite = false;                  // Whether close opposite orders when new signal comes out.
extern bool     Exit_AtBarOpen = true;                   // Whether to wait for new bar to confirm the signal for exit. 
// Order Operation
extern string Order_Operation = "--- Order Operation ---";
extern int              Magic = 222222;                    // For identify trades belong to this EA, set to unique on different chart when using at the same time.
extern int           Slippage = 3;                         // Allow slippage.
extern double            Lots = 0.1;                       // Fixed trade lots without using MoneyManagement.
extern double      TakeProfit = 0;                         // In Pips. Take Profit, Change to 0 if you don't want to use.
extern double        StopLoss = 0;                         // In Pips. Stop Loss, Change to 0 if you don't want to use.
// Indicator
extern string Indicator_Setting = "--- Indicator Setting ---";
extern bool     CalculateOnOpen = false;                       // Only calculate indicator value on bar open, will boost the speed for backtest.

// Broker Compatible
extern string Broker_Compatible = "--- Broker Compatible ---";
extern bool            AutoPips = true;                        // Pips related settings are auto fitted. Deal with 4/5 digits compatible automatically. If false, every pips value will set as points. Turn it off if not trade on forex symbol.
extern bool           ECNBroker = true;                        // Whether using ECN broker, for the limitation which not allow setting tp/sl when open an order.
extern string      SymbolPrefix = "";                          // Prefix to the symbol for the opening order if differ from the chart name on the trading server.
extern string      SymbolSuffix = "";                          // Suffix to the symbol for the opening order if differ from the chart name on the trading server.


//---------- Global Constant ----------//
// Module: FX_Market_Symbol.
#define SYMBOL_MARKET 0
#define SYMBOL_ORDER 1
#define SYMBOL_MARKET_ORDER 2
#define SYMBOL_ORDER_MARKET 3
// Extension of OP_*
#define FXOP_TOTAL 100 // type_space
#define FXOP_ALL 110
#define FXOP_OPENING 120
#define FXOP_HISTORY 125
#define FXOP_MARKET 130
#define FXOP_PEND 140
#define FXOP_STOP 150
#define FXOP_LIMIT 155
// deprecated.
#define FXOP_PEND_BUY 145
#define FXOP_PEND_SELL 146
// Price mode.
#define PRICE_PRICE 0
#define PRICE_PIPS 5
#define PRICE_POINTS 10
#define PRICE_PERCENT 20
// Profit type.
#define PROFIT_ALL 100
#define PROFIT_EVEN 0
#define PROFIT_POSITIVE 1
#define PROFIT_NEGATIVE -1
//
#define PROFIT_PRICE 5
#define PROFIT_PIPS 10
//
#define PIPS_INPUT 0
#define PIPS_PRICE 1
#define POINTS_INPUT 10
#define POINTS_PRICE 11


//---------- Global Variable ----------//
int days[0], days_size = 0;
int bar = 0, bar_e = 0;
// Module: Multiple Phase.
string phase[0];
int phase_size = 0;
int order_jar_ea[0], order_jar_ph[0];
int order_jar_ea_size = 0, order_jar_ph_size = 0;
// Module: Order Queue.
int order_queue_entry_junk[0], order_queue_exit[0], order_queue_exit_junk[0];
string order_queue_entry[0,12];
// EA

// EA_Indicator
datetime time_calc = 0;

/**
 * Event: Initiate.
 */
int init()
{
    Comment(AdvisorName, "-", AdvisorVersion);

    if(Entry_AtBarOpen) {
        bar = 1;
    }
    if(Exit_AtBarOpen) {
        bar_e = 1;
    }
    
    // Initiate the phases.
    phase_size = explodeToInt(ord, Order_Type);
    // e.g.
    //explodeToInt(zz_hi, ZZ_HighType);
    //explodeToInt(zz_lo, ZZ_LowType);
    //explodeToInt(zz_bar, ZZ_Bar);
    
    int i;
    for (i = 0; i < phase_size; i++)
    {
        //phaseRegister(phaseTextFromPattern("peak", zz_hi[i])+"_"+phaseTextFromPattern("through", zz_lo[i]));
    }
    

    return(0);
}

/**
 * Event: Deinitiate.
 */
int deinit()
{
    // Clear the un-used Global Variables
    stealthModeClear();

    return(0);
}


//---------- Event_Start:Start ----------//

/**
 * Event: Start.
 */
int start()
{
    // Hook: hook_pre_start().
    hook_pre_start();
    
    for (int i = 0; i < phase_size; i++)
    {
        // Hook: hook_pre_trading().
        hook_pre_trading(i);
        
        if (
            // Hook: hook_trading_condition().
            hook_trading_condition(i)
        )
        {
            // Hook: hook_trading_pre_process().
            hook_trading_pre_process(i);
        
            // Hook: hook_trading_process().
            hook_trading_process(i);
            
            // Hook: hook_trading_post_process().
            hook_trading_post_process(i);
        }

        // Hook: hook_post_trading().
        hook_post_trading(i);
    }
    
    // Hook: hook_post_start().
    hook_post_start();
}

/**
 * Implements hook_pre_start().
 */
void hook_pre_start()
{
    int order_type[4] = {FXOP_OPENING, FXOP_ALL, FXOP_ALL, FXOP_ALL};
    order_jar_ea_size = fxOrderFind(order_jar_ea, order_type, PROFIT_ALL, Symbol(), Magic);
    
    // Indicator Prepare.
    if (!CalculateOnOpen || (CalculateOnOpen && time_calc < Time[0]))
    {
        time_calc = Time[0];
        indicatorPrepare();
    }
}

/**
 * Implements hook_pre_trading().
 */
void hook_pre_trading(int ph)
{
    int order_type[4] = {FXOP_OPENING, FXOP_ALL, FXOP_ALL, FXOP_ALL};
    order_jar_ph_size = fxOrderFind(order_jar_ph, order_type, PROFIT_ALL, Symbol(), Magic, phase[ph]);
}

/**
 * Implements hook_trading_condition().
 */
bool hook_trading_condition(int ph)
{
    if (
        // Add filter.
        // true &&
        true
    )
    {
        return(true);
    }
    
    return(false);
}

/**
 * Implements hook_trading_pre_process().
 */
void hook_trading_pre_process(int ph)
{
    if (ArrayRange(order_queue_entry, 0) > 0 || ArraySize(order_queue_exit) > 0) return;
    
    // e.g.
    /*
    string peak = patternFromPhase(phase[ph], "peak");
    string through = patternFromPhase(phase[ph], "through");
    
    if (
        order_jar_ph_size == 0
        && (peak == "All" || peak == zzp)
        && (through == "All" || through == zzt)
        && zz_bar[ph] == zzb
    )
    {
        if (ord[ph] == OP_BUY) fxOrderImportEntryQueue(order_queue_entry, OP_BUY);
        if (ord[ph] == OP_SELL) fxOrderImportEntryQueue(order_queue_entry, OP_SELL);
    }
    */
}

/**
 * Implements hook_trading_process().
 */
void hook_trading_process(int ph)
{
    int i, size, ticket;
    // Variables of order metadata.
    int cmd, po_mode, ptp_mode, psl_mode, slippage, magic, expire, col;
    double po, lots, ptp, psl;
    string sym, cmt;
    // OrderSend order_queue_entry.
    size = ArrayRange(order_queue_entry, 0);
    for (i = 0; i < size; i++)
    {
        fxOrderExportEntryQueue(order_queue_entry, i, cmd, po, po_mode, lots, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        ticket = fxOrderOpen(cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        if (ticket > 0 || (ticket < 0 && GetLastError() != 146))
        {
            // Order queue process sucessfully, add to junk.
            arrayPushInt(order_queue_entry_junk, i);
        }
    }
    
    // OrderClose order_queue_exit.
    size = ArraySize(order_queue_exit);
    for (i = 0; i < size; i++)
    {
        bool result = fxOrderClose(order_queue_exit[i]);
        if (result || (!result && GetLastError() == 4108))
        {
            // Order queue process sucessfully, add to junk.
            arrayPushInt(order_queue_exit_junk, i);
        }
    }
}

/**
 * Implements hook_trading_post_process().
 */
void hook_trading_post_process(int ph)
{
    
}

/**
 * Implements hook_post_trading().
 */
void hook_post_trading(int ph)
{
    // Deal order_queue_entry with order_queue_entry_junk.
    string order_queue_entry_tmp[,12];
    array2DRemoveAndSortMultiString(order_queue_entry, order_queue_entry_tmp, order_queue_entry_junk);
    ArrayResize(order_queue_entry_junk, 0);
    
    // Deal order_queue_exit with order_queue_exit_junk.
    arrayRemoveAndSortMultiInt(order_queue_exit, order_queue_exit_junk);
    ArrayResize(order_queue_exit_junk, 0);
}

/**
 * Implements hook_post_start().
 */
void hook_post_start()
{
    /*
    int i, size;
    size = ArraySize(order_jar_ea);
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar_ea[i], SELECT_BY_TICKET))
        {
            breakEven(order_jar_ea[i]);
            trailStop(order_jar_ea[i]);
            stealthMode(order_jar_ea[i]);
        }
    }
    */
    
    // Clear junk.
    //stealthModeClear();
}

//---------- Event_Start:End ----------//


//---------- Module:Start ----------//

/**
 * Prepare indicator data.
 */
void indicatorPrepare()
{
}

/**
 * Module: Multiple Phase.
 */
int phaseRegister(string phase_new)
{
    return(arrayPushString(phase, phase_new));
}

/**
 * Create a new order queue.
 */
void fxOrderImportEntryQueue(string &order_queue[,], int cmd, string cmt = "",
    double po = 0, int po_mode = PRICE_PRICE, double lots = 0,
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE,
    int slippage = 3, string sym = "",
    int magic = 0, datetime expire = 0, color col = CLR_NONE)
{
    int size = ArrayRange(order_queue, 0);
    ArrayResize(order_queue, size + 1);
    sym = marketSymbol(sym, SYMBOL_ORDER);
    int digi = marketDigits(sym);
    order_queue[size][0] = cmd;
    order_queue[size][1] = DoubleToStr(po, digi);
    order_queue[size][2] = po_mode;
    order_queue[size][3] = DoubleToStr(lots, marketLotsPrecision(sym));
    order_queue[size][4] = DoubleToStr(ptp, digi);
    order_queue[size][5] = ptp_mode;
    order_queue[size][6] = DoubleToStr(psl, digi);
    order_queue[size][7] = psl_mode;
    order_queue[size][8] = slippage;
    order_queue[size][9] = sym;
    order_queue[size][10] = magic;
    order_queue[size][11] = cmt;
    order_queue[size][12] = expire;
    order_queue[size][13] = col;
}

/**
 * Prepare the order open metadata.
 */
void fxOrderExportEntryQueue(string order_queue[,], int index, int &cmd,
    double &po, int &po_mode, double &lots,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode, int &slippage, string &sym,
    int &magic, string &cmt, datetime &expire, color &col)
{
    cmd = StrToInteger(order_queue[index][0]);
    po = StrToDouble(order_queue[index][1]);
    po_mode = StrToInteger(order_queue[index][2]);
    lots = StrToDouble(order_queue[index][3]);
    ptp = StrToDouble(order_queue[index][4]);
    ptp_mode = StrToInteger(order_queue[index][5]);
    psl = StrToDouble(order_queue[index][6]);
    psl_mode = StrToInteger(order_queue[index][7]);
    slippage = StrToInteger(order_queue[index][8]);
    sym = order_queue[index][9];
    magic = StrToInteger(order_queue[index][10]);
    cmt = "" + order_queue[index][11];
    expire = StrToInteger(order_queue[index][12]);
    col = StrToInteger(order_queue[index][13]);
}

//---------- Module:End ----------//


//---------- FX:Start ----------//


//---------- FX_Array:Start ----------//

/**
 * Add a int value to the end, return new size.
 */
int arrayPushInt(int &arr[], int val)
{
    int arr_size = ArraySize(arr);
    int arr_size_new = arr_size + 1;
    ArrayResize(arr, arr_size_new);
    arr[arr_size] = val;
    
    return(arr_size_new);
}

/**
 * Add a string value to the end, return new size.
 */
int arrayPushString(string &arr[], string val)
{
    int arr_size = ArraySize(arr);
    int arr_size_new = arr_size + 1;
    ArrayResize(arr, arr_size_new);
    arr[arr_size] = val;
    
    return(arr_size_new);
}

/**
 * Remove int values from an array by indexes and resort it.
 */
void arrayRemoveAndSortMultiInt(int &arr[], int indexes[])
{
    if (ArraySize(indexes) == 0) return;
    int i;
    int arr_size = ArraySize(arr);
    int arr_tmp[0], arr_tmp_size;
    ArrayResize(arr_tmp, 0);

    for(i = 0; i < arr_size; i++)
    {
        if(inArrayInt(i, indexes))
        {
            continue;
        }
        arr_tmp_size = ArraySize(arr_tmp);
        ArrayResize(arr_tmp, arr_tmp_size+1);
        arr_tmp[arr_tmp_size] = arr[i];
    }
    ArrayInitialize(arr, 0);
    ArrayResize(arr, 0);
    arr_tmp_size = ArraySize(arr_tmp);
    for(i = 0; i < arr_tmp_size; i++)
    {
        arr_size = ArraySize(arr);
        ArrayResize(arr, arr_size + 1);
        arr[arr_size] = arr_tmp[i];
    }
}

/**
 * Remove string values from an array by indexes and resort it.
 */
void array2DRemoveAndSortMultiString(string &arr[,], string arr_tmp[,], int indexes[])
{
    if (ArraySize(indexes) == 0) return;
    int i;
    int arr_size = ArrayRange(arr, 0);
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
        ArrayCopy(arr_tmp, arr, arr_tmp_size, i, 1);
    }
    
    ArrayResize(arr, 0);
    arr_tmp_size = ArrayRange(arr_tmp, 0);
    for (i = 0; i < arr_tmp_size; i++)
    {
        arr_size = ArrayRange(arr, 0);
        ArrayResize(arr, arr_size + 1);
        ArrayCopy(arr, arr_tmp, arr_size, i, 1);
    }
}

/**
 * Check if an integer value in the array.
 */
bool inArrayInt(int val, int arr[], int total = 0)
{
   int arr_size = ArraySize(arr);
   if (total > 0 && total > arr_size)
   {
      arr_size = total;
   }
   for (int i=0; i < arr_size; i++)
   {
      if (arr[i] == val)
      {
         return(true);
      }
   }

   return(false);
}

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
              return;
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

//---------- FX_Array:End ----------//


//---------- FX_Market:Start ----------//

/**
 * Check and validate the Symbol.
 *
 * Use ordersym_prefix, ordersym_suffix to subtract the symbol text.
 */
string marketSymbol(string sym = "", int mode = SYMBOL_MARKET)
{
    string sym_source = sym;
    
    if (StringLen(sym) == 0)
    {
        sym = Symbol();
    }
    
    // Hook: hook_market_symbol_post_process().
    hook_market_symbol_post_process(sym, mode, sym_source);
    
    return(sym);
}

/**
 * Implements hook_market_symbol_post_process().
 */
void hook_market_symbol_post_process(string &sym, int mode, string sym_source)
{
    // Module: Broker Compatity.
    // marketSymbol("", SYMBOL_MARKET_ORDER);
    // marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
    int len_prefix = StringLen(SymbolPrefix);
    int len_suffix = StringLen(SymbolSuffix);
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
            sym = StringConcatenate(SymbolPrefix, sym, SymbolSuffix);
            break;
        
    }
}

/**
 * Get the Digits of the Symbol.
 */
int marketDigits(string sym)
{
    return(MarketInfo(sym, MODE_DIGITS));
}

/**
 * Get the lots precision.
 */
int marketLotsPrecision(string sym)
{
    double lots_step = MarketInfo(sym, MODE_LOTSTEP);
    int lots_precision = 0;
    
    if (lots_step == 0.1)
    {
        lots_precision = 1;
    }
    if (lots_step == 0.01)
    {
        lots_precision = 2;
    }
    
    return(lots_precision);
}

/**
 * Get market price.
 *
 * Return close price of the current by default.
 *
 * @param string sym(Optional) Chart symbol.
 * @param int tf(Optional) TimeFrame.
 * @param int type(Optional) Price type. PRICE_OPEN, PRICE_HIGH, PRICE_LOW, PRICE_CLOSE, MODE_BID, MODE_ASK.
 * @param int index(Optional) Index of price series array.
 * @return double price The getting price.
 */
double marketPrice(string sym = "", int tf = 0, int type = PRICE_CLOSE, int shift = 0)
{
    marketSymbol(sym);
    double price;
    switch (type)
    {
        case PRICE_OPEN:
            price = iOpen(sym, tf, shift);
            break;
        case PRICE_HIGH:
            price = iHigh(sym, tf, shift);
            break;
        case PRICE_LOW:
            price = iLow(sym, tf, shift);
            break;
        case PRICE_CLOSE:
            price = iClose(sym, tf, shift);
            break;
        case MODE_ASK:
            price = MarketInfo(sym, MODE_ASK);
            break;
        case MODE_BID:
            price = MarketInfo(sym, MODE_BID);
            break;
    }
    
    return(price);
}

/**
 * Turn pips to platform specific points.
 *
 * Intend to auto fit 4/5 digits platoform and for forex symbols only.
 * Usuall add a AutoPips check to hook_pre_market_pips_points as a switch.
 */
double marketPipsToPoints(string sym, double pips, int input = PIPS_INPUT, bool output = PIPS_PRICE)
{
    double points;
    sym = marketSymbol(sym, SYMBOL_MARKET);
    int factor = marketPipsFactor(sym);
    points = pips * factor;
    int digits = marketDigits(sym);
    
    // Return price format.
    if (input == PIPS_INPUT && output == PIPS_PRICE)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }
    // Return input format.
    if (input == PIPS_PRICE && output == PIPS_INPUT)
    {
        points *= MathPow(10, digits);
    }

    return(points);
}

double marketPointsToPips(string sym, double points, int input = POINTS_INPUT, bool output = POINTS_PRICE)
{
    double pips;
    sym = marketSymbol(sym, SYMBOL_MARKET);
    int factor = marketPipsFactor(sym);
    pips = points / factor;
    int digits = marketDigits(sym);
    
    if (input == POINTS_INPUT && output == POINTS_PRICE)
    {
        pips *= MarketInfo(sym, MODE_POINT);
    }
    if (input == POINTS_PRICE && output == POINTS_INPUT)
    {
        pips *= MathPow(10, digits);
    }

    return(pips);
}

int marketPipsFactor(string sym = "")
{
    sym = marketSymbol(sym, SYMBOL_MARKET);
    int factor;
    int digits = MarketInfo(sym, MODE_DIGITS);
    double price = MarketInfo(sym, MODE_BID);
    
    if (price < 10)
    {
        factor = MathPow(10, digits - 4);
    }
    else if (price > 10)
    {
        factor = MathPow(10, digits - 2);  
    }
    
    return(factor);
}

/**
 * Get a PipValue.
 */
double marketPipValue(string sym = "", int pips = 1, double lots = 1)
{
    sym = marketSymbol(sym);
    
    return(MarketInfo(sym, MODE_TICKVALUE) * marketPipsFactor(sym) * pips * lots);
}

//---------- FX_Market:End ----------//


//---------- FX_Order:Start ----------//

/**
 * A wrapper function for OrderSend().
 * 
 * @param int cmd(Optional) OrderSend command: OP_BUY, OP_SELL, OP_BUYLIMIT, OP_BUYSTOP, OP_SELLLIMIT, OP_SELLSTOP and extension.
 * @param double po(Optional) Order open price.
 * @param int po_mode(Optional) Detect what kind of po it is. PRICE_PRICE, PIPS_PIPS, PIPS_POINTS.
 * @param double lots(Optional) Order trading volume.
 * @param double ptp(Optional) Order TakeProfit.
 * @param int ptp_mode(Optional) Detect what kind of ptp it is. PRICE_PRICE, PIPS_PIPS, PIPS_POINTS.
 * @param double psl(Optional) Order StopLoss.
 * @param int psl_mode(Optional) Detect what kind of psl it is. PRICE_PRICE, PIPS_PIPS, PIPS_POINTS.
 * @param int slippage(Optional) Allow trading slippage.
 * @param string sym(Optional) Trading symbol, current chart by default.
 * @param int magic(Optional) MagicNumber identifier for the order.
 * @param string cmt(Optional) Comment attached to the order.
 * @param datetime expire(Optional) The expiration datetime for pending order to delete.
 * @param color col(Optional) On chart mark for this order.
 *
 * @return ticket Ticket number if successful, -1 if not fail.
 */
int fxOrderOpen(int cmd = FXOP_ALL, double lots = 0, double po = 0, int po_mode = PRICE_PRICE,
    double ptp = 0, int ptp_mode = PRICE_PRICE, double psl = 0, int psl_mode = PRICE_PRICE,
    int slippage = 3, string sym = "", int magic = 0, string cmt = "",
    datetime expire = 0, color col = CLR_NONE)
{
    // Prepare the symbol.
    sym = marketSymbol(sym, SYMBOL_ORDER);
    
    // If it isn't market order and without setting po, return -1 and log error.
    // @todo handle error.
    fxOrderPriceOpen(sym, cmd, po, po_mode);
    if (po <= 0)
    {
        return(-1);
    }

    // Hook: hook_pre_order_open().
    hook_order_pre_open(sym, cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, cmt, magic, expire, col);
    
    // Hook: hook_order_open().
    int ticket = hook_order_open(sym, cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, cmt, magic, expire, col);
    
    // Hook: hook_post_order_open().
    hook_order_post_open(ticket, sym, cmd, lots, po, po_mode, ptp, ptp_mode, psl, psl_mode, slippage, cmt, magic, expire, col);
    
    return(ticket);
}

/**
 * Implements hook_order_pre_open().
 */
void hook_order_pre_open(string &sym, int &cmd, double &lots, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode, int &slippage,
    string &cmt, int &magic, datetime &expire, color &col)
{
    // If no cmd, give a random one. :D
    if (cmd == FXOP_ALL)
    {
        if (MathMod(MathRand(), 2) == 0)
        {
            cmd = OP_BUY;
        }
        else
        {
            cmd = OP_SELL;
        }
    }
    // Module: User_Order_Operation. Override with the user input.
    sym = StringConcatenate(SymbolPrefix, sym, SymbolSuffix);
    if (magic == 0)
    {
        magic = Magic;
    }
    slippage = Slippage;
    if (lots == 0)
    {
        lots = Lots;
        if (MM_On)
        {
            lots = mmLots(sym);
        }
    }
    if (
        (ptp <= 0 && TakeProfit > 0)
    )
    {
        ptp = TakeProfit;
        ptp_mode = PRICE_PIPS;
    }
    if (
        (psl <= 0 && StopLoss > 0)
    )
    {
        psl = StopLoss;
        psl_mode = PRICE_PIPS;
    }
}

/**
 * Implements hook_order_open().
 */
int hook_order_open(string &sym, int &cmd, double &lots,
    double &po, int &po_mode, double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    int &slippage, string &cmt, int &magic, datetime &expire, color &col)
{
    // Module: ECNBroker.
    if (ECNBroker && cmd <= 1)
    {
        double ptp_tmp = ptp;
        double psl_tmp = psl;
        ptp = 0;
        psl = 0;
    }
    else
    {
        fxOrderPriceTakeProfit(sym, cmd, po, ptp, ptp_mode);
        fxOrderPriceStopLoss(sym, cmd, po, psl, psl_mode);
    }
    
    int ticket;
    ticket = OrderSend(sym, cmd, lots, po, slippage, psl, ptp, cmt, magic, expire, col);
    
    // Module: ECNBroker.
    if (ECNBroker && cmd <= 1)
    {
        ptp = ptp_tmp;
        psl = psl_tmp;
    }
    
    return(ticket);
}

/**
 * Implements hook_order_post_open().
 */
void hook_order_post_open(int ticket, string sym, int cmd, double lots,
    double po, int po_mode, double ptp, int ptp_mode, double psl, int psl_mode,
    int slippage, string cmt, int magic, datetime expire, color col)
{
    if (ticket > 0)
    {
        // Module: ECNBroker.
        if (ECNBroker && cmd <= 1)
        {
            OrderSelect(ticket, SELECT_BY_TICKET);
            // Only apply to market order, OP_MARKET, OP_ALL.
            if (OrderType() <= 1)
            {
                // Prepare the TakeProfit price and StopLoss price.
                fxOrderModify(ticket, -1, PRICE_PRICE, ptp, ptp_mode, psl, psl_mode);
            }
        }
    }
    else
    {
        // @todo
        Print(AdvisorName, " error #", GetLastError());
    }
}

/**
 * Function wrapper for OrderModify().
 */
bool fxOrderModify(int ticket, double po = -1, int po_mode = PRICE_PRICE,
    double ptp = -1, int ptp_mode = PRICE_PRICE, double psl = -1, int psl_mode = PRICE_PRICE, 
    datetime expiration = -1, color col = CLR_NONE)
{
    // Hook: hook_order_pre_modify().
    hook_order_pre_modify(ticket, po, po_mode, ptp, ptp_mode, psl, psl_mode, expiration, col);
    
    if (OrderSelect(ticket, SELECT_BY_TICKET))
    {
        string sym_m = marketSymbol(OrderSymbol(), SYMBOL_ORDER_MARKET);
        int cmd = OrderType();
        if (po == -1)
        {
            po = OrderOpenPrice();
        }
        else
        {
            fxOrderPriceOpen(sym_m, cmd, po, po_mode);
        }
        if (ptp == -1)
        {
            ptp = OrderTakeProfit();
        }
        else
        {
            fxOrderPriceTakeProfit(sym_m, cmd, po, ptp, ptp_mode);
        }
        if (psl == -1)
        {
            psl = OrderStopLoss();
        }
        else
        {
            fxOrderPriceStopLoss(sym_m, cmd, po, psl, psl_mode);
        }
        if (expiration == -1)
        {
            expiration = OrderExpiration();
        }        
        
        // Hook: hook_order_modify().
        bool result = hook_order_modify(ticket, po, po_mode, ptp, ptp_mode, psl, psl_mode, expiration, col);
    }
    else
    {
        // @todo Handle error.
        return(false);
    }
    
    // Hook: hook_order_post_modify().
    hook_order_post_modify(result, ticket, po, po_mode, ptp, ptp_mode, psl, psl_mode, expiration, col);
    
    return(result);
}

/**
 * Implements hook_order_pre_modify().
 */
void hook_order_pre_modify(int &ticket, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    datetime &expiration, color &col)
{
    
}

/**
 * Implements hook_order_modify().
 */
bool hook_order_modify(int &ticket, double &po, int &po_mode,
    double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    datetime &expiration, color &col)
{
    int cmd = OrderType();
    if (
        (po != OrderOpenPrice() && cmd > 1)
        || ptp != OrderTakeProfit()
        || psl != OrderStopLoss()
        || (expiration != OrderExpiration() && cmd > 1)
    )
    {
        return(OrderModify(ticket, po, psl, ptp, expiration, col));
    }
    
    return(false);
}

/**
 * Implements hook_order_post_modify().
 */
void hook_order_post_modify(bool result, int &ticket, double &po, int &po_mode, 
    double &ptp, int &ptp_mode, double &psl, int &psl_mode,
    datetime &expiration, color &col)
{
    // @todo error handle.
}

/**
 * Prepare the price for opening order.
 *
 * Usually for market order without setting it.
 * @see fxOrderOpen().
 * @see fxOrderBuy().
 * @see fxOrderSell().
 */
void fxOrderPriceOpen(string sym, int &cmd, double &po, int &po_mode)
{
    switch (po_mode)
    {
        case PRICE_PRICE:
            if (po > 0)
            {
                return;
            }
            // Only allow market order to set 0.
            else if (po <= 0)
            {
                switch (cmd)
                {
                    case OP_BUY:
                        po = marketPrice(sym, 0, MODE_ASK);
                        break;
                    case OP_SELL:
                        po = marketPrice(sym, 0, MODE_BID);
                        break;
                }
                
            }
            break;
        case PRICE_PIPS:
        case PRICE_POINTS:
            fxOrderPricePrepare(sym, po, po_mode);
            double price;
            if (cmd == FXOP_PEND_BUY)
            {
                price = marketPrice(sym, 0, MODE_ASK);
                po += price;
                if (po > price)
                {
                    cmd = OP_BUYSTOP;
                }
                else if (po < price)
                {
                    cmd = OP_BUYLIMIT;
                }
            }
            else if (cmd == FXOP_PEND_SELL)
            {
                price = marketPrice(sym, 0, MODE_BID);
                po += price;
                if (po > price)
                {
                    cmd = OP_SELLLIMIT;
                }
                else if (po < price)
                {
                    cmd = OP_SELLSTOP;
                }
            }
            break;
    }
}

/**
 * Helper function to prepare a price by pips_mode.
 */
void fxOrderPricePrepare(string sym, double &price, int &price_mode)
{
    if (price_mode == PRICE_PIPS)
    {
        price = marketPipsToPoints(sym, price);
        price_mode = PRICE_POINTS;
    }
}

/**
 * Helper function to get the order takeprofit price for order operation.
 *
 * @see fxOrderOpen().
 */
void fxOrderPriceTakeProfit(string sym, int cmd, double po, double &ptp, int &ptp_mode, bool real = false)
{
    // Don't need to set if it really not set.
    if (ptp_mode == PRICE_PRICE)
    {
        return(ptp);
    }
    fxOrderPricePrepare(sym, ptp, ptp_mode);
    
    if (real || ptp != 0)
    {
        switch (cmd)
        {
            case OP_BUY:
            case OP_BUYLIMIT:
            case OP_BUYSTOP:
                if (ptp_mode == PRICE_PERCENT)
                {
                    ptp = po * (1 + ptp / 100);
                }
                else
                {
                    ptp = po + ptp;
                }
                break;
            case OP_SELL:
            case OP_SELLLIMIT:
            case OP_SELLSTOP:
                if (ptp_mode == PRICE_PERCENT)
                {
                    ptp = po * (1 - ptp / 100);
                }
                else
                {
                    ptp = po - ptp;
                }
                break;
        }
    }
    
    ptp_mode = PRICE_PRICE;
}

/**
 * Helper function to get the order stoploss price for order operation.
 *
 * @see fxOrderOpen().
 */
void fxOrderPriceStopLoss(string sym, int cmd, double po, double &psl, int &psl_mode, bool real = false)
{
    // Don't need to set if it really not set.
    if (psl_mode == PRICE_PRICE)
    {
        return(psl);
    }
    fxOrderPricePrepare(sym, psl, psl_mode);
    
    if (real || psl != 0)
    {
        switch (cmd)
        {
            case OP_BUY:
            case OP_BUYLIMIT:
            case OP_BUYSTOP:
                if (psl_mode == PRICE_PERCENT)
                {
                    psl = po * (1 - psl / 100);
                }
                else
                {
                    psl = po - psl;
                }
                break;
            case OP_SELL:
            case OP_SELLLIMIT:
            case OP_SELLSTOP:
                if (psl_mode == PRICE_PERCENT)
                {
                    psl = po * (1 + psl / 100);
                }
                else
                {
                    psl = po + psl;
                }
                break;
        }
    }
    
    psl_mode = PRICE_PRICE;
}

/**
 * Wrapper function for OrderClose() and OrderDelete().
 *
 * Make an order easier.
 *
 * @param int ticket
 * @param double lots(Optional)
 * @param double pc(Optional)
 * @param int slippage(Optional)
 * @param color col(Optional)
 */
bool fxOrderClose(int ticket, double lots = 0, double pc = 0, int slippage = 3, color col = White)
{
    // Hook: hook_order_pre_close().
    hook_order_pre_close(ticket, lots, pc, slippage, col);
    
    bool result = false;
    
    // Only deal if order exit and opening.
    if (OrderSelect(ticket, SELECT_BY_TICKET) && OrderCloseTime() == 0)
    {
        string sym = marketSymbol(OrderSymbol(), SYMBOL_ORDER);
        int cmd = OrderType();
        
        // Hook: hook_order_close().
        result = hook_order_close(ticket, sym, cmd, lots, pc, slippage, col);
        
    }
    
    // Hook: hook_order_post_close().
    hook_order_post_close(result, ticket, sym, cmd, lots, pc, slippage, col);
    
    return(result);
}

/**
 * Implements hook_order_pre_close().
 */
void hook_order_pre_close(int &ticket, double &lots, double &pc, int &slippage, color &col)
{

}

/**
 * Implements hook_order_close().
 */
bool hook_order_close(int &ticket, string &sym, int &cmd, double &lots, double &pc, int &slippage, color &col)
{
    bool result = false;
    
    // Pending orders.
    if (OrderType() > 1)
    {
        result = OrderDelete(ticket);
    }
    else
    {
        if (lots <= 0)
        {
            lots = OrderLots();
        }
        if (pc <= 0)
        {
            switch (cmd)
            {
                case OP_BUY:
                    pc = marketPrice(marketSymbol(sym, SYMBOL_ORDER_MARKET), 0, MODE_BID);
                    break;
                case OP_SELL:
                    pc = marketPrice(marketSymbol(sym, SYMBOL_ORDER_MARKET), 0, MODE_ASK);
                    break;
            }
        }
    
        result = OrderClose(ticket, lots, pc, slippage, col);
    }
    
    return(result);
}

/**
 * Implements hook_order_post_close().
 */
void hook_order_post_close(bool result, int ticket, string sym, int cmd, double lots, double pc, int slippage, color col)
{

}

/**
 * Find orders and put into an order_jar.
 * 
 */
int fxOrderFind(int &order_jar[],
    int order_type[],
    int order_profit = PROFIT_ALL,
    string sym = "", int magic = 0, string cmt = "",
    string conditions = "", bool reset = true)
{
    // Make sure it's new.
    if (reset)
    {
        ArrayResize(order_jar, 0);
    }
    if (StringLen(sym) > 0)
    {
        sym = marketSymbol(sym, SYMBOL_ORDER);
    }
    int i, ticket, cmd;
    double profit;
    // if space == FXOP_TOTAL, FXOP_ALL, FXOP_OPENING.
    if (order_type[0] != FXOP_HISTORY)
    {
        for (i = 0; i < OrdersTotal(); i++)
        {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
            ticket = OrderTicket();
            cmd = OrderType();
            profit = OrderProfit();
            if (
                fxOrderProfitCheck(profit, order_profit)
                && fxOrderTypeCheck(FXOP_OPENING, cmd, order_type)
                && fxOrderCheck(ticket, sym, magic, cmt, conditions)
            )
            {
                arrayPushInt(order_jar, ticket);
            }
        }
    }
    // if space == FXOP_TOTAL, FXOP_ALL, FXOP_HISTORY.
    if (order_type[0] != FXOP_OPENING)
    {
        for (i = 0; i < OrdersHistoryTotal(); i++)
        {
            OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
            ticket = OrderTicket();
            cmd = OrderType();
            profit = OrderProfit();
            if (
                fxOrderProfitCheck(profit, order_profit)
                && fxOrderTypeCheck(FXOP_HISTORY, cmd, order_type)
                && fxOrderCheck(ticket, sym, magic, cmt, conditions)
            )
            {
                arrayPushInt(order_jar, ticket);
            }
        }
    }
    
    return(ArraySize(order_jar));
}

/**
 * Check if the order match the conditions.
 */
bool fxOrderCheck(int ticket, string sym = "", int magic = 0, string cmt = "", string conditions = "")
{
    OrderSelect(ticket, SELECT_BY_TICKET);
    if (
        (StringLen(sym) == 0 || OrderSymbol() == sym)
        && OrderMagicNumber() == magic
        && (StringLen(cmt) == 0 || OrderComment() == cmt || OrderComment() == StringConcatenate(cmt, "[tp]") || OrderComment() == StringConcatenate(cmt, "[sl]"))
    )
    {
        return(true);
    }
    
    return(false);
}

/**
 * Check the profit type.
 */
bool fxOrderProfitCheck(double profit, int order_profit = PROFIT_ALL)
{
    if (
        order_profit == PROFIT_ALL
        || (order_profit == PROFIT_POSITIVE && profit > 0) 
        || (order_profit == PROFIT_NEGATIVE && profit < 0)
        || (order_profit == PROFIT_EVEN && profit == 0)
    )
    {
        return(true);
    }
    
    return(false);
}

/**
 * if space = FXOP_TOTAL don't check.
 */
bool fxOrderTypeCheck(int space_raw, int op_type_raw, int order_type[])
{
    if (order_type[0] == FXOP_TOTAL)
    {
        return(true);
    }
    
    int space = order_type[0], time = order_type[1], time_extra = order_type[2], side = order_type[3];
    int time_raw, time_extra_raw, side_raw;
    switch (op_type_raw)
    {
        case OP_BUY:
            time_raw = FXOP_MARKET;
            time_extra_raw = FXOP_ALL;
            side_raw = OP_BUY;
            break;
        case OP_SELL:
            time_raw = FXOP_MARKET;
            time_extra_raw = FXOP_ALL;
            side_raw = OP_SELL;
            break;
        case OP_BUYLIMIT:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_LIMIT;
            side_raw = OP_BUY;
            break;
        case OP_BUYSTOP:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_STOP;
            side_raw = OP_BUY;
            break;
        case OP_SELLLIMIT:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_LIMIT;
            side_raw = OP_SELL;
            break;
        case OP_SELLSTOP:
            time_raw = FXOP_PEND;
            time_extra_raw = FXOP_STOP;
            side_raw = OP_SELL;
            break;
    }
    
    if (
        (space == FXOP_ALL || space_raw == space)
        && (time == FXOP_ALL || time_raw == time)
        && (time_extra == FXOP_ALL || time_extra_raw == time_extra)
        && (side == FXOP_ALL || side_raw == side)
    )
    {
        return(true);
    }
    
    return(false);
}

//---------- FX_Order:End ----------//
  
//---------- FX:End ----------//

