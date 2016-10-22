#property copyright "Copyright 2016, 19 October"
#property link      "Teemofey@inbox.ru"
#property version   "3.4"
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Variables                                   |
//+------------------------------------------------------------------+
input int time_pass=5; //����� ������ ������� � �������
input string magicX="0"; //������ ����������� �������� ����� ������
input int flag_point=0;   //��������� �����(1=���������,0=�������)
input int percent=20;   //����� �������� ������� � ��������� 
input double pointX=0.01;   //����� �������� ������� � ��������
input int profit=30;      //�������� ������� � ��������
input int type_graph=1; //������ (1=�������,0=������ �����������,-1=��� ����� �����������)
input string allowed="GBPUSD"; //������ ����������� ���
input string not_allowed="USDJPY"; //������ ����������� ���
input bool flag_alert=false; //�����
input int type_order=0; //�������� �������(-1=������ SELL,0=���,1=������ BUY)

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
      Print("����� ������ Close_Part_Order_3_0 ",time," ������ (",time/60," �����). ����� ��� ������");
   else
      Print("����� ������ Close_Part_Order_3_0 ",time," ������ (",time/60," �����). ����� �� ��� ������");
   if(flag_alert) 
   {
      if(flag==1)
         Alert("����� ������ Close_Part_Order_3_0 ",time," ������ (",time/60," �����). ����� ��� ������");
      else
         Alert("Close_Part_Order_3_0 ����� �� ��� ������");
   }
}

