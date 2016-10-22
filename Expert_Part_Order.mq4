//+------------------------------------------------------------------+
//|                                            Expert_Part_Order.mq4 |
//|                                       Copyright 2016, 21 October |
//|                                                Teemofey@inbox.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, 21 October"
#property link      "Teemofey@inbox.ru"
#property version   "1.00"
#property strict
string obj_name[10]; 
int OnInit()
  {
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
void OnTimer()
  {
  }