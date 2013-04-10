Logic:
Modify the StopLoss of the order if the price go advance beyond BE_Start with the value of (OrderOpenPrice() + BE_Add).


// Order Operation - Break Even
extern string    BreakEven = "--- Break Even ---";
extern bool          BE_On = false;                // Whether using BreakEven.
extern bool BE_StealthMode = false;                // Whether using BreakEven in Stealth Mode.
extern double     BE_Start = 20;                   // In Pips. How much should the current price above/below the open price.
extern double       BE_Add = 0;                    // In Pips. Add a deviation to the Order Open Price, positive value for profit.

void breakEven()
  {
   int orders_total = OrdersTotal();
   int i, ticket;
   double break_even_points = pips2Points(BE_Pips)*Point;
   double break_even_move = pips2Points(BE_Move)*Point;
   double stoploss_buy, stoploss_sell;
   string gv_name;
   double break_even_able;
   double ask_s, bid_s;
   
   for(i=0; i<orders_total; i++) {
      break_even_able = -1;
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      ask_s = MarketInfo(OrderSymbol(), MODE_ASK);
      bid_s = MarketInfo(OrderSymbol(), MODE_BID);
      stoploss_buy = OrderOpenPrice() + break_even_move;
      stoploss_sell = OrderOpenPrice() - break_even_move;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderProfit()>0) {
         if(BE_StealthMode) {
            break_even_able = GlobalVariableGet(AdvisorName+"_be_able_"+OrderTicket());
            if(OrderType()==OP_BUY && break_even_able>0 && bid_s<=stoploss_buy) {
               OrderClose(OrderTicket(), OrderLots(), bid_s, Slippage, White);
            }
            else if(OrderType()==OP_SELL && break_even_able>0 && ask_s>=stoploss_sell) {
               OrderClose(OrderTicket(), OrderLots(), ask_s, Slippage, White);
            }
         }
      
         if(OrderType()==OP_BUY && (OrderStopLoss()<stoploss_buy || OrderStopLoss()==0)
            && bid_s-OrderOpenPrice()>=break_even_points) {
            if(!BE_StealthMode) {
               OrderModify(OrderTicket(), OrderOpenPrice(), stoploss_buy, OrderTakeProfit(), 0, Green);
            }
            else {
               GlobalVariableSet(AdvisorName+"_be_able_"+OrderTicket(), 1);
            }
         }
         else if(OrderType()==OP_SELL && (OrderStopLoss()>stoploss_sell || OrderStopLoss()==0)
            && OrderOpenPrice()-ask_s>=break_even_points) {
            if(!BE_StealthMode) {
               OrderModify(OrderTicket(), OrderOpenPrice(), stoploss_sell, OrderTakeProfit(), 0, Magenta);
            }
            else {
               GlobalVariableSet(AdvisorName+"_be_able_"+OrderTicket(), 1);
            }
         }
      }
   }
   
   // Clear the un-used Global Variables
   for(i=0; i<GlobalVariablesTotal(); i++) {
      gv_name = GlobalVariableName(i);
      if(StringSubstr(gv_name, 0, 9+StringLen(AdvisorName))==AdvisorName+"_be_able_") {
         ticket = StrToInteger(StringSubstr(gv_name, 9+StringLen(AdvisorName)));
         OrderSelect(ticket, SELECT_BY_TICKET);
         if(OrderCloseTime()>0) {
            GlobalVariableDel(gv_name);
         }
      }
   }
  }
  
  
void fxOrderBreakEven(int ticket, double p_be)
{
    
}