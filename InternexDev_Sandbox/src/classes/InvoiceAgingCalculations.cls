global class InvoiceAgingCalculations implements Database.Batchable<sObject>{
  global Database.QueryLocator Start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate,Client__c, Product__c, External_Id__c, External_Req_Id__c,';
            query = query+'Portal_External_Id__c, MP_External_Id__c, Sync_with_Grade__c, Sync_with_Market_Place__c, Sync_with_Portal__c,Send_to_Grade__c,Send_to_Portal__c,';
            query = query+'Source__c  FROM Client_Account__c limit 49999';//where (Send_to_Grade__c > 0 or Send_to_Portal__c > 0)
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global Void Execute(Database.BatchableContext BC,list<Client_Account__c> Scope)
    {
        set<string> clientaccountID_set = new Set<String>();
        set<string> ClientID_set = new Set<String>();
        for(Client_Account__c CA : Scope)
        {
           System.debug('CA--> '+ CA.Name);
           clientaccountID_set.add(CA.id);
           ClientID_set.add(CA.Client__c);
        }
        map<string,Debtor__c> Debtormap = new map<string,Debtor__c>([Select id,Closed_Invoice_Amounts_12_months__c,Closed_Invoice_Amounts_1_months__c,Closed_Invoice_Amounts_3_months__c,	Closed_Invoice_Amounts_6_months__c,	Dilution_Amount_12_Month__c,
                                    Dilution_Amount_1_Month__c,Dilution_Amount_3_Month__c,Dilution_Amount_6_Month__c,Open_Invoice_Dilution_12_Months__c,Open_Invoice_Dilution_1_Months__c,Open_Invoice_Dilution_3_Months__c,
                                    Open_Invoice_Dilution_6_Months__c,Current__c,X1_15__c,X16_30__c,X31_60__c,X61_90__c,X90__c,Client_Account__c from Debtor__c where Client_account__C in : clientaccountID_set]);
        list<akritiv__Transaction__c> Invoice_list = [Select id,Due_Days__c,Debtor__c,akritiv__Amount__c,Balance_Internex__c,Invoice_Status_Internex__c,Invoice_Dilution__c,Invoice_Status__c,Closed_Invoice_Age__c from akritiv__Transaction__c where Debtor__c in : Debtormap.keySet()];
       For(Debtor__c Deb : Debtormap.values())
       {
           Decimal InvoiceTotal_Current = 0.0,InvoiceTotal_1to15 = 0.0,InvoiceTotal_16to30 = 0.0,InvoiceTotal_31to60 = 0.0;
           Decimal InvoiceTotal_61to90 = 0.0,InvoiceTotal_90above = 0.0;
           Decimal ClosedInvoiceTotal_12 = 0.0,ClosedInvoiceTotal_6 = 0.0,ClosedInvoiceTotal_3 = 0.0,ClosedInvoiceTotal_1 = 0.0;
           Decimal OpenInvoiceDilution_12 = 0.0,OpenInvoiceDilution_6 = 0.0,OpenInvoiceDilution_3 = 0.0,OpenInvoiceDilution_1 = 0.0;
           Decimal InvoiceDilution_12 = 0.0,InvoiceDilution_6 = 0.0,InvoiceDilution_3 = 0.0,InvoiceDilution_1 = 0.0;
           
           for(akritiv__Transaction__c INV : Invoice_list)
           {
               if(INV.Debtor__c == Deb.Id)
               {
                   if(INV.Due_Days__c <= 0)
                   {
                       InvoiceTotal_Current += INV.Balance_Internex__c;
                   }
                   else if(INV.Due_Days__c >= 1 && INV.Due_Days__c <= 15)
                   {
                       InvoiceTotal_1to15 += INV.Balance_Internex__c;
                   }
                   else if(INV.Due_Days__c >= 16 && INV.Due_Days__c <= 30)
                   {
                       InvoiceTotal_16to30 += INV.Balance_Internex__c;
                   }
                   else if(INV.Due_Days__c >= 31 && INV.Due_Days__c <= 60)
                   {
                       InvoiceTotal_31to60 += INV.Balance_Internex__c;
                   }
                   else if(INV.Due_Days__c >= 61 && INV.Due_Days__c <= 90)
                   {
                       InvoiceTotal_61to90 += INV.Balance_Internex__c;
                   }
                   else
                   {
                       InvoiceTotal_90above += INV.Balance_Internex__c;
                   }
                    Decimal InvoiceDilution = 0.0;
                   if(INV.Invoice_Dilution__c != NULL)
                       InvoiceDilution = INV.Invoice_Dilution__c; 
                   if(INV.Closed_Invoice_Age__c <= 365)
                   {
                       InvoiceDilution_12 += InvoiceDilution;
                       if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                           ClosedInvoiceTotal_12 += INV.akritiv__Amount__c;
                       if(INV.Invoice_Status__c == 'Open')
                           OpenInvoiceDilution_12 += InvoiceDilution;
                   }
                   if(INV.Closed_Invoice_Age__c <= 180)
                   {
                       InvoiceDilution_6 += InvoiceDilution;
                       if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                           ClosedInvoiceTotal_6 += INV.akritiv__Amount__c;
                       if(INV.Invoice_Status__c == 'Open')
                           OpenInvoiceDilution_6 += InvoiceDilution;
                   }
                   if(INV.Closed_Invoice_Age__c <= 90)
                   {
                       InvoiceDilution_3 += InvoiceDilution;
                       if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                           ClosedInvoiceTotal_3 += INV.akritiv__Amount__c;
                       if(INV.Invoice_Status__c == 'Open')
                           OpenInvoiceDilution_3 += InvoiceDilution;
                   }
                   if(INV.Closed_Invoice_Age__c <= 30)
                   {
                       InvoiceDilution_1 += InvoiceDilution;
                       if(INV.Invoice_Status__c == 'Closed' && INV.Invoice_Status_Internex__c == 'Approved')
                           ClosedInvoiceTotal_1 += INV.akritiv__Amount__c;
                       if(INV.Invoice_Status__c == 'Open')
                           OpenInvoiceDilution_1 += InvoiceDilution;
                   } 
               }
           } 
           Deb.Current__c = InvoiceTotal_Current;
           Deb.X1_15__c = InvoiceTotal_1to15;
           Deb.X16_30__c = InvoiceTotal_16to30;
           Deb.X31_60__c = InvoiceTotal_31to60;
           Deb.X61_90__c = InvoiceTotal_61to90;
           Deb.X90__c = InvoiceTotal_90above;
           
           Deb.Closed_Invoice_Amounts_12_months__c = ClosedInvoiceTotal_12;
           Deb.Closed_Invoice_Amounts_1_months__c = ClosedInvoiceTotal_1;
           Deb.Closed_Invoice_Amounts_3_months__c = ClosedInvoiceTotal_3;
           Deb.Closed_Invoice_Amounts_6_months__c = ClosedInvoiceTotal_6;
           Deb.Dilution_Amount_12_Month__c = InvoiceDilution_12;
           Deb.Dilution_Amount_1_Month__c = InvoiceDilution_1;
           Deb.Dilution_Amount_3_Month__c = InvoiceDilution_3;
           Deb.Dilution_Amount_6_Month__c = InvoiceDilution_6;
           Deb.Open_Invoice_Dilution_12_Months__c = OpenInvoiceDilution_12;
           Deb.Open_Invoice_Dilution_1_Months__c = OpenInvoiceDilution_1;
           Deb.Open_Invoice_Dilution_3_Months__c = OpenInvoiceDilution_3;
           Deb.Open_Invoice_Dilution_6_Months__c = OpenInvoiceDilution_6;
       }
    Map<string,akritiv__Brand__c> ClientMap = new Map<string,akritiv__Brand__C>([Select id,Name,status__C from akritiv__Brand__c where id in : ClientID_set and status__C not in ('Delinquent','Default','Impaired','Closed')]);  
        if(ClientMap != NULL)
        {
            BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
            for(AggregateResult INV : [select MAX(CreatedDate) MD,Debtor__r.Client_Account__c,Debtor__r.Client_Account__r.Client__c client from akritiv__Transaction__c where Debtor__c in : Debtormap.keySet() and Debtor__r.Client_Account__r.Client__c in : ClientMap.keySet() group by Debtor__r.Client_Account__c,Debtor__r.Client_Account__r.Client__c])
            {
                if(ClientMap.get((Id)INV.get('client')) != NULL)
                {
                    system.debug('ClientName ==> '+ ClientMap.get((Id)INV.get('client')).Name);
                    Date MaxDate = Date.valueof(INV.get('MD'));
                    system.debug('MaxDate ==> '+ MaxDate);
                    system.debug('MaxDate + 7 ==> '+ MaxDate.addDays(7));
                    if(BsnsTransact != NULL)
                    {
                        if(MaxDate.addDays(7) < BsnsTransact.Business_Transaction_Date__c)
                        {
                            ClientMap.get((Id)INV.get('client')).status__C = 'Non-Compliant';
                        }
                    }
                }

                // debtormap_InvoiceCount.put((Id)INV.get('Debtor'),(Double)INV.get('IC'));
            }
        }
       
        try{
            update Debtormap.values();
            update ClientMap.values();
        }catch(exception e){system.debug('Exception ==> '+ e);}
    }
    global void Finish(Database.BatchableContext BC)
    {
    }
}