trigger trgonDailyInterestAccrual on Daily_Interest_Accrual__c (After Insert,After Update,After Delete) {
    if(Trigger.isAfter)
    {
        List<IUF__C>IUF_List = new List<IUF__C>();
        List<Applied_Monthly_Interest__c>AMI_List = new List<Applied_Monthly_Interest__c>();
        if(Trigger.isInsert )// || Trigger.isUpdate
        {
            set<string> MonthlyInterestID = new Set<string>();
            set<string>clientAccountIds = new Set<string>();
             for(Daily_Interest_Accrual__c DIA : Trigger.New)
             {
                 MonthlyInterestID.add(DIA.Monthly_Interest_Application__c);
             }
            
            map<string,Monthly_Interest_Application__c> monthlyInterest_map = new map<string,Monthly_Interest_Application__c>([select id,Name,Interest__c,Commitment_Fee__c,Date__c,Applied__c,Client_Account__c,Interest_Charged__c,UL_Fee_Charged__c from Monthly_Interest_Application__c where id in : MonthlyInterestID]);
            for(Monthly_Interest_Application__c MI : monthlyInterest_map.values())
            {
                clientAccountIds.add(MI.Client_Account__c);
            }
            Map<string,Client_Account__c> Client_account_map = new Map<string,Client_Account__c>([Select id,IUF_Reserve_Retained__c,Interest_Due__c,UL_Fee_Due__c,Interest_Due_Since__c,UL_Fee_Due_Since__c from Client_Account__c where id in: clientAccountIds]);
            BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
            
            for(Daily_Interest_Accrual__c DIA : Trigger.New)
            {
                if(DIA.Flag_for_Last_Day_of_the_Month__c == True && monthlyInterest_map != NULL)
                {
                    IUF__c IUF = new IUF__c();
                    IUF.Date__c = DIA.Date__c;
                    IUF.IUF_Retained__c = 0;
                    IUF.Opening_IUF_Retained__c = DIA.Current_IUF_Retained__c;
                    if(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c) != NULL)
                    {
                    /*    IUF.Month_Interest__c = (DIA.Interest__c + monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).interest__C);
                        IUF.Un_Used_Line_Rate__c = (DIA.Commitment_fee_acc__c + monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Commitment_Fee__c);
                        IUF.IUF_used__c = (DIA.Interest__c + monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).interest__C) + (DIA.Commitment_fee_acc__c + monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Commitment_Fee__c);
                      */  
                        Applied_Monthly_Interest__c AMI = new Applied_Monthly_Interest__c();
                        AMI.Name = monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Date__c.month()+'-'+monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Date__c.Year()+' Report';
                        AMI.Client_Account__c = monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c;
                        AMI.Date__c = DIA.Date__c;
                        
                        AMI.Commitment_fee_Accrued__c = (DIA.Commitment_fee_acc__c + monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Commitment_Fee__c);
                        AMI.Interest__c = (DIA.Interest__c + monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).interest__C);
                       
                        Double IUFRetained = 0.0, InterestDue = 0.0, ULFeeDue = 0.0;
                        if(Client_account_map != NULL & Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c) != NULL)
                        {
                            IUFRetained = Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).IUF_Reserve_Retained__c;
                            if(Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).Interest_Due__c != NULL)
                            	InterestDue = Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).Interest_Due__c;
                            if(Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due__c != NULL)
                            	ULFeeDue = Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due__c;
                            
                            if(IUFRetained >= AMI.Interest__c)
                            {
                                monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Interest_Charged__c = AMI.Interest__c;
                                AMI.Interest_Charged__c = AMI.Interest__c;
                                IUFRetained = IUFRetained - AMI.Interest__c;
                                if(IUFRetained >= AMI.Commitment_fee_Accrued__c)
                                {
                                    monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).UL_Fee_Charged__c = AMI.Commitment_fee_Accrued__c;
                                    AMI.UL_Fee_Charged__c = AMI.Commitment_fee_Accrued__c;
                                    IUFRetained = IUFRetained - AMI.Commitment_fee_Accrued__c;
                                }
                                else
                                {
                                    monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).UL_Fee_Charged__c = IUFRetained;
                                    AMI.UL_Fee_Charged__c = IUFRetained;
                                    ULFeeDue = ULFeeDue + (AMI.Commitment_fee_Accrued__c - IUFRetained);
                                    IUFRetained = 0.0;
                                    If(Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due_Since__c == NULL)
                                    {
                                        if(BsnsTransact != Null)
                                        {
                                        	Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due_Since__c = BsnsTransact.Business_Transaction_Date__c;
                                        }
                                        else
                                        {
                                            Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due_Since__c = Date.today();
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if(IUFRetained == 0.0)
                                { 
                                   InterestDue = InterestDue + AMI.Interest__c;
                                   ULFeeDue = ULFeeDue + AMI.Commitment_fee_Accrued__c;
                                }
                                else
                                {
                                    monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Interest_Charged__c = IUFRetained;
                                    AMI.Interest_Charged__c = IUFRetained;
                                    InterestDue = InterestDue + (AMI.Interest__c - IUFRetained);
                                    IUFRetained = 0.0;
                                    ULFeeDue = ULFeeDue + AMI.Commitment_fee_Accrued__c;
                                }
                                If(Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).Interest_Due_Since__c == NULL)
                                {
                                    if(BsnsTransact != Null)
                                    {
                                        Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).Interest_Due_Since__c = BsnsTransact.Business_Transaction_Date__c;
                                        Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due_Since__c = BsnsTransact.Business_Transaction_Date__c;
                                    }
                                    else
                                    {
                                        Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).Interest_Due_Since__c = Date.today();
                                        Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due_Since__c = Date.today();
                                    }
                                }
                            }
							if(AMI.Interest_Charged__c != NULL)
                           		IUF.Month_Interest__c = AMI.Interest_Charged__c;
                            else
                                AMI.Interest_Charged__c = 0;
                            if(AMI.UL_Fee_Charged__c != NULL)
                            	IUF.Un_Used_Line_Rate__c = AMI.UL_Fee_Charged__c;
                            else
                                AMI.UL_Fee_Charged__c = 0;
                            IUF.IUF_used__c = AMI.Interest_Charged__c + AMI.UL_Fee_Charged__c;
                            
                            Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).IUF_Reserve_Retained__c = IUFRetained;
                            Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).Interest_Due__c = InterestDue;
                            Client_account_map.get(monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Client_Account__c).UL_Fee_Due__c = ULFeeDue;

                        }
                        
                        AMI.Monthly_Interest_Application__c = monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).id;
                        AMI.Reference__c = DIA.ID;
                        monthlyInterest_map.get(DIA.Monthly_Interest_Application__c).Applied__c = True;
                        AMI_List.add(AMI);
                    }
                         
                    IUF.Payment_Line_Item__c = DIA.id;
                    IUF.Type__c = 'System';
                    IUF.Client_Account__c = DIA.Client_Account__c;
                    IUF_List.add(IUF);
                }
            }
            if(IUF_List.size()>0)
            {
                try{
                    insert IUF_List;
					insert AMI_List;
					update monthlyInterest_map.values();
					update Client_account_map.values();                    
                }Catch(Exception e){System.debug('Exception e'+ e);}
            }
        }
        if(Trigger.isDelete)
        {
            set<Id> set_Daily_interest = new Set<Id>();
            for(Daily_Interest_Accrual__c DIA : Trigger.old)
            {
                set_Daily_interest.add(DIA.Id);
            }
            try{
                Delete[Select id,Payment_Line_Item__c from IUF__C where Payment_Line_Item__c in : set_Daily_interest];
                Delete[Select id,Reference__c from Applied_Monthly_Interest__c where Reference__c in : set_Daily_interest];
            }catch(Exception e)
            {system.debug('Exception '+ e);}
        }
    }
}