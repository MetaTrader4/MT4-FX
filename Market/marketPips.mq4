/*
name = FX_Market_Pips
dependencies[] = FX_Market_Symbol
*/

// Market Pips
#define PIPS_INPUT 0
#define PIPS_PRICE 1
#define POINTS_INPUT 10
#define POINTS_PRICE 11

//---------- 1.x ----------//
/**
 * Turn pips to platform specific points.
 *
 * Intend to auto fit 4/5 digits platoform and for forex symbols only.
 * Usuall add a AutoPips check to hook_pre_market_pips_points as a switch.
 */
double marketPipsToPoints(string sym, double pips, bool return_price = TRUE)
{
    double points;
    int factor = marketPipsFactor(sym);
    points = pips * factor;
    
    // Return price format.
    if (return_price)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }

    return(points);
}

double marketPointsToPips(string sym, double points, bool return_price = TRUE)
{
    double pips;
    int factor = marketPipsFactor(sym);
    pips = points / factor;

    // Return price format.
    if (return_price)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }

    return(pips);
}

int marketPipsFactor(string sym)
{
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


//---------- 1.x Example ----------//
// @category broker_compatible
extern bool AutoPips = true;          // Intend to auto fit 4/5 digits platoform and for forex symbols only.

/**
 * Turn pips to platform specific points.
 *
 * Intend to auto fit 4/5 digits platoform and for forex symbols only.
 * Usuall add a AutoPips check to hook_pre_market_pips_points as a switch.
 */
double marketPipsToPoints(string sym, double pips, bool return_price = TRUE)
{
    double points;
    int factor;
    if (AutoPips)
    {
        factor = marketPipsFactor(sym);
    }
    else
    {
        factor = 1;
    }
    points = pips * factor;
    
    // Return price format.
    if (return_price)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }

    return(points);
}

double marketPointsToPips(string sym, double points, bool return_price = TRUE)
{
    double pips;
    int factor;
    if (AutoPips)
    {
        factor = marketPipsFactor(sym);
    }
    else
    {
        factor = 1;
    }
    pips = points / factor;

    // Return price format.
    if (return_price)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }

    return(pips);
}

int marketPipsFactor(string sym)
{
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


//---------- 2.x ----------//

// @todo Use hook to inject change.

/**
 * Turn pips to platform specific points.
 *
 * Intend to auto fit 4/5 digits platoform and for forex symbols only.
 * Usuall add a AutoPips check to hook_pre_market_pips_points as a switch.
 */
double marketPipsToPoints(string sym, double pips, int input = PIPS_INPUT, bool output = PIPS_PRICE)
{
    double points;
    points = pips * marketPipsFactor(sym);
    
    // Return price format.
    if (input == PIPS_INPUT && output == PIPS_PRICE)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }
    // Return input format.
    if (input == PIPS_PRICE && output == PIPS_INPUT)
    {
        points *= MathPow(10, marketDigits(sym));
    }

    return(points);
}

double marketPointsToPips(string sym, double points, int input = POINTS_INPUT, bool output = POINTS_PRICE)
{
    double pips;
    pips = points / marketPipsFactor(sym);
    
    if (input == POINTS_INPUT && output == POINTS_PRICE)
    {
        pips *= MarketInfo(sym, MODE_POINT);
    }
    if (input == POINTS_PRICE && output == POINTS_INPUT)
    {
        pips *= MathPow(10, marketDigits(sym));
    }

    return(pips);
}

int marketPipsFactor(string sym)
{
    if (AutoPips) return(1);
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

//---------- 1.x Example ----------//
// @category broker_compatible
extern bool AutoPips = true;          // Intend to auto fit 4/5 digits platoform and for forex symbols only.

/**
 * Turn pips to platform specific points.
 *
 * Intend to auto fit 4/5 digits platoform and for forex symbols only.
 * Usuall add a AutoPips check to hook_pre_market_pips_points as a switch.
 */
double marketPipsToPoints(string sym, double pips, bool return_price = TRUE)
{

    double points;
    if (!AutoPips)
    {
        points = pips;
    }
    else
    {
        int digits = MarketInfo(sym, MODE_DIGITS);
        if (MarketInfo(sym, MODE_BID) < 10)
        {
            points = pips * digits - 4);
        }
        else if (MarketInfo(sym, MODE_BID) > 10)
        {
            points = pips * digits - 2);  
        }
    }
    
    // Return price format.
    if (return_price)
    {
        points *= MarketInfo(sym, MODE_POINT);
    }

    return(points);
}

