trigger trgonLinkedAccounts on Linked_Account__c (before Insert,before update) {
    if(Trigger.isBefore)
    {
        if(Trigger.Isinsert || Trigger.IsUpdate)
        {
            for(Linked_Account__c LA : Trigger.New)
            {
                if(Trigger.isInsert || LA.Encryption_Key__c == NULL)
                    LA.Encryption_Key__c = EncryptionandDecryption.getKey();
                if(LA.consumer_secret__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(LA.Id).consumer_secret__c != Trigger.newMap.get(LA.Id).consumer_secret__c)))
                {
                    //  system.debug('==> '+LA.QB_ConsumerSecret__c+'==> '+  LA.Encryption_Key__c);
                    LA.consumer_secret__c = EncryptionandDecryption.Encrypt(LA.consumer_secret__c, LA.Encryption_Key__c);
                }
                if(LA.consumer_key__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(LA.Id).consumer_key__c != Trigger.newMap.get(LA.Id).consumer_key__c)))
                    LA.consumer_key__c = EncryptionandDecryption.Encrypt(LA.consumer_key__c, LA.Encryption_Key__c);
                if(LA.oauth_token__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(LA.Id).oauth_token__c != Trigger.newMap.get(LA.Id).oauth_token__c)))
                    LA.oauth_token__c = EncryptionandDecryption.Encrypt(LA.oauth_token__c, LA.Encryption_Key__c);
                if(LA.access_token_secret__c != NULL && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(LA.Id).access_token_secret__c != Trigger.newMap.get(LA.Id).access_token_secret__c)))
                    LA.access_token_secret__c = EncryptionandDecryption.Encrypt(LA.access_token_secret__c , LA.Encryption_Key__c);
            }
        }
    }
}