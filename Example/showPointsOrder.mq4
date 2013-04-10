
List the orders and separated by buy/sell.

/**
 * DC_ShowPointsOrder.
 */
void showPointsOrder()
{
    int i;
    int x = 10, y = 20;
    int x_gap = 8 * DC_FontSize;
    int y_gap = 1.5 * DC_FontSize;
    int x_order = x + 12 * DC_FontSize;
    // Long.
    objLabel(AdvisorName + "_LongOrders", "Long-Orders", 0, x, y, 0, DC_FontColor, DC_FontFamily, DC_FontSize);
    x = x + 10 * DC_FontSize;
    objLabel(AdvisorName + "_LongOrders_Points", cp_trade[0], 0, x, y, 0, DC_FontColor, DC_FontFamily, DC_FontSize);
    x = x_order;
    for (i = 0; i < order_jar_ea_buy_size; i++)
    {
        if (i > 0 && MathMod(i, 5) == 0)
        {
            x = x_order;
            y += y_gap;
        }
        objLabel(AdvisorName + "_LongOrders_" + i, cp_entry[0] + "/" + cp_exit[0] + "/" + fxOrderProfitString(order_jar_ea_buy[i], PROFIT_PIPS, true), 0, x, y, 0, DC_FontColor, DC_FontFamily, DC_FontSize);
        x += x_gap;
    }
    // Short.
    x = 10;
    y += y_gap;
    objLabel(AdvisorName + "_ShortOrders", "Short-Orders", 0, x, y, 0, DC_FontColor, DC_FontFamily, DC_FontSize);
    x = x + 10 * DC_FontSize;
    objLabel(AdvisorName + "_ShortOrders_Points", cp_trade[1], 0, x, y, 0, DC_FontColor, DC_FontFamily, DC_FontSize);
    x = x_order;
    for (i = 0; i < order_jar_ea_sell_size; i++)
    {
        if (i > 0 && MathMod(i, 5) == 0)
        {
            x = x_order;
            y += y_gap;
        }
        objLabel(AdvisorName + "_ShortOrders_" + i, cp_entry[1] + "/" + cp_exit[1] + "/" + fxOrderProfitString(order_jar_ea_sell[i], PROFIT_PIPS, true), 0, x, y, 0, DC_FontColor, DC_FontFamily, DC_FontSize);
        x += x_gap;
    }
}