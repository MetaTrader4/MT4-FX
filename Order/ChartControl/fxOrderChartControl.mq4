
/*
1. If no lines, create the lines.
2. If have lines:
    a. Chanage the corresponding values.
    b. Delegate to StealthMode.
    c. Check if need to extend.
*/

/**
 * Module: fxOrderChartControl.
 *
 * Create TP/SL control lines on chart.
 */
void fxOrderJarChartControl(int order_jar[])
{
    int i;
    int size = ArraySize(order_jar);
    string tp_line, sl_line;
    double tp, sl;
    datetime time_end;
    
    for (i = 0; i < size; i++)
    {
        OrderSelect(order_jar[i], SELECT_BY_TICKET);
        tp_line = order_jar[i] + "_TP";
        sl_line = order_jar[i] + "_SL";
        time_end = iTime(Symbol(), PERIOD_D1, iBarShift(Symbol(), PERIOD_D1, OrderOpenTime())) + PERIOD_D1 * 60;
        
        // If no line, create the line.
        if (ObjectFind(tp_line) == -1)
        {
            hook_order_jar_chart_control_p("TP", tp);
            if (tp > 0) objTrendLine(tp_line, OrderOpenTime(), tp, time_end, tp, 0, 1, Lime, STYLE_DOT, true);
        }
        // If has line, load the value.
        else
        {
            tp = ObjectGetValueByShift(tp_line, 0);
        }
        if (ObjectFind(sl_line) == -1)
        {
            hook_order_jar_chart_control_p("SL", sl);
            if (sl > 0) objTrendLine(sl_line, OrderOpenTime(), sl, time_end, sl, 0, 1, Red, STYLE_DOT, true);
        }
        else
        {
            sl = ObjectGetValueByShift(sl_line, 0);
        }
        
        // Hook: hook_order_jar_chart_control.
        hook_order_jar_chart_control_o(order_jar[i], tp, sl);
    }
}

/**
 * Hook: hook_order_jar_chart_control_p().
 */
void hook_order_jar_chart_control_p(string type, double &price)
{
    int price_mode = PRICE_PIPS;
    
    if (type == "TP")
    {
        if (!StealthMode)
        {
            price = OrderTakeProfit();
        }
        else
        {
            price = TakeProfit;
            fxOrderPriceTakeProfit(OrderSymbol(), OrderType(), OrderOpenPrice(), price, price_mode);
        }
    }
    if (type == "SL")
    {
        if (!StealthMode)
        {
            price = OrderStopLoss();
        }
        else
        {
            price = StopLoss;
            fxOrderPriceStopLoss(OrderSymbol(), OrderType(), OrderOpenPrice(), price, price_mode);
        }
    }
}

/**
 * Hook: hook_order_jar_chart_control().
 */
void hook_order_jar_chart_control_o(int ticket, double tp, double sl)
{
    if (!StealthMode)
    {
        if (OrderTakeProfit() != tp || OrderStopLoss() != sl)
        {
            OrderModify(ticket, OrderOpenPrice(), sl, tp, 0, CLR_NONE);
        }
    }
    else
    {
        stealthModeSet("TP", "ChartControl", ticket, tp);
        stealthModeSet("SL", "ChartControl", ticket, sl);
    }
}


/**
 * Clear the closed order objects.
 */
void fxOrderJarChartControlClear(int order_jar[])
{
    int i;
    int size = ArraySize(order_jar);
    string tp_line, sl_line;
    for (i = 0; i < size; i++)
    {
        OrderSelect(order_jar[i], SELECT_BY_TICKET);
        tp_line = order_jar[i] + "_TP";
        sl_line = order_jar[i] + "_SL";
        ObjectDelete(tp_line);
        ObjectDelete(sl_line);
    }
}

/**
 * Module: fxOrderChartControl.
 *
 * Create order metadata control lines on chart.
 * Only for pending orders.
 */
void fxOrderQueueChartControl(string &order_queue[,], int order_queue_uuid[])
{
    int i;
    // Variables of order metadata.
    int cmd, po_mode, ptp_mode, psl_mode, slippage, magic, expire, col;
    double po, lots, ptp, psl;
    string sym, cmt;
    int size = ArrayRange(order_queue, 0);
    string po_line, ptp_line, psl_line;
    datetime time_end = iTime(Symbol(), PERIOD_D1, 0) + PERIOD_D1 * 60;
    for (i = 0; i < size; i++)
    {
        fxOrderExportEntryQueue(order_queue, i, cmd, po, po_mode, lots, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        if (sym == Symbol() && cmd > 1)
        {
            po_line = "OQCC" + order_queue_uuid[i] + "_PO";
            ptp_line = "OQCC" + order_queue_uuid[i] + "_PTP";
            psl_line = "OQCC" + order_queue_uuid[i] + "_PSL";
            
            // po.
            if (ObjectFind(po_line) == -1)
            {
                if (po_mode != PRICE_PRICE)
                {
                    fxOrderPriceOpen(sym, cmd, po, po_mode);
                    order_queue[i,1] = DoubleToStr(po, Digits);
                    order_queue[i,2] = po_mode;
                }
                objTrendLine(po_line, Time[0], po, time_end, po, 0, 1, col, STYLE_SOLID, true);
            }
            else
            {
                order_queue[i,1] = DoubleToStr(ObjectGetValueByShift(po_line, 0), Digits);
            }
            // ptp.
            if (ObjectFind(ptp_line) == -1)
            {
                if (ptp_mode != PRICE_PRICE)
                {
                    fxOrderPriceTakeProfit(sym, cmd, po, ptp, ptp_mode);
                    order_queue[i,4] = DoubleToStr(ptp, Digits);
                    order_queue[i,5] = ptp_mode;
                }
                if (ptp > 0) objTrendLine(ptp_line, Time[0], ptp, time_end, ptp, 0, 1, col, STYLE_SOLID, true);
            }
            else
            {
                order_queue[i,4] = DoubleToStr(ObjectGetValueByShift(ptp_line, 0), Digits);
            }
            // psl.
            if (ObjectFind(psl_line) == -1)
            {
                if (psl_mode != PRICE_PRICE)
                {
                    fxOrderPriceStopLoss(sym, cmd, po, psl, psl_mode);
                    order_queue[i,6] = DoubleToStr(psl, Digits);
                    order_queue[i,7] = psl_mode;
                }
                if (psl > 0) objTrendLine(psl_line, Time[0], psl, time_end, psl, 0, 1, col, STYLE_SOLID, true);
            }
            else
            {
                order_queue[i,6] = DoubleToStr(ObjectGetValueByShift(psl_line, 0), Digits);
            }
        }
    }
}

void fxOrderQueueChartControlClear(string &order_queue[,], int order_queue_uuid[])
{
    int i;
    int size = ArrayRange(order_queue, 0);
    for (i = 0; i < size; i++)
    {
        // @todo, Transfer, not delete.
        ObjectDelete("OQCC" + order_queue_uuid[i] + "_PO");
        ObjectDelete("OQCC" + order_queue_uuid[i] + "_PTP");
        ObjectDelete("OQCC" + order_queue_uuid[i] + "_PSL");
    }
}


void fxOrderQueueChartControlObjects(int uuid, int ticket)
{
    
}