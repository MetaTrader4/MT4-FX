/**
 * Find out the just opened/closed orders.
 */
void fxOrderJarOCed(int order_jar[], int &order_jar_old[], int &order_jar_opened[], int &order_jar_closed[])
{
    int i;
    int size = ArraySize(order_jar);
    int size_old = ArraySize(order_jar_old);
    // Find the order_jar_opened[].
    ArrayResize(order_jar_opened, 0);
    for (i = 0; i < size; i++)
    {
        if (!inArrayInt(order_jar[i], order_jar_old))
        {
            arrayPushInt(order_jar_opened, order_jar[i]);
        }
    }
    // Find the order_jar_closed[].
    ArrayResize(order_jar_closed, 0);
    for (i = 0; i < size_old; i++)
    {
        if (!inArrayInt(order_jar_old[i], order_jar))
        {
            arrayPushInt(order_jar_closed, order_jar_old[i]);
        }
    }
    // Update the order_jar_old[] to new.
    ArrayResize(order_jar_old, size);
    if (size > 0)
    {
        ArrayCopy(order_jar_old, order_jar);
    }
}