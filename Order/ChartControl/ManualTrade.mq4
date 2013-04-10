
/**
 * Setup two boxes for buy and sell.
 */
void fxOrderChartControlManualTrade()
{
    objLabel(AdvisorName + "_Manual", "Manual Trade (Drag the label away.)", 1, 20, 20, 0, White, "Arial", 12);
    if (ObjectFind(AdvisorName + "_Manual_Long", "Long") == -1)
    {
        objLabel(AdvisorName + "_Manual_Long", "Long", 1, 20, 40, 0, Lime, "Arial", 12);
    }
    else if (ObjectGet(ObjectFind(AdvisorName + "_Manual_Long", OBJPROP_TIME1) != 20 || ObjectGet(ObjectFind(AdvisorName + "_Manual_Long", OBJPROP_PRICE1) != 40)
    {
        fxOrderImportEntryQueue(order_queue_entry, OP_BUY, "Master");
    }
    if (ObjectFind(AdvisorName + "_Manual_Short", "Short") == -1)
    {
        objLabel(AdvisorName + "_Manual_Short", "Short", 1, 20, 60, 0, Red, "Arial", 12);
    }
    else if (ObjectGet(ObjectFind(AdvisorName + "_Manual_Short", OBJPROP_TIME1) != 20 || ObjectGet(ObjectFind(AdvisorName + "_Manual_Short", OBJPROP_PRICE1) != 60)
    {
        fxOrderImportEntryQueue(order_queue_entry, OP_SELL, "Master");
    }
}