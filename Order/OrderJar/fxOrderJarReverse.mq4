

                if (ticket > 0)
                {
                    arrayPushInt(order_jar_reverse, ticket);
                }
                
                
/**
 * Trend Reverse Process.
 */
void reverseProcess(int &order_jar[])
{
    int i;
    int size = ArraySize(order_jar);
    for (i = 0; i < size; i++)
    {
        if (OrderSelect(order_jar[i], SELECT_BY_TICKET) != false)
        {
            if (OrderCloseTime() > 0)
            {
                if (TimeCurrent() - OrderCloseTime() <= 10)
                {
                    if (OrderType() == OP_BUY)
                    {
                        fxOrderImportEntryQueue(order_entry_queue, OP_SELL, "Reverse");
                    }
                    else if (OrderType() == OP_SELL)
                    {
                        fxOrderImportEntryQueue(order_entry_queue, OP_BUY, "Reverse");
                    }
                }
                arrayPushInt(order_jar_reverse_junk, i);
            }
        }
        else
        {
            arrayPushInt(order_jar_reverse_junk, i);
        }
    }
    
    // Clear.
    if (ArraySize(order_jar_reverse_junk) > 0)
    {
        arrayRemoveAndSortMultiInt(order_jar_reverse, order_jar_reverse_junk);
        ArrayResize(order_jar_reverse_junk, 0);
        logGV_OJR();
    }
}

/**
 * MT4 Recovery Protection.
 */
void initGV_OJR()
{
    if (IsTesting())
    {
        FileDelete(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_ojr");
        return;
    }
    
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_ojr", FILE_BIN | FILE_READ);
    
    if (file != -1)
    {
        int size = FileReadInteger(file);
        FileReadArray(file, order_jar_reverse, 0, size);
        FileClose(file);
    }
    
}

void logGV_OJR()
{
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_ojr", FILE_BIN | FILE_WRITE);
    int size = ArraySize(order_jar_reverse);
    FileWriteInteger(file, size);
    FileWriteArray(file, order_jar_reverse, 0, size);

    FileClose(file);
}

