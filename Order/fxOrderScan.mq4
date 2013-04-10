
//+------------------------------------------------------------------+
//| Universal Constants                                              |
//+------------------------------------------------------------------+
#define TRADEPEND  -1
#define TRADEALL   0
#define TRADETRADE 1
#define TRADEBUY   1
#define TRADESELL  -1

//+------------------------------------------------------------------+
//| trailStop Target Points                                          |
//| Scan Trades @http://kolier.li @v1.0                              |
//| @params                                                          |
//|   string order_type TRADEALL|TRADETRADE|TRADEPEND                |
//|   string order_dir TRADEALL|TRADEBUY|TRADESELL                   |
//| @return                                                          |
//|   int orders_number                                              |
//+------------------------------------------------------------------+
int scanTrades(int order_type=TRADEALL, int order_dir=TRADEALL)
  {
   int orders_total = OrdersTotal();
   int orders_number = 0;
   for(int i=0; i<orders_total; i++)
   {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderMagicNumber() == Magic && OrderSymbol() == Symbol()) {
         switch(order_type) {
            case TRADEALL:
               orders_number++;
               break;
            case TRADETRADE:
               if(OrderType()<=OP_SELL) {
                  orders_number = _scanTradesDir(order_dir, orders_number);
               }
               break;
            case TRADEPEND:
               if(OrderType()>OP_SELL) {
                  orders_number = _scanTradesDir(order_dir, orders_number);
               }
               break;
         }// switch
      }
   }
   return(orders_number);   
  }
  
int _scanTradesDir(int order_dir, int orders_number)
  {
      switch(order_dir) {
         case TRADEALL:
            orders_number++;
            break;
         case TRADEBUY:
            if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) {
               orders_number++;
            }
            break;
         case TRADESELL:
            if(OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) {
               orders_number++;
            }
            break;
      }// switch
      return(orders_number);
  }