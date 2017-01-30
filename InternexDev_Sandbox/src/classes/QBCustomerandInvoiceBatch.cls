global class QBCustomerandInvoiceBatch implements Database.Batchable<sobject>,Database.Allowscallouts{
    global Database.QueryLocator Start(database.BatchableContext BC)
    {
        string query = 'SELECT Id,Name,Encryption_Key__c,QB_Realm__c,QB_ConsumerSecret__c,QB_ConsumerKey__c,QB_OauthToken__c,QB_AccessTokenSecret__c,';
               query = query+'Portal_External_Id__c FROM akritiv__Brand__c where Portal_External_Id__c != NULL limit 49999';
        system.debug('Query ==> '+ query);
        return Database.getQueryLocator(query);
    }
    global void Execute(database.BatchableContext BC,list<akritiv__Brand__c> scope)
    {
        set<string> ClientIDset = new Set<string>(); 
        for(akritiv__Brand__c cl : Scope)
        {
            ClientIDset.add(Cl.id);
        }
        List<Linked_Account__c> LA_List = [Select id,Client__c,Encryption_Key__c,consumer_secret__c,consumer_key__c,oauth_token__c,access_token_secret__c,realm__c from Linked_Account__c where Client__c in: ClientIDset and LinkedAccountTypeName__c =: 'QUICKBOOKS'];
        Map<string,Linked_Account__c> LinkedAccount_map = new Map<string,Linked_Account__c>();
        for(Linked_Account__c LA : LA_List)
        {
            LinkedAccount_map.put(LA.Client__c,LA);
        }
        
        for(akritiv__Brand__c cl : Scope)
        {
           // Linked_Account__c LA = [Select id,Encryption_Key__c,consumer_secret__c,consumer_key__c,oauth_token__c,access_token_secret__c,realm__c from Linked_Account__c where Client__c =: cl.id and LinkedAccountTypeName__c =: 'QUICKBOOKS' limit 1];
            Linked_Account__c LA = new Linked_Account__c();
            if(LinkedAccount_map != NULL && LinkedAccount_map.containsKey(cl.id))
            {
                LA = LinkedAccount_map.get(cl.id);
            }
            
            if(LA.Encryption_Key__c != NULL && LA.consumer_secret__c != NULL && LA.consumer_key__c != NULL && LA.oauth_token__c != NULL && LA.access_token_secret__c != NULL && LA.realm__c != NULL)
            {system.debug('====> '+ cl.Name);
               // string esb_url = 'http://52.37.70.249:8192/outbound/quickbookService/';
                string esb_url = 'https://int-esb.thirdpillar.com/outbound/quickbookService/';
                string BasicAuth = 'esbuser/password'; 
                string methd = 'GET'; 
                string objct = 'customer'; 
                string whr = ' where active = true'; 
                string RealmID = LA.realm__c;
                string clientId = cl.Id; 
                string ClientName = cl.Name;
                string PortalClientID = cl.Portal_External_Id__c; 
                string consumerSecret = EncryptionandDecryption.Decrypt(LA.consumer_secret__c,LA.Encryption_Key__c);
                string Consumerkey = EncryptionandDecryption.Decrypt(LA.consumer_key__c,LA.Encryption_Key__c);
                string Oauthtoken = EncryptionandDecryption.Decrypt(LA.oauth_token__c,LA.Encryption_Key__c);
                string AccessTokenSecret = EncryptionandDecryption.Decrypt(LA.access_token_secret__c,LA.Encryption_Key__c);
                if(!Test.isRunningTest())
                {
                HttpRequesttoESB.getContent(esb_url, methd, BasicAuth, Objct, whr, RealmID, ConsumerKey, ConsumerSecret, OauthToken, AccessTokenSecret, ClientID, PortalClientID,ClientName);
                objct = 'invoice';
                whr = '';
                HttpRequesttoESB.getContent(esb_url, methd, BasicAuth, Objct, whr, RealmID, ConsumerKey, ConsumerSecret, OauthToken, AccessTokenSecret, ClientID, PortalClientID,ClientName); 
                }
            }
        }
    } 
    global void Finish (database.BatchableContext BC){}
}