/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   :   Daily and monthly Interest Calculations depend on the Client-Account data.
 */
global class InterestcalculationBatch implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        User_Freeze();
        String query = 'Select id,FIU_Outstanding__c,Non_performing_asset__c,Commitment__c,Commitment_rate__c,Funding_Limit__c,MinCommitmentAmount__c,';
          query = query+'Invoice_Amount__c,Sum_of_Net_Availability__c,Ineligibles_Amount__c,Eligible_For_Funding__c,Gross_Availability__c,Net_Availability__c,Index__c,Rate__c,Rate_Type__c,Method__c,Spread__c from Client_Account__c where Interest_Initiation_Flag__c = True Limit 49999 '; //where id = \''+'a0Y61000001MAWC'+'\'
        system.debug('==>query '+ query);
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Client_Account__c> scope) {  
  /*     set<id> ClientAccountID = new Set<Id>();
        BusinessTransactionDate__c bt = BusinessTransactionDate__c.getOrgDefaults();
        integer month = bt.Business_Transaction_Date__c.month();
        integer Year = bt.Business_Transaction_Date__c.year();
        map<Id,Client_Account__c> Clientaccount_map = new Map<Id,Client_Account__c>();
        set<Client_Account__c> ClientAccount_RateType_set = new Set<Client_Account__c>();
        for(Client_Account__c CA : scope)
        {
            ClientAccountID.add(CA.Id);
            Clientaccount_map.put(CA.Id,CA);
            if(CA.Rate_Type__c == 'Floating')
            {
                ClientAccount_RateType_set.add(CA);
            }
        }
        
        map<String,Pricing__c> Date_Price_Map = new map<String,Pricing__c>();
        if(ClientAccount_RateType_set.size() > 0)
        {
            for(Pricing__c Price : [Select id,Date__c,Index__c,Rate__c from Pricing__c where month__c =: month and Year__c =: Year])
            {
                Date_Price_Map.put(String.valueof(Price.Date__c)+String.valueof(Price.Index__c),Price);
            }
        }
        if(Date_Price_Map.size() > 0)
        {
            system.debug('==>m '+month);system.debug('==>year '+Year);system.debug('==>ClientAccountID '+ClientAccountID);
            Map<string,Monthly_Interest_Application__c> monthlyInterestMap = new Map<string,Monthly_Interest_Application__c>();
            for(Monthly_Interest_Application__c MIA : [Select id,Active__c,Applied__c,Date__c,Interest__c,Interest_Base__c,Interest_Base_Rate__c,Max_Date__c,
                                                       Interest_Rate_Applied__c,Interest_Spread__c,Month1__c,Monthly_Product__c,Year1__c,Client_Account__c 
                                                       from Monthly_Interest_Application__c where Client_Account__c in : ClientAccountID and Year1__c =: year and (Month1__c =: Month)])
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
                        MI.Date__c = Date.Today();
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
                    MI.Date__c = Date.Today();
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
            List<Monthly_Interest_Application__c> monthlyinterest_list_new = new List<Monthly_Interest_Application__c>();
            
            List<Daily_Interest_Accrual__c> DailyInterestList = [Select id,Date__c,Monthly_Interest_Application__c from Daily_Interest_Accrual__c where Date__c =: Date.today()];
            
            List<Aggregateresult> Priceaggrlist = [Select max(Date__c) dat,Index__c Index from Pricing__c where month__c =: month and Year__c =: Year group by Index__c];
            Map<String,Date> IndexDatemap = new Map<String,Date>();
            for(Aggregateresult aggr : Priceaggrlist)
            {
                IndexDatemap.put(String.valueOf(aggr.get('Index')),Date.valueOf(aggr.get('dat')));
            }
            system.debug('1'+IndexDatemap);
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
                }
            }
            system.debug('MonthlyInterestList  '+MonthlyInterestList.size());
            
            
            
            for(Monthly_Interest_Application__c MIA : MonthlyInterestList)
            {
                if(Clientaccount_map != NULL && Clientaccount_map.get(MIA.Client_Account__c) != NULL)
                {
                    if( Clientaccount_map.get(MIA.Client_Account__c).Rate_Type__c == 'Fixed')
                    {
                        if(MIA.Max_Date__c == NULL || ( MIA.Max_Date__c != NULL && MIA.Max_Date__c == Date.today()))
                        {system.debug('==>11');
                         Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
                         DI.Active__c = True;
                         DI.Applied__c = FALSE;
                         DI.Date__c = Date.TODAY();
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
                        }
                        else
                        {
                            Integer NoofDays = MIA.Max_Date__c.daysBetween(Date.today())-1;
                            for(Integer j = math.abs(NoofDays) ; j >= 0 ; j--)
                            {
                                Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
                                DI.Active__c = True;
                                DI.Applied__c = FALSE;
                                DI.Date__c = Date.TODAY().addDays(-j);
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
                        }
                    }
                    else
                    {system.debug('==>12');
                     if(Date_Price_Map != NULL && IndexDatemap != NULL && Clientaccount_map.get(MIA.Client_Account__c).Index__c != NULL)
                     {system.debug('==>13');
                      Date Dateforcalcultaion;
                      if(MIA.Max_Date__c == NULL)
                      {
                          Dateforcalcultaion = Date.today();
                      }
                      else
                      {
                          Dateforcalcultaion = MIA.Max_Date__c;
                      }
                      if(IndexDatemap.get(Clientaccount_map.get(MIA.Client_Account__c).Index__c) != NULL)
                      {      System.debug('==> Todate ' + IndexDatemap.get(Clientaccount_map.get(MIA.Client_Account__c).Index__c));
                       System.debug('==> MI Date ' +  Dateforcalcultaion);
                       Integer NoofDays = Dateforcalcultaion.daysBetween(IndexDatemap.get(Clientaccount_map.get(MIA.Client_Account__c).Index__c))-1;
                       System.debug('==> NoofDays ' + NoofDays);
                       for(Integer j = math.abs(NoofDays); j >= 0 ; j--)
                       {
                           Daily_Interest_Accrual__c DI = new Daily_Interest_Accrual__c();
                           DI.Active__c = True;
                           DI.Applied__c = FALSE;
                           DI.Date__c = Date.TODAY().addDays(-j);
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
                           DI.Gross_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Gross_Availability__c;
                           DI.Net_Availability__c = Clientaccount_map.get(MIA.Client_Account__c).Net_Availability__c;
                           if(bt != NULL )
                               DI.Business_Transaction_Date__c = bt.Business_Transaction_Date__c;
                           system.debug('123 '+ Date.TODAY().addDays(-j));system.debug('1234 '+ Date_Price_Map.get(String.valueof(Date.TODAY().addDays(-j))+String.valueOf(Clientaccount_map.get(MIA.Client_Account__c).Index__c)));
                           if(Date_Price_Map.get(String.valueof(Date.TODAY().addDays(-j))+String.valueOf(Clientaccount_map.get(MIA.Client_Account__c).Index__c)) != NULL)
                           {
                               DI.Interest_Base_Rate__c = Date_Price_Map.get(String.valueof(Date.TODAY().addDays(-j))+String.valueOf(Clientaccount_map.get(MIA.Client_Account__c).Index__c)).Rate__c;
                               DI_LIST.add(DI);
                           }
                           
                       }
                      }
                     }
                     
                    }
                }
                // DI_LIST.add(DI);
            }
            if(DI_LIST.size() > 0)
            {
                try
                {
                    system.debug('===> '+ DI_LIST);
                    insert DI_LIST;
                }Catch(Exception e){system.debug('==>exception '+ e);}
            }
            
        } */
        Interestcalculation ic = new Interestcalculation();
        ic.interest_calculationFunctionality(scope);
    }   
    
    global void finish(Database.BatchableContext BC){
        BusinessTransactionDate__c bt = BusinessTransactionDate__c.getOrgDefaults();
        system.debug('==> '+ bt.Business_Transaction_Date__c);
        map<string,Client_Account__c> Client_Account_map = new map<string,Client_Account__c>([Select id from Client_Account__c where Interest_Initiation_Flag__c = True Limit 49999]);
        List<Interest_Calculation_Status__c> Interest_Calculation_Status_List = [Select id,Business_Transaction_Date__c from Interest_Calculation_Status__c where Status__c = 'Successful' and Business_Transaction_Date__c =: bt.Business_Transaction_Date__c and Client_Account__c in : Client_Account_map.keySet() Limit 49999];
        
        system.debug('ICS status ==> '+ Interest_Calculation_Status_List.size());
        system.debug('Client_Account_List status ==> '+ Client_Account_map.keySet().size());
        if(Client_Account_map.keySet().size() == Interest_Calculation_Status_List.size())
        {
        //    BusinessTransactionDate__c bt = BusinessTransactionDate__c.getOrgDefaults();
            system.debug('==> '+ bt.Business_Transaction_Date__c);
            bt.Business_Transaction_Date__c = bt.Business_Transaction_Date__c.addDays(1);
            update bt;
            update[Select id,Is_Ineligible_updated__c,Debtor__c from akritiv__Transaction__c where Is_Ineligible_updated__c =: True ];
        }
         User_unFreeze();
            Consolidated_GL_Report QCB = new Consolidated_GL_Report();
            Database.executeBatch(QCB, 1);
    }
    public void User_Freeze()
    {
        system.debug('User has Freezed===>');
        User usr = [Select id,name from User where Name =: 'User Integration' limit 1];
        UserLogin usrlogin = [SELECT Id, UserId, IsFrozen, IsPasswordLocked, LastModifiedDate, LastModifiedById FROM UserLogin where UserId =: usr.Id limit 1];
            usrlogin.IsFrozen = True;
        try
        {
            Update usrlogin;
        }
        catch(exception e)
        {
            system.debug('Exception e => '+ e);
        }
    }
    Public Void User_unFreeze()
    {
         system.debug('User has Unfreezed===>');
        User usr = [Select id,name from User where Name =: 'User Integration' limit 1];
        UserLogin usrlogin = [SELECT Id, UserId, IsFrozen, IsPasswordLocked, LastModifiedDate, LastModifiedById FROM UserLogin where UserId =: usr.Id limit 1];
        usrlogin.IsFrozen = False;
        try
        {
            Update usrlogin;
        }
        catch(exception e)
        {
            system.debug('Exception e => '+ e);
        }
    }
}