trigger trgonRem on WF_REM__c (after insert,after update) {
    if(Trigger.isafter)
    {
        system.debug('---> REM After Trigger <---');
        set<string> RMHset = new set<string>();
        set<string> Invoice_name_Set = new set<string>();
        if(Trigger.isInsert || Trigger.isupdate)//|| Trigger.isupdate
        {
            for(WF_REM__c REM : trigger.New)
            {
                if(REM.WF_RMH__c != NULL)
                {
                    RMHset.add(REM.WF_RMH__c);
                }
                if(REM.Reference_2__c != NULL)
                {
                    string Inv_Name = REM.Reference_2__c.remove('_').remove(' ').trim().toUpperCase();
                    Invoice_name_Set.add(Inv_Name);
                }
            }
            set<string> paymentset = new set<string>();
            set<string> debtorset = new set<string>();
            map<string,WF_RMH__c> map_RMH = new map<string,WF_RMH__c>([Select id,Envelope_Number__c,Remittance_sequence_number__c from WF_RMH__c where id in : RMHset]); //WF_PR__c,WF_PR__r.Payment__c,WF_PR__r.Payment__r.Debtor__c,WF_PR__r.Amount_paid_formula__c 
            if(map_RMH != NULL)
            {
                //system.debug('map_RMH--> '+map_RMH);
                set<string> Envelope_set = new set<String>();
                for(WF_RMH__c RMH : map_RMH.values())
                {
                    if(RMH.Envelope_Number__c != NULL)
                    {
                        Envelope_set.add(RMH.Envelope_Number__c);
                    }
                    /*     if(RMH.WF_PR__r.Payment__c != NULL)
{
paymentset.add(RMH.WF_PR__r.Payment__c);
if(RMH.WF_PR__r.Payment__r.Debtor__c != NULL)
{
debtorset.add(RMH.WF_PR__r.Payment__r.Debtor__c);
}
}
*/
                }
                set<string> PR_Set = new Set<string>();
                Map<string,PR_and_RMH__c> Map_RME_JO = new Map<string,PR_and_RMH__c>();
                for(PR_and_RMH__c JO : [Select id,Name,WF_PR__c,WF_RMH__c,WF_PR__r.Reference_1_PR22B__c,WF_PR__r.Payment__c,WF_PR__r.Payment__r.Debtor__c,WF_PR__r.Amount_paid_formula__c,PaymentLineItemCreated__c from PR_and_RMH__c where WF_RMH__c in : map_RMH.values() and PaymentLineItemCreated__c =: False])
                {
                    PR_Set.add(JO.WF_PR__c);
                    Map_RME_JO.put(string.valueOf(JO.WF_RMH__c)+string.valueOf(JO.WF_PR__c),JO);
                    if(JO.WF_PR__r.Payment__r.Debtor__c != NULL)
                    {
                        debtorset.add(Jo.WF_PR__r.Payment__r.Debtor__c);
                    }
                }
                /*	system.debug('paymentset--> '+paymentset);
if(paymentset.size() > 0 )
{
system.debug('debtorset--> '+debtorset);
if(debtorset.size() > 0)
{
map<string,akritiv__Transaction__c> Invoice_map = new map<string,akritiv__Transaction__c>();
for(akritiv__Transaction__c INV : [Select id,name,Debtor__c,Balance_Internex__c from akritiv__Transaction__c where Debtor__c in : debtorset and name in : Invoice_name_Set and Balance_Internex__c > 0 order by createdDate asc])
{
Invoice_map.put(INV.Debtor__c+INV.name.trim().toUpperCase(),INV);
}
if(Invoice_map != NULL)
{
system.debug('Invoice_map--> '+Invoice_map);
List<akritiv__Payment_Line__c> Update_paymentline = new List<akritiv__Payment_Line__c>();
for(WF_REM__c REM : trigger.New)
{
string InvName = REM.Reference_2__c.remove('_').remove(' ').trim().toUpperCase();
system.debug('123--> '+ map_RMH.get(REM.WF_RMH__c).WF_PR__r.Payment__r.Debtor__c);
system.debug('Inv Name--> '+InvName);
if(map_RMH.get(REM.WF_RMH__c) != NULL && Invoice_map.get(map_RMH.get(REM.WF_RMH__c).WF_PR__r.Payment__r.Debtor__c+InvName) != NULL)
{
akritiv__Payment_Line__c pl = new akritiv__Payment_Line__c();
pl.akritiv__Applied_Amount__c = REM.Remittance_net_amount_paid_formula__c;
//  pl.WF_Applied_Amount__c = Double.valueof(string.valueof(REM.Remittance_net_amount_paid__c).mid(0,string.valueof(REM.Remittance_net_amount_paid__c).length()-2) +'.'+ string.valueof(REM.Remittance_net_amount_paid__c).right(2));
pl.WF_Applied_Amount__c = Invoice_map.get(map_RMH.get(REM.WF_RMH__c).WF_PR__r.Payment__r.Debtor__c+InvName).Balance_Internex__c;
pl.akritiv__Applied_To__c = Invoice_map.get(map_RMH.get(REM.WF_RMH__c).WF_PR__r.Payment__r.Debtor__c+InvName).id;
pl.akritiv__Payment__c = map_RMH.get(REM.WF_RMH__c).WF_PR__r.Payment__c;
//   pl.Flag_for_Line_Amount__c = True;
Update_paymentline.add(pl);
system.debug('Update_paymentline==> '+ Update_paymentline);
}
}
if(Update_paymentline.size() > 0)
{
system.debug('Update_paymentline--> '+Update_paymentline);
insert Update_paymentline;
}
}
}
}
*/
                map<string,list<WF_PR__c>> Map_PR = new map<string,list<WF_PR__c>>();
                list<WF_PR__c> PR_List = [Select id,Reference_1_PR22B__c,Payment__c,Payment__r.Debtor__c,Amount_paid_formula__c from WF_PR__c where Reference_1_PR22B__c in : Envelope_set and id in: PR_Set];
                
                for(String str : Envelope_set)
                {
                    list<WF_PR__c> temp_PRList = new List<WF_PR__c>();
                    for(WF_PR__c PR : PR_List)
                    {
                        if(str == PR.Reference_1_PR22B__c)
                        {
                            temp_PRList.add(PR);
                        }
                    }
                    Map_PR.put(str,temp_PRList);
                } 
                system.debug('Map_PR--> '+Map_PR);
                if(Map_PR != NULL)
                {
                    system.debug('debtorset--> '+debtorset);
                    if(debtorset.size() > 0)
                    {
                        map<string,akritiv__Transaction__c> Invoice_map = new map<string,akritiv__Transaction__c>();
                        for(akritiv__Transaction__c INV : [Select id,name,Debtor__c,Balance_Internex__c from akritiv__Transaction__c where Debtor__c in : debtorset and name in : Invoice_name_Set and Balance_Internex__c > 0 order by createdDate asc])
                        {
                            Invoice_map.put(INV.Debtor__c+INV.name.trim().toUpperCase(),INV);
                        }
                        if(Invoice_map != NULL)
                        {
                            system.debug('Invoice_map--> '+Invoice_map);
                            List<akritiv__Payment_Line__c> Update_paymentline = new List<akritiv__Payment_Line__c>();
                            for(WF_REM__c REM : trigger.New)
                            {
                                string InvName = REM.Reference_2__c.remove('_').remove(' ').trim().toUpperCase();
                              //  system.debug('Inv Name--> '+InvName);system.debug('--> '+ map_RMH.get(REM.WF_RMH__c).Envelope_Number__c);
                                if(Map_PR.containsKey(map_RMH.get(REM.WF_RMH__c).Envelope_Number__c))
                                {//system.debug('-->2 '+ Map_PR.get(map_RMH.get(REM.WF_RMH__c).Envelope_Number__c));
                                    for(WF_PR__c PR : Map_PR.get(map_RMH.get(REM.WF_RMH__c).Envelope_Number__c))
                                    {
                                   //     system.debug('-->3 '+Invoice_map.get(PR.Payment__r.Debtor__c+InvName));
                                        if(map_RMH.get(REM.WF_RMH__c) != NULL && Invoice_map.get(PR.Payment__r.Debtor__c+InvName) != NULL)
                                        {
                                            if(Map_RME_JO != NULL && Map_RME_JO.containsKey(string.valueOf(REM.WF_RMH__c) + string.valueOf(PR.ID)))
                                            {
                                                akritiv__Payment_Line__c pl = new akritiv__Payment_Line__c();
                                                pl.akritiv__Applied_Amount__c = REM.Remittance_net_amount_paid_formula__c;
                                                //  pl.WF_Applied_Amount__c = Double.valueof(string.valueof(REM.Remittance_net_amount_paid__c).mid(0,string.valueof(REM.Remittance_net_amount_paid__c).length()-2) +'.'+ string.valueof(REM.Remittance_net_amount_paid__c).right(2));
                                                pl.WF_Applied_Amount__c = Invoice_map.get(PR.Payment__r.Debtor__c+InvName).Balance_Internex__c;
                                                pl.akritiv__Applied_To__c = Invoice_map.get(PR.Payment__r.Debtor__c+InvName).id;
                                                pl.akritiv__Payment__c = Map_RME_JO.get(string.valueOf(REM.WF_RMH__c) + string.valueOf(PR.ID)).WF_PR__r.Payment__c;
      
                                                Map_RME_JO.get(string.valueOf(REM.WF_RMH__c) + string.valueOf(PR.ID)).PaymentLineItemCreated__c = True;
                                                pl.PR_and_RMH__c = Map_RME_JO.get(string.valueOf(REM.WF_RMH__c) + string.valueOf(PR.ID)).Name;
                                            	
                                                //   pl.Flag_for_Line_Amount__c = True;
                                                Update_paymentline.add(pl);
                                            }
                                        }
                                    }
                                }
                            } 
                            if(Update_paymentline.size() > 0)
                            {
                                system.debug('Update_paymentline--> '+Update_paymentline);
                                insert Update_paymentline;
                                update Map_RME_JO.values();
                            }
                        }
                    }
                }
            }
        }
        system.debug('---> REM After Trigger end <---');
    }
}