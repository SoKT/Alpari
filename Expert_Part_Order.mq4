#property copyright "Copyright 2016, 22 October"
#property link      "Teemofey@inbox.ru"
#property version   "1.1"
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
