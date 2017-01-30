/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage   : Stamping the LookupIds by external Id's while loading the data from ESB and updating the flags to know the integration status
 * Usage   : Stamp the Business Transaction Date from customsettings.
*/
trigger trgonClientAccount on Client_Account__c (Before Insert,Before Update,after Insert,after Update) {
 if(Trigger.isBefore)
    {    
        //======== updating the Transaction date from Custom settings===================//
        BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
        set<String> CRM_ID = new set<String>();
        //============ Stamping the LookupIds by external Id's ======//
        if(Trigger.isInsert)//|| Trigger.isUpdate
        {
            Set<String> ClientKeys = new Set<String>();
            Set<String> ProductKeys = new Set<String>();
            Set<String> PrimaryContractKeys = new Set<String>();
            Set<String> SecondaryContractKeys = new Set<String>();
            map<String,akritiv__Brand__c > Clientmap= new map<String,akritiv__Brand__c>();
            map<String,Product__c > Productmap= new map<String,Product__c>();
            map<String,contact > PrimaryContactmap = new map<String,contact>();
            map<String,contact > SecondaryContactmap = new map<String,contact>();
                        
            for(Client_Account__c ClientAccount : Trigger.New)
            {
                if(ClientAccount.Client_External_Foreign_Key__c != Null)
                    ClientKeys.add(ClientAccount.Client_External_Foreign_Key__c);
                if(ClientAccount.Product_External_Foreign_Key__c != Null)   
                    ProductKeys.add(ClientAccount.Product_External_Foreign_Key__c);
                if(ClientAccount.Primary_Contact_External_ID__c != Null)
                    PrimaryContractKeys.add(ClientAccount.Primary_Contact_External_ID__c);
                If(ClientAccount.Secondary_Contact_External_Id__c!= Null)
                    SecondaryContractKeys.add(ClientAccount.Secondary_Contact_External_Id__c);
                If(ClientAccount.Partner_CRM_ID__c != NULL)
                    CRM_ID.add(ClientAccount.Partner_CRM_ID__c);
                    
                if(BsnsTransact != Null)
                {
                    ClientAccount.Business_Transaction_Date__c = BsnsTransact.Business_Transaction_Date__c;
                    if(clientAccount.Non_performing_asset__c == True)
                        ClientAccount.Non_Accrual_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
                if(ClientAccount.IUF_Reserve_Retained__c == NULL)
                    ClientAccount.IUF_Reserve_Retained__c = 0;

            }
            
            for(akritiv__Brand__c Client : [Select id,External_Id__c from akritiv__Brand__c where External_Id__c in : ClientKeys])
            {
                Clientmap.put(Client.External_Id__c,Client);
            }
            for(Product__c Product : [Select id,External_Id__c from Product__c where External_Id__c in : ProductKeys])
            {
                Productmap.put(Product.External_Id__c,Product);
            }
            for(Contact con : [Select id,Contact_Key__c from Contact where (Contact_Key__c in : PrimaryContractKeys or Contact_Key__c in : SecondaryContractKeys)])
            {
                if(PrimaryContractKeys.Contains(con.Contact_Key__c))
                PrimaryContactmap.put(con.Contact_Key__c,Con);
                if(SecondaryContractKeys.Contains(con.Contact_Key__c))
                SecondaryContactmap.put(con.Contact_Key__c,Con);
            }
            
            for(Client_Account__c ClientAccount : Trigger.New)
            {
                if(Clientmap != NULL && Clientmap.get(ClientAccount.Client_External_Foreign_Key__c) != NULL)
                    ClientAccount.Client__c = Clientmap.get(ClientAccount.Client_External_Foreign_Key__c).ID;
                if(Productmap != NULL && Productmap.get(ClientAccount.Product_External_Foreign_Key__c) != NULL)
                    ClientAccount.Product__c = Productmap.get(ClientAccount.Product_External_Foreign_Key__c).ID;
                if(PrimaryContactmap != NULL && PrimaryContactmap.get(ClientAccount.Primary_Contact_External_ID__c) != NULL)
                    ClientAccount.Primary_Contact__c = PrimaryContactmap.get(ClientAccount.Primary_Contact_External_ID__c).ID;
                if(SecondaryContactmap != NULL && SecondaryContactmap.get(ClientAccount.Secondary_Contact_External_Id__c) != NULL)
                    ClientAccount.Secondary_Contact__c = SecondaryContactmap.get(ClientAccount.Secondary_Contact_External_Id__c).ID;
            }
            
        }
        //=========== updating the flags =======================//
        if(Trigger.IsUpdate)
        {
          //  profile p = [select id from profile where name = 'Integration Admin'];
          //  system.debug('==>> 1 =>> '+ userinfo.getProfileId() +'=>> 2 ==>> '+ p.id);
          //  if(p.Id != userinfo.getProfileId())
         //   {
                for(Client_Account__c clientAccount : Trigger.New)
                {
                    if(clientAccount.Profile_Name__c != 'Integration Admin')
                    {
                        clientAccount.Sync_with_Grade__c = False;
                        clientAccount.Sync_with_Market_Place__c = False;
                        clientAccount.Sync_with_Portal__c = False;
                    }
                    If(ClientAccount.Partner_CRM_ID__c != NULL && ClientAccount.Partner__c == NULL)
                        CRM_ID.add(ClientAccount.Partner_CRM_ID__c);
                }
         //   }
            for(Client_Account__c clientAccount : Trigger.New)
            {
                ClientAccount.IUF_Reserve_Retained__c = ClientAccount.Actual_IUF_Amount__c;
                if(BsnsTransact != Null && (Trigger.oldMap.get(clientAccount.Id).Non_performing_asset__c == False && clientAccount.Non_performing_asset__c == True))
                {
                    ClientAccount.Non_Accrual_Date__c = BsnsTransact.Business_Transaction_Date__c;
                }
            }
        }
        if(CRM_ID.size() > 0)
        {
            List<Partner__c> Partner_List = [select id,name,CRM_ID__c,Sum_of_Draw_Fees__c,Sum_of_Origination_Fees__c from Partner__c where CRM_ID__c in : CRM_ID];
            Map<string,Partner__c> partner_map = new Map<string,Partner__c>();
            for(Partner__c P : Partner_List)
            {
                if(P.CRM_ID__c != NULL)
                    partner_map.put(P.CRM_ID__c,p);
            }
            List<Partner__c> Create_Partner_List = new List<Partner__c>();
            
            for(Client_Account__c clientAccount : Trigger.New)
            {
                if(clientAccount.Partner_CRM_ID__c != NULL)
                {
                    if(partner_map != NULL && partner_map.containsKey(clientAccount.Partner_CRM_ID__c))
                    {
                        clientAccount.Partner__c = partner_map.get(clientAccount.Partner_CRM_ID__c).id;
                    }
                    else
                    {
                        Partner__c part = new Partner__c();
                        part.Name = clientAccount.Partner_Name__c;
                        part.CRM_ID__c = clientAccount.Partner_CRM_ID__c;
                        Create_Partner_List.add(part);
                    }
                }
            }
            if(Create_Partner_List.size() > 0)
            {
                try{
                    insert Create_Partner_List;
                    for(Partner__c prt : Create_Partner_List)
                    {
                     for(Client_Account__c clientAccount : Trigger.New)
                     {
                         if(prt.CRM_ID__c == clientAccount.Partner_CRM_ID__c)
                         {
                             clientAccount.Partner__c = prt.Id;
                         }
                     }
                    }
                   }catch(exception e){system.debug('===> 123 '+ e);}
            }
        
        }
       
    }
/* if(Trigger.isAfter)
 {
     set<id> clientIDset = new Set<id>();
     for(Client_Account__c CA : Trigger.New)
     {
         clientIDset.add(CA.Client__c);
     }
     if(Trigger.isinsert)
     {
          if(clientIDset.size() > 0)
          {
              doCallout_toupdate_in_portal.doCallout_toupdatetheClient_in_portal(clientIDset);
          }
     }
 } */
  if(Trigger.isAfter)
    {
        if(Trigger.isupdate)
        {
            BusinessTransactionDate__c BsnsTransact = BusinessTransactionDate__c.getOrgDefaults();
            list<Due_Change__c> Listof_Due = new List<Due_Change__c>();
            for(Client_Account__c CA : Trigger.New)
            {
                if(CA.Interest_Due__c != NULL && Trigger.oldMap.get(CA.Id).Interest_Due__c != NULL)
                {
                    if(Trigger.oldMap.get(CA.Id).Interest_Due__c != Trigger.newMap.get(CA.Id).Interest_Due__c)
                    {
                        Due_Change__c DC = new Due_Change__c();
                        if(BsnsTransact != Null)
                        {
                            DC.Date__c = BsnsTransact.Business_Transaction_Date__c;
                        }
                        DC.Interest_Due__c = Trigger.oldMap.get(CA.Id).Interest_Due__c;
                        DC.Interest_Due_Since__c = Trigger.oldMap.get(CA.Id).Interest_Due_Since__c;
                        Listof_Due.add(DC);
                    }
                }
                if(CA.UL_Fee_Due__c != NULL && Trigger.oldMap.get(CA.Id).UL_Fee_Due__c != NULL)
                {
                    if(Trigger.oldMap.get(CA.Id).UL_Fee_Due__c != Trigger.newMap.get(CA.Id).UL_Fee_Due__c)
                    {
                        Due_Change__c DC = new Due_Change__c();
                        if(BsnsTransact != Null)
                        {
                            DC.Date__c = BsnsTransact.Business_Transaction_Date__c;
                        }
                        DC.UL_Fee_Due__c = Trigger.oldMap.get(CA.Id).UL_Fee_Due__c;
                        DC.UL_Fee_Due_Since__c = Trigger.oldMap.get(CA.Id).UL_Fee_Due_Since__c;
                        Listof_Due.add(DC);
                        
                    }
                }
                
                if(Listof_Due.size() > 0)
                {
                    try
                    {
                        insert Listof_Due;
                    }catch(Exception e){system.debug('Exception e '+ e);}
                }
            }
        }
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            set<String> Partnerset = new Set<string>();
            for(Client_Account__c CA : Trigger.New)
            {
                if(Trigger.isInsert)
                {
                    if(CA.Partner__c != NULL)
                        Partnerset.add(CA.Partner__c);
                }
                else
                {
                    if(CA.Partner__c != NULL)
                    {system.debug('CA1  '+ CA.Partner__c);
                        if(Trigger.oldMap.get(CA.Id).Partner_Origination_Fee_Amount__c != Trigger.newMap.get(CA.Id).Partner_Origination_Fee_Amount__c || Trigger.oldMap.get(CA.Id).Partner_Draw_Fee_Amount__c != Trigger.newMap.get(CA.Id).Partner_Draw_Fee_Amount__c)
                        {
                            Partnerset.add(CA.Partner__c);
                        }
                        else if(Trigger.oldMap.get(CA.Id).Partner__c != Trigger.newMap.get(CA.Id).Partner__c)
                        {system.debug('CA2  ');
                            Partnerset.add(CA.Partner__c);
                        }
                    }
                }
            }
            if(Partnerset.size() > 0)
            {
                system.debug('Partnerset---> '+ Partnerset.size());
                Map<string,Partner__c> Partner_Map = new Map<string,Partner__c>([select id,Sum_of_Draw_Fees__c,Sum_of_Origination_Fees__c 
                                                                                from Partner__c where id in : Partnerset]);
                for(AggregateResult PM : [select count(ID) PC,sum(Partner_Origination_Fee_Amount__c) SPOF,sum(Partner_Draw_Fee_Amount__c) SPDF,Partner__c Partner from Client_Account__c where Partner__c IN : Partnerset group by Partner__c])
                {
                    if(Partner_Map.containsKey((Id)PM.get('Partner')))
                    {
                        Partner_Map.get((Id)PM.get('Partner')).Sum_of_Origination_Fees__c   = (Double)PM.get('SPOF');
                        Partner_Map.get((Id)PM.get('Partner')).Sum_of_Draw_Fees__c          = (Double)PM.get('SPDF');
                    }
                }
                try{
                    update Partner_Map.values();
                }Catch(exception e){system.debug('Partner Exception e'+e);}
            }
        }
    }
}