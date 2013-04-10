/**
 * Count number of order in order_queue.
 */
int countOrderQueue(string order_queue[,12], string cmt)
{
    int i;
    int count = 0;
    int size = ArrayRange(order_queue, 0);
    
    for (i = 0; i < size; i++)
    {
        if (order_queue[i,11] == cmt)
        {
            count += 1;
        }
    }
    
    return(count);
}