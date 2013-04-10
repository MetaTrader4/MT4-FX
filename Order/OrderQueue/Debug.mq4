

void fxOrderQueuePrint(string order_queue[,])
{
    int i, j;
    
    for (i = 0; i < ArrayRange(order_queue, 0); i++)
    {
        for (j = 0; j < ArrayRange(order_queue, 1); j++)
        {
            Print("[" + i + "," + j + "]: " + order_queue[i][j]);
            //Print(order_queue_test[i][j]);
        }
    }
}