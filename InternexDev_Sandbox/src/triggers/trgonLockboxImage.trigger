trigger trgonLockboxImage on Lockbox_Image__c (before insert,before update) {
   /* if(Trigger.Isbefore)
    {
        set<string>Lockboxnumber = new set<string>();
        Set<string>Batchnumber = new set<string>();
        Set<string>SequenceNumber = new set<String>();
        for(Lockbox_Image__c LI : Trigger.New)
        {
            list<string>Imagename_list = new list<string>();
            if(LI.Image_Name__c != NULL)
            {
                Imagename_list.addAll(LI.Image_Name__c.split('\\.'));
          //      system.debug('Imagename_list==> '+ Imagename_list);
                if(Imagename_list.size() >= 3)
                	Lockboxnumber.add(Imagename_list[2]);
                if(Imagename_list.size() >= 4)
                {
                    Batchnumber.add(Imagename_list[3].mid(0, 4));
                    SequenceNumber.add(String.valueof(Integer.valueof(Imagename_list[3].mid(4, 4))));
                }
            }
          //  system.debug('Lockboxnumber==> '+ Lockboxnumber);
          //  system.debug('Batchnumber==> '+ Batchnumber);
          //  system.debug('SequenceNumber==> '+ SequenceNumber);
        }
        Map<string,WF_PR__c> PR_map = new Map<string,WF_PR__c>();
        for(WF_PR__c PR:[Select id,name,Payment__c,Item_sequence_number__c,WF_BH__r.BH_Batch_number__c,WF_BH__r.LB_Number__c from WF_PR__c where Item_sequence_number__c in : SequenceNumber and WF_BH__r.BH_Batch_number__c in : Batchnumber and WF_BH__r.LB_Number__c in : Lockboxnumber])
        {
            PR_map.put(PR.Item_sequence_number__c+PR.WF_BH__r.BH_Batch_number__c + PR.WF_BH__r.LB_Number__c, PR);
        }
        if(PR_map != NULL)
        {
			for(Lockbox_Image__c LI : Trigger.New)
            {
                if(LI.Image_Name__c != NULL)
                {
                    string Imageinfo;
                    if(LI.Image_Name__c.split('\\.').size() >= 4)
                    	Imageinfo = String.valueof(Integer.valueof(LI.Image_Name__c.split('\\.')[3].mid(4, 4)))+LI.Image_Name__c.split('\\.')[3].mid(0, 4)+LI.Image_Name__c.split('\\.')[2];
                    if(PR_map.containsKey(Imageinfo))
                    {
                        Li.WF_PR__c = PR_map.get(Imageinfo).id;
                        if(PR_map.get(Imageinfo).Payment__c != NULL)
                        {
                            Li.Payment__c = PR_map.get(Imageinfo).Payment__c;
                        }
                    }
                }
            }
        }
    } */
}