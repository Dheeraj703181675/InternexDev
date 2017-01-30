public class Interestcalculation {
    public void interest_calculationFunctionality(List<Client_Account__c> Scope)
    {
        set<id> ClientAccountID = new Set<Id>();
        BusinessTransactionDate__c bt = BusinessTransactionDate__c.getOrgDefaults();
        system.debug('==> '+ bt.Business_Transaction_Date__c);
        integer month = bt.Business_Transaction_Date__c.month();
        integer Year = bt.Business_Transaction_Date__c.year();
        map<Id,Client_Account__c> Clientaccount_map = new Map<Id,Client_Account__c>();
        set<string> ClientAccount_Index_set = new Set<string>();
        
        List<Interest_Calculation_Status__c> Intereststatus_list = new List<Interest_Calculation_Status__c>();
        
        for(Client_Account__c CA : scope)
        {
            ClientAccountID.add(CA.Id);
            Clientaccount_map.put(CA.Id,CA);
            if(CA.Rate_Type__c == 'Floating')
            {
                ClientAccount_Index_set.add(CA.Index__c);
            }
        }
        
        map<String,Pricing__c> Index_Price_Map = new map<String,Pricing__c>();
        for(Pricing__c Price : [Select id,Date__c,Index__c,Rate__c from Pricing__c where Date__c =: bt.Business_Transaction_Date__c and Index__C in : ClientAccount_Index_set])
        {
            Index_Price_Map.put(String.valueof(Price.Index__c),Price);
        }
   /*     boolean Processing = True;
        if(ClientAccount_Index_set.size() > 0 )
        {
            if(Index_Price_Map == NULL || Index_Price_Map.keySet().size() == 0)
            {
               
            }
            else if(Index_Price_Map.keySet().size() > 0)
            {
                for(string Index : ClientAccount_Index_set)
                {
                    if(!Index_Price_Map.containsKey(Index))
                    {
                        Processing = False;
                    }
                }
            }
        } */
        
        Delete[select id,Client_Account__c from Interest_Calculation_Status__c where Business_Transaction_Date__c =: bt.Business_Transaction_Date__c and Client_Account__c in : ClientAccountID];
        Map<string,Interest_Calculation_Status__c> ClientAccount_interestStatusmap = new Map<string,Interest_Calculation_Status__c>();
        for(Client_Account__c CA : scope)
        {
            Interest_Calculation_Status__c ICS = New Interest_Calculation_Status__c();
            ICS.Business_Transaction_Date__c = bt.Business_Transaction_Date__c;
            ICS.Client_Account__c = (Id)CA.id;
            ICS.Status__c = 'Failed';
            Intereststatus_list.add(ICS);
            ClientAccount_interestStatusmap.put(CA.id,ICS);
        }

        system.debug('==>m '+month);system.debug('==>year '+Year);system.debug('==>ClientAccountID '+ClientAccountID);
            Map<string,Monthly_Interest_Application__c> monthlyInterestMap = new Map<string,Monthly_Interest_Application__c>();
            for(Monthly_Interest_Application__c MIA : [Select id,Active__c,Applied__c,Date__c,Interest__c,Interest_Base__c,Interest_Base_Rate__c,Max_Date__c,
                                                       Interest_Rate_Applied__c,Interest_Spread__c,Month1__c,Monthly_Product__c,Year1__c,Client_Account__c 
                                                       from Monthly_Interest_Application__c where Client_Account__c in : ClientAccountID and Month1__c =: month and Year1__c =: Year])
            {
                monthlyInterestMap.put(MIA.Client_Account__c, MIA);
            }
            system.debug('M1===> '+ monthlyInterestMap);
            List<Monthly_Interest_Application__c> MI_LIST = new List<Monthly_Interest_Application__c>();
            List<Daily_Interest_Accrual__c> DI_LIST = new List<Daily_Interest_Accrual__c>();
            if(monthlyInterestMap != NULL && monthlyInterestMap.keySet().size() > 0)
            {
                for(Client_Account__c CA : scope)
                {
                    if(!monthlyInterestMap.containsKey(CA.ID))
                    {
                        Monthly_Interest_Application__c MI  = new Monthly_Interest_Application__c();
                        MI.Active__c = True;
                        MI.Applied__c = False;
                        MI.Client_Account__c = CA.Id;
                        MI.Date__c =  bt.Business_Transaction_Date__c;
                        MI_LIST.add(MI);
                    }
                }
            }
            else
            {
                for(Client_Account__c CA : scope)
                {
                    Monthly_Interest_Application__c MI  = new Monthly_Interest_Application__c();
                    MI.Active__c = True;
                    MI.Applied__c = False;
                    MI.Client_Account__c = CA.Id;
                    MI.Date__c =  bt.Business_Transaction_Date__c;
                    MI_LIST.add(MI);
                }
            }
            
            if(MI_LIST.size() > 0)
            {
                try
                {
                    insert MI_LIST;
                }catch(exception e){ system.debug('===>exception '+ e); }
            }
            
            LIST<Monthly_Interest_Application__c> MonthlyInterestList = new LIST<Monthly_Interest_Application__c>();
            MonthlyInterestList.addAll(MI_LIST);
            MonthlyInterestList.addAll(monthlyInterestMap.values());
            system.debug('==>MIL '+MonthlyInterestList);
          
            List<Daily_Interest_Accrual__c> DailyInterestList = [Select id,Date__c,Client_Account__c,Monthly_Interest_Application__c from Daily_Interest_Accrual__c where Date__c =: bt.Business_Transaction_Date__c];
            system.debug('DailyInterestList  '+DailyInterestList);
            
            if(DailyInterestList.size() > 0)
            {
                for(Daily_Interest_Accrual__c DI : DailyInterestList)
                {
                    for(integer i = 0;i < MonthlyInterestList.size();i++)
                    {
                        if(DI.Monthly_Interest_Application__c == MonthlyInterestList[i].Id)
                        {
                            MonthlyInterestList.remove(i);
                            break;
                        }
                    }
                    if(ClientAccount_interestStatusmap != NULL && ClientAccount_interestStatusmap.get(DI.Client_Account__c) != NULL)
                    {
                        system.debug('==> 34 '+ ClientAccount_interestStatusmap.get(DI.Client_Account__c).Status__c);
                        ClientAccount_interestStatusmap.get(DI.Client_Account__c).Status__c = 'Successful';
                    }
                }
            }
            system.debug('MonthlyInterestList  '+MonthlyInterestList.size());
            map<String,string> Map_DailyCalculation_clientacccount = new Map<String,string>();
            for(Monthly_Interest_Application__c MIA : MonthlyInterestList)
            {
                if(Clientaccount_map != NULL && Clientaccount_map.get(MIA.Client_Account__c) != NULL)
                {system.debug('==>10');system.debug('==>Clientaccount_map '+Clientaccount_map);
                 if(Clientaccount_map.get(MIA.Client_Account__c).Rate_Type__c == 'Fixed')
                 {system.debug('==>11');
                  //       if(MIA.Max_Date__c == NULL || ( MIA.Max_Date__c != NULL && MIA.Max_Date__c == bt.Business_Transaction_Date__c))
                  //       {
                  system.debug('==>12');
                  Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
                  DI.Active__c = True;
                  DI.Applied__c = FALSE;
                  DI.Date__c = bt.Business_Transaction_Date__c;
                  DI.Monthly_Interest_Application__c = MIA.Id;
                  DI.FIU_Outstanding__c = Clientaccount_map.get(MIA.Client_Account__c).FIU_Outstanding__c;
                  DI.Interest_Base__c = Clientaccount_map.get(MIA.Client_Account__c).Index__c;
                  DI.Method__c = Clientaccount_map.get(MIA.Client_Account__c).Method__C;
                  DI.Non_performing_asset__c = Clientaccount_map.get(MIA.Client_Account__c).Non_performing_asset__c;
                  DI.Interest_Base_Rate__c = Clientaccount_map.get(MIA.Client_Account__c).Rate__c;
                  DI.Commitment__c =  Clientaccount_map.get(MIA.Client_Account__c).Commitment__c;
                  DI.Commitment_rate__c = Clientaccount_map.get(MIA.Client_Account__c).Commitment_rate__c;
                  DI.Funding_Limit__c = Clientaccount_map.get(MIA.Client_Account__c).Funding_Limit__c;
                  DI.Interest_Spread__c = 0;
                  DI.MinCommitmentAmount__c = Clientaccount_map.get(MIA.Client_Account__c).MinCommitmentAmount__c;
                  DI.Invoice_Amount__c = Clientaccount_map.get(MIA.Client_Account__c).Invoice_Amount__c;
                  DI.Ineligibles_Amount__c = Clientaccount_map.get(MIA.Client_Account__c).Ineligibles_Amount__c;
                  DI.Eligible_For_Funding__c = Clientaccount_map.get(MIA.Client_Account__c).Eligible_For_Funding__c;
                  DI.Gross_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Sum_of_Net_Availability__c;
                  DI.Net_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Net_Availability__c;
                  if(bt != NULL )
                      DI.Business_Transaction_Date__c = bt.Business_Transaction_Date__c;
                  Map_DailyCalculation_clientacccount.put(DI.Monthly_Interest_Application__c,Clientaccount_map.get(MIA.Client_Account__c).Id);
                  DI_LIST.add(DI);
                  //   }
                  /*   else
{
Integer NoofDays = MIA.Max_Date__c.daysBetween(bt.Business_Transaction_Date__c);
for(Integer j = math.abs(NoofDays) ; j >= 0 ; j--)
{
Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
DI.Active__c = True;
DI.Applied__c = FALSE;
DI.Date__c = bt.Business_Transaction_Date__c.addDays(-j);
DI.Monthly_Interest_Application__c = MIA.Id;
DI.FIU_Outstanding__c = Clientaccount_map.get(MIA.Client_Account__c).FIU_Outstanding__c;
DI.Interest_Base__c = Clientaccount_map.get(MIA.Client_Account__c).Index__c;
DI.Method__c = Clientaccount_map.get(MIA.Client_Account__c).Method__C;
DI.Non_performing_asset__c = Clientaccount_map.get(MIA.Client_Account__c).Non_performing_asset__c;
DI.Interest_Base_Rate__c = Clientaccount_map.get(MIA.Client_Account__c).Rate__c;
DI.Commitment__c =  Clientaccount_map.get(MIA.Client_Account__c).Commitment__c;
DI.Commitment_rate__c = Clientaccount_map.get(MIA.Client_Account__c).Commitment_rate__c;
DI.Funding_Limit__c = Clientaccount_map.get(MIA.Client_Account__c).Funding_Limit__c;
DI.Interest_Spread__c = 0;
DI.MinCommitmentAmount__c = Clientaccount_map.get(MIA.Client_Account__c).MinCommitmentAmount__c;
DI.Invoice_Amount__c = Clientaccount_map.get(MIA.Client_Account__c).Invoice_Amount__c;
DI.Ineligibles_Amount__c = Clientaccount_map.get(MIA.Client_Account__c).Ineligibles_Amount__c;
DI.Eligible_For_Funding__c = Clientaccount_map.get(MIA.Client_Account__c).Eligible_For_Funding__c;
DI.Gross_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Gross_Availability__c;
DI.Net_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Net_Availability__c;
if(bt != NULL )
DI.Business_Transaction_Date__c = bt.Business_Transaction_Date__c;
DI_LIST.add(DI);
system.debug('===> '+ DI_LIST);
}
}*/
                 }
                 else
                 {system.debug('==>13');
                  if( Clientaccount_map.get(MIA.Client_Account__c).Index__c != NULL)
                  {
                      if(Index_Price_Map != NULL && Index_Price_Map.get(String.valueOf(Clientaccount_map.get(MIA.Client_Account__c).Index__c)) != NULL)
                      {
                          Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
                          DI.Active__c = True;
                          DI.Applied__c = FALSE;
                          DI.Date__c = bt.Business_Transaction_Date__c;
                          DI.Monthly_Interest_Application__c = MIA.Id;
                          DI.FIU_Outstanding__c = Clientaccount_map.get(MIA.Client_Account__c).FIU_Outstanding__c;
                          DI.Interest_Base__c = Clientaccount_map.get(MIA.Client_Account__c).Index__c;
                          DI.Method__c = Clientaccount_map.get(MIA.Client_Account__c).Method__C;
                          DI.Non_performing_asset__c = Clientaccount_map.get(MIA.Client_Account__c).Non_performing_asset__c;
                          DI.Interest_Spread__c = Clientaccount_map.get(MIA.Client_Account__c).Spread__c;
                          DI.Commitment__c =  Clientaccount_map.get(MIA.Client_Account__c).Commitment__c;
                          DI.Commitment_rate__c = Clientaccount_map.get(MIA.Client_Account__c).Commitment_rate__c;
                          DI.Funding_Limit__c = Clientaccount_map.get(MIA.Client_Account__c).Funding_Limit__c;
                          DI.MinCommitmentAmount__c = Clientaccount_map.get(MIA.Client_Account__c).MinCommitmentAmount__c;
                          DI.Invoice_Amount__c = Clientaccount_map.get(MIA.Client_Account__c).Invoice_Amount__c;
                          DI.Ineligibles_Amount__c = Clientaccount_map.get(MIA.Client_Account__c).Ineligibles_Amount__c;
                          DI.Eligible_For_Funding__c = Clientaccount_map.get(MIA.Client_Account__c).Eligible_For_Funding__c;
                          DI.Gross_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Sum_of_Net_Availability__c;
                          DI.Net_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Net_Availability__c;
                          if(bt != NULL )
                              DI.Business_Transaction_Date__c = bt.Business_Transaction_Date__c;
                          DI.Interest_Base_Rate__c = Index_Price_Map.get(String.valueOf(Clientaccount_map.get(MIA.Client_Account__c).Index__c)).Rate__c;
                          Map_DailyCalculation_clientacccount.put(DI.Monthly_Interest_Application__c,Clientaccount_map.get(MIA.Client_Account__c).Id);
                          DI_LIST.add(DI);
                      }
                  }
                 }
                }
                // DI_LIST.add(DI);
            }
        try
        {system.debug('===> '+ DI_LIST);
         insert DI_LIST;
         for(Daily_Interest_Accrual__c DIA: DI_LIST)
         {
             if(ClientAccount_interestStatusmap != null && ClientAccount_interestStatusmap.get(Map_DailyCalculation_clientacccount.get(DIA.Monthly_Interest_Application__c)) != NULL)
                 ClientAccount_interestStatusmap.get(Map_DailyCalculation_clientacccount.get(DIA.Monthly_Interest_Application__c)).Status__c = 'Successful';
         }
         upsert ClientAccount_interestStatusmap.values();
        }Catch(Exception e){system.debug('==>exception '+ e);}
        
        system.debug('ClientAccountID.size() => '+ClientAccountID.size());
      /*  IF(ClientAccount_interestStatusmap.keySet().size() > 0)
        {integer i = 0;
            for(Interest_Calculation_Status__c ICS : ClientAccount_interestStatusmap.values())
            {
                if(ICS.Status__c == 'Successful')
                {
                    i++;
                }
            }
         system.debug('i => '+ i);
         if(i == ClientAccountID.size())
         {
             bt.Business_Transaction_Date__c =  bt.Business_Transaction_Date__c.addDays(1);
            update bt;
         }
        }*/
    }
}