#property copyright "Copyright 2016, 19 October"
#property link      "Teemofey@inbox.ru"
#property version   "3.5"
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Variables                                   |
//+------------------------------------------------------------------+
input int time_pass=5; //Время работы скрипта в минутах
input string magicX="0"; //Список разрешенных меджиков через пробел
input int flag_point=0;   //Закрывать ордер(1=процентах,0=пунктах)
input int percent=20;   //Часть закрытия ордеров в процентах 
input double pointX=0.01;   //Часть закрытия ордеров в пунтктах
input int profit=30;      //Проверка профита в пунтктах
input int type_graph=1; //График (1=текущий,0=только разрешенные,-1=все кроме запрещенных)
input string allowed="GBPUSD"; //Список разрешенных пар
input string not_allowed="USDJPY"; //Список запрещенных пар
input bool flag_alert=false; //Алерт
input int type_order=0; //Проверка ордеров(-1=только SELL,0=все,1=только BUY)

bool  ArraySearch(int zed,int &FunMagic[10],int a) 
{
   bool b=false;
   for(int i=0;i<=zed;i++)
   {
      if( FunMagic[i]==a)
      b=true;
   }
   return b;
}
   
bool  SymbolCheck() 
{ 
   //Print(not_allowed,"_",OrderSymbol());
   switch (type_graph)
   {
      case 1: 
         return OrderSymbol()==Symbol(); 
      case 0:
         if(StringFind(allowed,OrderSymbol())==-1)
            return false;
         else
            return true;
      case -1:
         if(StringFind(not_allowed,OrderSymbol())==-1)
            return true;
         else
            return false;
      default:
         return false;
   }
}
   
void OnStart()
{
   int flag=0;
   int time=0;
   int ticket=0;
   int slippage=100;
   double ask, bid, open;
   double point;
   int magic[10];
   //StringGetChar(str,i);
   string str=magicX;
   //Print(str," ",StringLen(str));
   for(int i=0; i<=9; i++) 
   {
      magic[i]=1;
   }
   string a="";
   int z=0;
   for (int i=0; i<=StringLen(str); i++) 
   {
      magic[z]=StrToInteger(a);
      if((str[i]==' ')||(str[i]==','))
      {
         z++;
         a="";
      }
      else
      {
         //stringsubstr
         //Print("a=",a," str[i]=",StringSubstr(str,i)," CharToStr(str[i])=",CharToStr(StringToInteger(str[i])));
         StringAdd(a,StringSubstr(str,i));
      } 
   }
   //ArraySort(mas);
   while(time<time_pass*60&&flag==0)
   {
      for (int i=OrdersTotal()-1; i>=0; i--) 
      {
         if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true) 
         {
         //Print(ArraySearch(OrderMagicNumber(),magic)," ",OrderMagicNumber());
            point=MarketInfo(OrderSymbol(),MODE_POINT);
            bid=MarketInfo(OrderSymbol(),MODE_BID);
            ask=MarketInfo(OrderSymbol(),MODE_ASK);
            open=OrderOpenPrice();
            if ((OrderType()==OP_BUY)&&(type_order>-1)&&(SymbolCheck())&&(magicX=="0"||ArraySearch(z,magic,OrderMagicNumber())))
            {
               //Print(OrderTicket()," ",(bid-open)/point);
               if (bid-open>point*profit)
               {
                  flag=1; 
                  if(flag_point==1)
                     ticket=OrderClose(OrderTicket(),OrderLots()*percent/100, bid,slippage, clrNONE);    
                  if(flag_point==0)
                     ticket=OrderClose(OrderTicket(),pointX, bid,slippage, clrNONE);
               }
               if (ticket==-1) 
                  Print ("Error: ",  GetLastError());
                  
            }
            if ((OrderType()==OP_SELL)&&(type_order<1)&&(SymbolCheck())&&(magicX=="0"||ArraySearch(z,magic,OrderMagicNumber())))
            {
               //Print(OrderTicket()," ",(open-ask)/point);
               if (open-ask>point*profit) 
               {
                  flag=1;                             
                  if(flag_point==1)
                     ticket=OrderClose(OrderTicket(),OrderLots()*percent/100, ask, slippage, clrNONE);   
                  if(flag_point==0)
                     ticket=OrderClose(OrderTicket(),pointX, ask, slippage, clrNONE); 
               }
               if (ticket==-1) Print ("Error: ",  GetLastError());
            }  
         }
      }
   //Print("time=",time);
   Sleep(1000); 
   time++;
   }
   if(flag==1)
      Print("Время работы Close_Part_Order_3_0 ",time," секунд (",time/60," минут). Ордер был закрыт");
   else
      Print("Время работы Close_Part_Order_3_0 ",time," секунд (",time/60," минут). Ордер не был закрыт");
   if(flag_alert) 
   {
      if(flag==1)
         Alert("Время работы Close_Part_Order_3_0 ",time," секунд (",time/60," минут). Ордер был закрыт");
      else
         Alert("Close_Part_Order_3_0 ордер не был закрыт");
   }
}

