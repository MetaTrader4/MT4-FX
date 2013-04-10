//---------- fxOrderCloseStealth ----------//
/**
 * @file
 *     Close an opening order by identify the ticket.
 * 
 * @extension
 *     fxOrderJarCloseStealth.
 */

/**
 * Stealth tp, sl.
 *
 * @param int ticket
 * @param double ptp
 * @param double psl
 * @param int pips_mode
 */
void fxOrderCloseStealth(int ticket, double ptp = 0, double psl = 0, int pips_mode = PIPS_PIPS)
{
    OrderSelect(ticket, SELECT_BY_TICKET);
    fxOrderPricePipsMode(OrderSymbol(), OrderType(), OrderOpenPrice(), ptp, ssl, pips_mode);
    double pc = fxOrderPriceClose(OrderSymbol(), OrderType());
    if (
        (OrderType() == OP_BUY && (pc >= ptp || pc <= psl))
        || (OrderType() == OP_SELL && (pc <= ptp || pc >= psl))
    )
    {
        fxOrderClose(OrderTicket());
    }
}

void fxOrderCloseStealthDelegate()
{

}