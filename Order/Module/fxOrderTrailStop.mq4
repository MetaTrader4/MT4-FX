Logic:
Continue moving the StopLoss setting of the Order, 


// Order Operation - Trailing Stop
extern string  Trailing_Stop = "--- Trailing Stop ---";
extern bool            TS_On = false;                   // Whether using TrailStop.
extern bool   TS_StealthMode = false;                   // Whether using TrailStop in Stealth Mode.
extern int          TS_Start = 20;                      // In Pips. Set to big negative value like -10 to immediately trigger. Any positive amount as profit achievement.
extern double        TS_Away = 20;                      // In Pips. StopLoss away from the current price.
extern double        TS_Move = 0;                       // In Pips. e.g. for set it as 5 pips, The new stoploss will be 5 pips away from the previous stoploss, default 0 advances every movement.


//+------------------------------------------------------------------+
//| Trail Stop @http://kolier.li @v2.0                               |
//+------------------------------------------------------------------+
void trailStop()
  {
   int ticket;
   string gv_name;
   double ts_points = pips2Points(TS_Pips)*Point;
   double ts_movingrange = pips2Points(TS_MovingRange)*Point;
   double ts_start = pips2Points(TS_StartPips)*Point;
   double stoploss_order;
   double ask_s, bid_s;
   
   for(int i=0; i<OrdersTotal(); i++) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      ask_s = MarketInfo(OrderSymbol(), MODE_ASK);
      bid_s = MarketInfo(OrderSymbol(), MODE_BID);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) {
         if(!TS_StealthMode) {
            stoploss_order = OrderStopLoss();
         }
         else {
            stoploss_order = GlobalVariableGet(AdvisorName+"_ts_stoploss_"+OrderTicket());
            
            if(stoploss_order>0) {
               if(OrderType()==OP_BUY && bid_s<=stoploss_order) {
                  OrderClose(OrderTicket(), OrderLots(), bid_s, Slippage, White);
                  GlobalVariableDel(AdvisorName+"_ts_stoploss_"+OrderTicket());
                  continue;
               }
               else if(OrderType()==OP_SELL && ask_s>=stoploss_order) {
                  OrderClose(OrderTicket(), OrderLots(), ask_s, Slippage, White);
                  GlobalVariableDel(AdvisorName+"_ts_stoploss_"+OrderTicket());
                  continue;
               }
            }
         }

         if(OrderType()==OP_BUY
            && ((bid_s-ts_points>stoploss_order && stoploss_order>0) || stoploss_order==0)
            && bid_s-OrderOpenPrice()>=ts_start
            && ((bid_s-stoploss_order>ts_points+ts_movingrange && stoploss_order>0) || stoploss_order==0)
         ) {
            if(!TS_StealthMode) {
               OrderModify(OrderTicket(), OrderOpenPrice(), bid_s-ts_points, OrderTakeProfit(), 0, Blue);
            }
            else {
               GlobalVariableSet(AdvisorName+"_ts_stoploss_"+OrderTicket(), bid_s-ts_points);
            }
         }
         else if(OrderType()==OP_SELL
            && ((ask_s+ts_points<stoploss_order && stoploss_order>0) || stoploss_order==0)
            && OrderOpenPrice()-ask_s>=ts_start
            && ((stoploss_order-ask_s>ts_points+ts_movingrange && stoploss_order>0) || stoploss_order==0)
         ) {
            if(!TS_StealthMode) {
               OrderModify(OrderTicket(), OrderOpenPrice(), ask_s+ts_points, OrderTakeProfit(), 0, Orange);
            }
            else {
               GlobalVariableSet(AdvisorName+"_ts_stoploss_"+OrderTicket(), ask_s+ts_points);
            }
         }
      }
   }
   
   // Clear the un-used Global Variables
   for(i=0; i<GlobalVariablesTotal(); i++) {
      gv_name = GlobalVariableName(i);
      if(StringSubstr(gv_name, 0, 13+StringLen(AdvisorName))==AdvisorName+"_ts_stoploss_") {
         ticket = StrToInteger(StringSubstr(gv_name, 13+StringLen(AdvisorName)));
         OrderSelect(ticket, SELECT_BY_TICKET);
         if(OrderCloseTime()>0) {
            GlobalVariableDel(gv_name);
         }
      }
   }
  }