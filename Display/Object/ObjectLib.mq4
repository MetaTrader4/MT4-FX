/*
@todo
object new created?
object set value?
*/

//---------- FX_Object:Start ----------//

//---------- FX_Object:End ----------//

/**
 * Clear objects with prefix or suffix.
 */
void objClear(string prefix = "", string suffix = "") 
{
    string name;
    int obj_total = ObjectsTotal();
    for (int i=obj_total-1; i>=0; i--)
    {
        name = ObjectName(i);
        if (StringFind(name, prefix) == 0) ObjectDelete(name);
    }
}

/**
 * Set object Trend Line, create if not exist yet.
 */
void objTrendLine(string name, datetime time_1, double price_1, datetime time_2, double price_2, int window=0, int width=1, color col=White, int style=STYLE_SOLID, bool ray=true)
{
    if (ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_TREND, window, time_1, price_1, time_2, price_2);
    }
    ObjectSet(name, OBJPROP_PRICE1, price_1);
    ObjectSet(name, OBJPROP_PRICE2, price_2);
    ObjectSet(name, OBJPROP_TIME1, time_1);
    ObjectSet(name, OBJPROP_TIME2, time_2);
    ObjectSet(name, OBJPROP_WIDTH, width);
    ObjectSet(name, OBJPROP_COLOR, col);
    ObjectSet(name, OBJPROP_STYLE, style);
    ObjectSet(name, OBJPROP_RAY, ray);
}
  
/**
 * Set object Horizonal Line, create if not exist yet.
 */
void objHLine(string name, double price, int window=0, color col=White, int width=1, int style=STYLE_SOLID)
{
    if (ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_HLINE, window, 0, price);
    }
    ObjectSet(name, OBJPROP_PRICE1, price);
    ObjectSet(name, OBJPROP_COLOR, col);
    ObjectSet(name, OBJPROP_WIDTH, width);
    ObjectSet(name, OBJPROP_STYLE, style);
}
  
/**
 * Set object Vertical Line, create if not exist yet.
 */
void objVLine(string name, int time, int window=0, color col=White, int width=1, int style=STYLE_SOLID)
{
    if (ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_VLINE, window, 0, 0, 0);
    }
    ObjectSet(name, OBJPROP_TIME1, time);
    ObjectSet(name, OBJPROP_COLOR, col);
    ObjectSet(name, OBJPROP_WIDTH, width);
    ObjectSet(name, OBJPROP_STYLE, style);
}
  
/**
 * Set Object Label, create if not exist yet.
 */
void objLabel(string name, string tex, int corner, int position_x, int position_y, int window=0, color tex_color=White, string tex_font="Arial", int tex_size=12)
{
    if(ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_LABEL, window, 0, 0);
    }
    ObjectSet(name, OBJPROP_CORNER, corner);
    ObjectSet(name, OBJPROP_XDISTANCE, position_x);
    ObjectSet(name, OBJPROP_YDISTANCE, position_y);
    ObjectSetText(name, tex, tex_size, tex_font, tex_color);
}
  
/**
 * Set Object Arrow, create if not exist yet.
 */
void objArrow(string name, int code, datetime time, double price, int window=0, color col=White, int width=1)
{
    if(ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_ARROW, window, time, price);
    }
    ObjectSet(name, OBJPROP_ARROWCODE, code);
    ObjectSet(name, OBJPROP_TIME1, time);
    ObjectSet(name, OBJPROP_PRICE1, price);
    ObjectSet(name, OBJPROP_COLOR, col);
    ObjectSet(name, OBJPROP_WIDTH, width);
}
  
/**
 * Set Object Text, create if not exist yet.
 */
void objText(string name, string tex, datetime time, double price, int window=0, color tex_color=White, string tex_font="Arial", int tex_size=12)
{
    if (ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_TEXT, window, time, price);
    }
    ObjectSet(name, OBJPROP_TIME1, time);
    ObjectSet(name, OBJPROP_PRICE1, price);
    ObjectSetText(name, tex, tex_size, tex_font, tex_color);
}
  
/**
 * Set Object Rectangle, create if not exist yet.
 */
void objRectangle(string name, datetime time_1, double price_1, datetime time_2, double price_2, int window=0, color color_obj=Blue, bool draw_back=true)
{
    if (ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_RECTANGLE, window, time_1, price_1, time_2, price_2);
    }
    ObjectSet(name, OBJPROP_TIME1, time_1);
    ObjectSet(name, OBJPROP_PRICE1, price_1);
    ObjectSet(name, OBJPROP_TIME2, time_2);
    ObjectSet(name, OBJPROP_PRICE2, price_2);
    ObjectSet(name, OBJPROP_COLOR, color_obj);
    ObjectSet(name, OBJPROP_BACK, draw_back);
}
  
/**
 * Set Object Fibonacci Retracement, create if not exist yet.
 */
void objFiboRetrace(string name, datetime time_1, double price_1, datetime time_2, double price_2, int window=0, color color_obj=Red, bool ray=true)
{
    if (ObjectFind(name) == -1)
    {
        ObjectCreate(name, OBJ_FIBO, window, time_1, price_1, time_2, price_2);
    }
    ObjectSet(name, OBJPROP_TIME1, time_1);
    ObjectSet(name, OBJPROP_PRICE1, price_1);
    ObjectSet(name, OBJPROP_TIME2, time_2);
    ObjectSet(name, OBJPROP_PRICE2, price_2);
    ObjectSet(name, OBJPROP_COLOR, color_obj);
    ObjectSet(name, OBJPROP_RAY, ray);
}