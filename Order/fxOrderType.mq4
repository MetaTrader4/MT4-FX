
// Extension of OP_*
// All v.s. Opening v.s. History // type_space
// All v.s. Market v.s. Pending // type_time
// All v.s. Stop v.s. Limit // type_time_extra
// All v.s. Buy v.s. Sell // type_side
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

// #define OP_BUY 0
// #define OP_SELL 1
// #define OP_BUYLIMIT 2
// #define OP_SELLLIMIT 3
// #define OP_BUYSTOP 4
// #define OP_SELLSTOP 5

#define PROFIT_ALL 100
#define PROFIT_POSITIVE 1
#define PROFIT_EVEN 0
#define PROFIT_NEGATIVE -1

int start(){}

/**
 * if space = OP_TOTAL don't check.
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



/**
 * Compare the cmd to the extension OP_*.
 */
/*
bool fxOrderTypeCompare(int op_type, int type_time, int type_side)
{
    int time, side;
    switch (op_type)
    {
        case OP_BUY:
            time = OP_MARKET;
            side = OP_BUY;
            break;
        case OP_SELL:
            time = OP_MARKET;
            side = OP_SELL;
            break;
        case OP_PEND_BUY:
            time = OP_PEND;
            side = OP_BUY;
            break;
         case OP_PEND_BUY:
            time = OP_PEND;
            side = OP_SELL;
            break;
        case OP_BUYLIMIT:
            time = OP_PEND;
            side = OP_BUY;
            break;
        case OP_BUYSTOP:
            time = OP_PEND;
            side = OP_BUY;
            break;
        case OP_SELLLIMIT:
            time = OP_PEND;
            side = OP_SELL;
            break;
        case OP_SELLSTOP:
            time = OP_PEND;
            side = OP_SELL;
            break;
        
    }
    
    if (type_time == time && type_side == side)
    {
        return(true);
    }
    
    return(false);
}
*/