
/**
 * MT4 Recovery Protection.
 */
void initGV()
{
    ArrayResize(grid_long, Pend_Prepare);
    ArrayResize(grid_short, Pend_Prepare);
    ArrayInitialize(grid_long, 0);
    ArrayInitialize(grid_short, 0);

    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv", FILE_BIN | FILE_READ);
    if (file != -1)
    {
        FileReadArray(file, grid_long, 0, Pend_Prepare);
        FileReadArray(file, grid_short, 0, Pend_Prepare);
        FileReadInteger(file, gridml);
        FileReadInteger(file, gridms);
        FileReadInteger(file, ticket_first);
        FileReadDouble(file, equity_start);
        FileClose(file);
    
        if (OrderSelect(ticket_first, SELECT_BY_TICKET))
        {
            if (OrderCloseTime() > 0)
            {
                ticket_first = -1;
            }
        }
        else
        {
            ticket_first = -1;
        }
    }
}

void logGV()
{
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv", FILE_BIN | FILE_WRITE);
    FileWriteArray(file, grid_long, 0, Pend_Prepare);
    FileWriteArray(file, grid_short, 0, Pend_Prepare);
    FileWriteInteger(file, gridml);
    FileWriteInteger(file, gridms);
    FileWriteInteger(file, ticket_first);
    FileWriteDouble(file, equity_start);
    FileClose(file);
}


/**
 * MT4 Recovery Protection.
 */
void initGV_ORW()
{
    if (IsTesting())
    {
        FileDelete(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_orw");
        return;
    }
    
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_orw", FILE_BIN | FILE_READ);
    
    if (file != -1)
    {
        int size = FileReadInteger(file);
        FileReadArray(file, order_reverse_wait, 0, size);
        FileClose(file);
    }
    
}

void logGV_ORW()
{
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_orw", FILE_BIN | FILE_WRITE);
    int size = ArraySize(order_reverse_wait);
    FileWriteInteger(file, size);
    FileWriteArray(file, order_reverse_wait, 0, size);

    FileClose(file);
}