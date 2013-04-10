
// Module: Order_Queue_Pend.
string order_queue_pend[0,12];
int order_queue_pend_junk[0];

int init()
{
    // order_queue_pend.
    initGV_OQP();
}


/**
 * Module: Order_Queue_Pend.
 */
void orderQueuePend(string &order_queue[,], int &order_queue_junk[])
{
    int i, size;
    // Variables of order metadata.
    int cmd, po_mode, ptp_mode, psl_mode, slippage, magic, expire, col;
    double po, lots, ptp, psl;
    string sym, cmt;
    // OrderSend order_queue_entry.
    size = ArrayRange(order_queue, 0);
    for (i = 0; i < size; i++)
    {
        fxOrderExportEntryQueue(order_queue, i, cmd, po, po_mode, lots, ptp, ptp_mode, psl, psl_mode, slippage, sym, magic, cmt, expire, col);
        if (po_mode != PRICE_PRICE)
        {
            fxOrderPriceOpen(sym, cmd, po, po_mode);
            order_queue[i,0] = cmd;
            order_queue[i,1] = DoubleToStr(po, Digits);
            order_queue[i,2] = po_mode;
        }
        if (ptp_mode != PRICE_PRICE)
        {
            fxOrderPriceTakeProfit(sym, cmd, po, ptp, ptp_mode);
            order_queue[i,4] = DoubleToStr(ptp, Digits);
            order_queue[i,5] = ptp_mode;
        }
        if (psl_mode != PRICE_PRICE)
        {
            fxOrderPriceStopLoss(sym, cmd, po, psl, psl_mode);
            order_queue[i,6] = DoubleToStr(psl, Digits);
            order_queue[i,7] = psl_mode;
        }
        switch (cmd)
        {
            case OP_BUYSTOP:
                if (Ask >= po)
                {
                    fxOrderImportEntryQueue(order_queue_entry, OP_BUY, cmt, 0, PRICE_PRICE, 0, ptp, PRICE_PRICE, psl, PRICE_PRICE);
                    arrayPushInt(order_queue_junk, i);
                }
                break;
            case OP_BUYLIMIT:
                if (Ask <= po)
                {
                    fxOrderImportEntryQueue(order_queue_entry, OP_BUY, cmt, 0, PRICE_PRICE, 0, ptp, PRICE_PRICE, psl, PRICE_PRICE);
                    arrayPushInt(order_queue_junk, i);
                }
                break;
            case OP_SELLSTOP:
                if (Bid <= po)
                {
                    fxOrderImportEntryQueue(order_queue_entry, OP_SELL, cmt, 0, PRICE_PRICE, 0, ptp, PRICE_PRICE, psl, PRICE_PRICE);
                    arrayPushInt(order_queue_junk, i);
                }
                break;
            case OP_SELLLIMIT:
                if (Bid >= po)
                {
                    fxOrderImportEntryQueue(order_queue_entry, OP_SELL, cmt, 0, PRICE_PRICE, 0, ptp, PRICE_PRICE, psl, PRICE_PRICE);
                    arrayPushInt(order_queue_junk, i);
                }
                break;
        }
        // Clear.
        if (ArraySize(order_queue_junk) > 0)
        {
            string order_queue_tmp[,14];
            array2DRemoveAndSortMultiString(order_queue, order_queue_tmp, order_queue_junk);
            ArrayResize(order_queue_junk, 0);
            logGV_OQP();
        }
    }
}

void initGV_OQP()
{
    if (IsTesting())
    {
        FileDelete(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_oqp");
        return;
    }
    
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_oqp", FILE_BIN | FILE_READ);
    
    if (file != -1)
    {
        int size = FileReadInteger(file);
        FileReadArray(file, order_queue_pend, 0, size);
        FileClose(file);
    }
    
}

void logGV_OQP()
{
    int file = FileOpen(AdvisorName + "_" + Symbol() + "_" + Magic + ".gv_oqp", FILE_BIN | FILE_WRITE);
    int size = ArrayRange(order_queue_pend, 0);
    FileWriteInteger(file, size);
    FileWriteArray(file, order_queue_pend, 0, size);

    FileClose(file);
}



//---------- Integrate with ChartControl ----------//


