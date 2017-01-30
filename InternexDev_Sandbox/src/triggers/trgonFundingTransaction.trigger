trigger trgonFundingTransaction on Funding_Transaction__c (before Insert,before update,after insert,after update,after Delete) {
    if(Trigger.IsAfter)
    {
        Set<Id>FundingRequestID_set = new Set<Id>();
        Set<String> TransactionIdSet = new Set<String>();
     //    Set<Id> ClientAccountId = new Set<Id>();
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(Funding_Transaction__c FT : Trigger.New)
            {
                FundingRequestID_set.add(FT.Funding_Request__c);
            }
        }
        if(Trigger.isDelete)
        {
            for(Funding_Transaction__c FT : Trigger.Old)
            {
                FundingRequestID_set.add(FT.Funding_Request__c);
            }
        }
        
        Map<String,string> Case_and_Client_Account_Map = new Map<String,string>();
        Map<String,Case> CaseMap = new Map<String,Case>();
        
        for(Case cas : [Select id,CaseNumber,Funding_Transaction_Count__c,Funding_Requested__c,Funding_Amount__c,Client_Account__c,Client_Account__r.Funding_Limit__c,Funds_Released__c,Draw_Fee__c,Origination_Fee__c,Applied_Draw_Fee__c,Applied_Origination_Fee__c,Wire_Mode__c,Wire_Fee__c from case where id in : FundingRequestID_set])
        {
            Case_and_Client_Account_Map.put(Cas.id, cas.Client_Account__c);
            CaseMap.put(Cas.id,cas);
            //    ClientAccountId.add(cas.Client_Account__c);
        }
         //    system.debug('1 > '+Case_and_Client_Account_Map);
         Map<String,Client_Account__c> Client_Account_Map = new Map<String,Client_Account__c>([Select id,Funding_Transaction_Count__c,Sum_of_Origination_Fees__c,Sum_of_Draw_Fees__c,Partner_Origination_Fee_Amount__c,Partner_Draw_Fee_Amount__c,
                                                                                              FIU_Outstanding__c from Client_Account__c where id in : Case_and_Client_Account_Map.values()]);
      //  system.debug('123 > '+Client_Account_Map);

        for(AggregateResult PM : [select count(ID) FTC,SUM(Applied_Origination_Fee__c) SOF,sum(Applied_Draw_Fee__c) SOD ,sum(Applied_Partner_Origination_Fee__c) SPOF , sum(Applied_Partner_Draw_Fee__c) SPDF ,Funding_Request__r.Client_Account__c CA from Funding_Transaction__c where Funding_Request__r.Client_Account__c IN : Case_and_Client_Account_Map.values() group by Funding_Request__r.Client_Account__c])
        {
            if(Client_Account_Map.containsKey((Id)PM.get('CA')))
            {
                Client_Account_Map.get((Id)PM.get('CA')).Sum_of_Origination_Fees__c   = (Double)PM.get('SOF');
                Client_Account_Map.get((Id)PM.get('CA')).Sum_of_Draw_Fees__c          = (Double)PM.get('SOD');
                Client_Account_Map.get((Id)PM.get('CA')).Partner_Origination_Fee_Amount__c = (Double)PM.get('SPOF');
                Client_Account_Map.get((Id)PM.get('CA')).Partner_Draw_Fee_Amount__c          = (Double)PM.get('SPDF');
                Client_Account_Map.get((Id)PM.get('CA')).Funding_Transaction_Count__c = (Double)PM.get('FTC');
            }
        }
        try{
            update Client_Account_Map.values();
        }Catch(exception e){system.debug('Client Account Exception e'+e);}
        
        if(Trigger.isInsert || Trigger.isUpdate)
        {
          /*  if(Trigger.isInsert)
            {
                for(Funding_Transaction__c FT : Trigger.New)
                {
                    if(Case_and_Client_Account_Map != NULL && Case_and_Client_Account_Map.get(FT.Funding_Request__c) != NULL)
                    {
                        if(Client_Account_Map != NULL && Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)) != NULL)
                        {
                            if(Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c == NULL)
                            {
                                Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c = 0;
                                //system.debug('2 > '+Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c);
                            }
                            else
                            {
                                Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c += 1;
                                //  system.debug('3 > '+Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c);
                            }
                            if(Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Draw_Fees__c == NULL)
                            {
                                Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Draw_Fees__c = 0;
                            }
                            else
                            {system.debug('Applied Draw Fee==> '+ FT.Applied_Draw_Fee__c);
                                Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Draw_Fees__c += FT.Applied_Draw_Fee__c;
                            }
                            if(Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Origination_Fees__c == NULL)
                            {
                                Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Origination_Fees__c = 0;
                            }
                            else
                            {system.debug('Applied Draw Fee==> '+ FT.Applied_Origination_Fee__c);
                                Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Origination_Fees__c += FT.Applied_Origination_Fee__c;
                            }
                        }
                    } 
                }
            } */

            try
            {
               /* if(Trigger.isInsert)
                {
                    update Client_Account_Map.values();
                }*/
                if(Trigger.isUpdate)
                {
                    set<String> Reference_set = new Set<String>();
                    for(Funding_Transaction__c FT : Trigger.New)
                    {
                        Reference_set.add(FT.Id);
                    }
                    Try{
                        Delete [Select Id from FIU_Report__c where Reference__c in : Reference_set];
                    }catch(Exception e){system.debug('Exception ==> '+e);}
                }
                
                List<FIU_Report__c> FIU_Report_list = new List<FIU_Report__c>();
                FIU_Report__c FR;
                for(Funding_Transaction__c FT : Trigger.New)
                {
                    if(Case_and_Client_Account_Map != NULL && Case_and_Client_Account_Map.get(FT.Funding_Request__c) != NULL)
                    {
                        if(Client_Account_Map != NULL && Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)) != NULL)
                        {
                            system.debug('FIU Closed Value------> '+Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).FIU_Outstanding__c);
                            
                            Double FIU_Prior_Value = Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).FIU_Outstanding__c;
                           
                            if(Trigger.isUpdate && CaseMap != NULL && CaseMap.get(FT.Funding_Request__c) != NULL)
                            {
                                FIU_Prior_Value -= CaseMap.get(FT.Funding_Request__c).Funding_Amount__c;
                            }
                            
                            FR = new FIU_Report__c();
                            FR.Transaction_Name__c = 'Funding transaction';
                            FR.Transaction_ID__c = FT.Name;
                            FR.Date__c = date.newinstance(FT.Funding_Transaction_Date__c.year(), FT.Funding_Transaction_Date__c.month(), FT.Funding_Transaction_Date__c.day());
                        //    FR.Date__C =  FT.Funding_Transaction_Date__c;
                            FR.Created_Time__c = System.now();
                            FR.Funding__c = FT.Funds_to_be_Transferred__c;
                            FR.Reference__c = FT.id;
                            FR.Client_Account__c = Case_and_Client_Account_Map.get(FT.Funding_Request__c);
                            FR.Opening_FIU_Balance__c = FIU_Prior_Value;
                            FR.Closing_FIU_Balance__c = FIU_Prior_Value + FT.Funds_to_be_Transferred__c;
                            FIU_Prior_Value = FIU_Prior_Value + FT.Funds_to_be_Transferred__c;
                            FIU_Report_list.add(FR);
                            if(CaseMap != NULL && CaseMap.get(FT.Funding_Request__c) != NULL)
                            {
                                if(CaseMap.get(FT.Funding_Request__c).Origination_Fee__c == True)
                                {
                                    FR = new FIU_Report__c();
                                    FR.Transaction_Name__c = 'Origination fee recovered';
                                    FR.Transaction_ID__c = FT.Name;
                                    FR.Date__C = date.newinstance(FT.Funding_Transaction_Date__c.year(), FT.Funding_Transaction_Date__c.month(), FT.Funding_Transaction_Date__c.day());
                            //      FR.Date__C =  FT.Funding_Transaction_Date__c;
                                    FR.Created_Time__c = System.now();
                                    FR.Funding__c = CaseMap.get(FT.Funding_Request__c).Applied_Origination_Fee__c;
                                    FR.Reference__c = FT.id;
                                    FR.Client_Account__c = Case_and_Client_Account_Map.get(FT.Funding_Request__c);
                                    FR.Opening_FIU_Balance__c = FIU_Prior_Value;
                                    FR.Closing_FIU_Balance__c = FIU_Prior_Value + CaseMap.get(FT.Funding_Request__c).Applied_Origination_Fee__c;
                                    FIU_Prior_Value = FIU_Prior_Value + CaseMap.get(FT.Funding_Request__c).Applied_Origination_Fee__c;
                                    FIU_Report_list.add(FR);
                                }

                                if(CaseMap.get(FT.Funding_Request__c).Draw_Fee__c == True)
                                {
                                    FR = new FIU_Report__c();
                                    FR.Transaction_Name__c = 'Draw fee recovered';
                                    FR.Transaction_ID__c = FT.Name;
                                    FR.Date__C = date.newinstance(FT.Funding_Transaction_Date__c.year(), FT.Funding_Transaction_Date__c.month(), FT.Funding_Transaction_Date__c.day());
                            //      FR.Date__C =  FT.Funding_Transaction_Date__c;
                                    FR.Created_Time__c = System.now();
                                    FR.Funding__c = CaseMap.get(FT.Funding_Request__c).Applied_Draw_Fee__c;
                                    FR.Reference__c = FT.id;
                                    FR.Client_Account__c = Case_and_Client_Account_Map.get(FT.Funding_Request__c);
                                    FR.Opening_FIU_Balance__c = FIU_Prior_Value;
                                    FR.Closing_FIU_Balance__c = FIU_Prior_Value + CaseMap.get(FT.Funding_Request__c).Applied_Draw_Fee__c;
                                    FIU_Prior_Value = FIU_Prior_Value + CaseMap.get(FT.Funding_Request__c).Applied_Draw_Fee__c;
                                    FIU_Report_list.add(FR);
                                }

                                if(CaseMap.get(FT.Funding_Request__c).Wire_Mode__c == True && CaseMap.get(FT.Funding_Request__c).Wire_Fee__c != NULL) 
                                {
                                    FR = new FIU_Report__c();
                                    FR.Transaction_Name__c = 'Wire fee recovered';
                                    FR.Transaction_ID__c = FT.Name;
                                    FR.Date__C = date.newinstance(FT.Funding_Transaction_Date__c.year(), FT.Funding_Transaction_Date__c.month(), FT.Funding_Transaction_Date__c.day());
                           //         FR.Date__C =  FT.Funding_Transaction_Date__c;
                                    FR.Created_Time__c = System.now();
                                    FR.Funding__c = CaseMap.get(FT.Funding_Request__c).Wire_Fee__c;
                                    FR.Reference__c = FT.id;
                                    FR.Client_Account__c = Case_and_Client_Account_Map.get(FT.Funding_Request__c);
                                    FR.Opening_FIU_Balance__c = FIU_Prior_Value;
                                    FR.Closing_FIU_Balance__c = FIU_Prior_Value + CaseMap.get(FT.Funding_Request__c).Wire_Fee__c;
                                    FIU_Prior_Value = FIU_Prior_Value + CaseMap.get(FT.Funding_Request__c).Wire_Fee__c;
                                    FIU_Report_list.add(FR);
                                }
                            }
                        }
                    }
                }
                insert FIU_Report_list;
            }catch(Exception e){system.debug('Exception e '+ e);}
        }
        if(Trigger.isDelete)
        {
            set<String> Reference_set = new Set<String>();
            for(Funding_Transaction__c FT : Trigger.old)
            {
                Reference_set.add(FT.Id);
              /*  if(Case_and_Client_Account_Map != NULL && Case_and_Client_Account_Map.get(FT.Funding_Request__c) != NULL)
                {
                    if(Client_Account_Map != NULL && Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)) != NULL)
                    {
                        if(Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c == NULL)
                        {
                            Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c = 0;
                        }
                        else
                        {
                            Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Funding_Transaction_Count__c -= 1;
                            
                        }
                        if(Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Draw_Fees__c == NULL)
                        {
                            Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Draw_Fees__c = 0;
                        }
                        else
                        {
                            Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Draw_Fees__c -= FT.Applied_Draw_Fee__c;
                        }
                        if(Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Origination_Fees__c == NULL)
                        {
                            Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Origination_Fees__c = 0;
                        }
                        else
                        {
                            Client_Account_Map.get(Case_and_Client_Account_Map.get(FT.Funding_Request__c)).Sum_of_Origination_Fees__c -= FT.Applied_Origination_Fee__c;
                        }
                    }
                }*/
            }
             
            Try{
          //      update Client_Account_Map.values();
                Delete [Select Id from FIU_Report__c where Reference__c in : Reference_set];
            }catch(Exception e){system.debug('Exception ==> '+e);}
        }
    }
    
}