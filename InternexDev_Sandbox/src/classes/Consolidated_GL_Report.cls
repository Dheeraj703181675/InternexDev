global class Consolidated_GL_Report implements Database.Batchable<sobject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select id,FIU_Outstanding__c,Non_performing_asset__c,Commitment__c,Commitment_rate__c,Funding_Limit__c,MinCommitmentAmount__c,';
        query = query+'Invoice_Amount__c,Sum_of_Net_Availability__c,Ineligibles_Amount__c,Eligible_For_Funding__c,Gross_Availability__c,Net_Availability__c,Index__c,Rate__c,Rate_Type__c,Method__c,Spread__c from Client_Account__c Limit 49999 '; //where id = \''+'a0Y61000001e6hs'+'\'
        system.debug('==>query '+ query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Client_Account__c> scope) {
        set<string> ClientAccountIDs = new Set<string>();
        for(Client_Account__c CA : scope)
        {
            ClientAccountIDs.add(CA.Id);
        }
        Delete[Select id from Consolidated_GL_Report__c where Client_Account__c in : scope and createddate >: system.now()-1];
        CreatepaymentandfundingRequestinfo(ClientAccountIDs);
        Createinterestinfo(ClientAccountIDs);
    }
    global void finish(Database.BatchableContext BC)
    {
        InvoiceAgingCalculations IAC = new InvoiceAgingCalculations();
        Database.executeBatch(IAC, 1);
    }
    public void CreatepaymentandfundingRequestinfo(Set<string> scope)
    {
        system.debug('scope====> '+scope);
        system.debug('CreatepaymentandfundingRequestinfo====> ');
        List<Consolidated_GL_Report__c> CGL_list = new List<Consolidated_GL_Report__c>();
        List<FIU_Report__c> FIUreport_list = [Select id,Transaction_Name__c,Transaction_ID__c,Date__c,Payments__c,Reference__c,
                                              Client_Account__c,Opening_FIU_Balance__c,Closing_FIU_Balance__c,Funding__c
                                              from FIU_Report__c where Client_Account__c in : scope and createddate >: system.now()-1];
        system.debug('FIUreport_list size====> '+ FIUreport_list.size());
        for(FIU_Report__c FIU : FIUreport_list)
        {
            Consolidated_GL_Report__c CGL = new Consolidated_GL_Report__c();
            CGL.Client_Account__c = FIU.Client_Account__c;
            CGL.Date__c = FIU.Date__c;
            CGL.Funding__c = FIU.Funding__c;
            CGL.Funding_currency__c = FIU.Funding__c;
            CGL.Payments__c = FIU.Payments__c;
            CGL.Payments_Currency__c = FIU.Payments__c;
            CGL.Reference__c = FIU.Reference__c;
            CGL.Transaction_ID__c = FIU.Transaction_ID__c;
            CGL.Transaction_Name__c = FIU.Transaction_Name__c;
            CGL_list.add(CGL);
        }
        try
        {
            insert CGL_list;
        }catch(exception e){system.debug('exception  '+ e);}
    }
    Public Void Createinterestinfo(Set<string> scope)
    {
        system.debug('scope====> '+scope);
        system.debug('Createinterestinfo====> ');
        List<Consolidated_GL_Report__c> CGL_list = new List<Consolidated_GL_Report__c>();
        list<Applied_Monthly_Interest__c> MonthlyInterest_List = [Select id,Name,Client_Account__c,Date__c,Commitment_fee_Accrued__c,Interest__c,Monthly_Interest_Application__c,Monthly_Interest_Application__r.name,
                                                                 Reference__c from Applied_Monthly_Interest__c where Client_Account__c in : scope and createddate >: system.now()-1];
    	 system.debug('MonthlyInterest_List====> '+ MonthlyInterest_List.size());
        for(Applied_Monthly_Interest__c AMI : MonthlyInterest_List)
        {
            Consolidated_GL_Report__c CGL = new Consolidated_GL_Report__c();
            CGL.Client_Account__c = AMI.Client_Account__c;
            CGL.Date__c =AMI.Date__c;
            CGL.Funding__c = AMI.Commitment_fee_Accrued__c + AMI.Interest__c;
            CGL.Funding_currency__c = AMI.Commitment_fee_Accrued__c + AMI.Interest__c;
           // CGL.Payments__c = 0;
           // CGL.Payments_Currency__c = FIU.Payments__c;
            CGL.Reference__c = AMI.Reference__c;
            CGL.Transaction_ID__c = AMI.Monthly_Interest_Application__r.name;
            CGL.Transaction_Name__c = AMI.Name.replace('Report','Interest');
            CGL_list.add(CGL); 
        }
        try
        {
            insert CGL_list;
        }catch(exception e){system.debug('exception  '+ e);}
    }
}