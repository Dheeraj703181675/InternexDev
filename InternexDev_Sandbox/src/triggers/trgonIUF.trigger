trigger trgonIUF on IUF__c (Before insert,Before Update, Before Delete,After insert,after Update,After Delete) {
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            set<string>clientAccountSet = new Set<string>();
            for(IUF__c IUF : Trigger.New)
            {
                if(IUF.Type__c == 'Manual')
                {
                    if(IUF.IUF_Retained__c == 0.0 || IUF.IUF_Retained__c == NULL)
                    {
                        if(IUF.Interest_Due_Recovered__c == NULL)
                            IUF.Interest_Due_Recovered__c = 0;
                        if(IUF.UL_Fee_Due_Recovered__c == NULL)
                            IUF.UL_Fee_Due_Recovered__c = 0;
                        IUF.IUF_Retained__c = IUF.Interest_Due_Recovered__c + IUF.UL_Fee_Due_Recovered__c;
                    }
                    else
                    {
                        if(IUF.Interest_Due_Recovered__c == NULL)
                            IUF.Interest_Due_Recovered__c = 0;
                        if(IUF.UL_Fee_Due_Recovered__c == NULL)
                            IUF.UL_Fee_Due_Recovered__c = 0;
                        IUF.IUF_Retained__c += IUF.Interest_Due_Recovered__c + IUF.UL_Fee_Due_Recovered__c;
                    } 
                    clientAccountSet.add(IUF.Client_Account__c);
                }
            }
            map<string,Client_Account__c> Clientaccountmap = new map<string,Client_Account__c>([Select id,Additional_IUF_Required__c,Sum_of_IUF_Retained__c,Sum_of_IUF_Used__c from Client_Account__c where id in : clientAccountSet]);
            if(Clientaccountmap != NULL)
            {
                for(IUF__c IUF : Trigger.New)
                {
                    if(IUF.Type__c == 'Manual')
                    {
                        if(Clientaccountmap.containsKey(IUF.Client_Account__c))
                        {
                            if(IUF.Opening_IUF_Retained__c == NULL)
                            {
                                IUF.Opening_IUF_Retained__c = Clientaccountmap.get(IUF.Client_Account__c).Sum_of_IUF_Retained__c - Clientaccountmap.get(IUF.Client_Account__c).Sum_of_IUF_Used__c;
                            }
                        }
                    }
                } 
            }
        }
    }
    if(Trigger.isAfter)
    {
      //  set<string> IUF_Set = new Set<String>();
        set<string> ClientAccount_Set = new Set<String>();
        list<FIU_Report__c> FIU_List = new List<FIU_Report__c>();
        If(Trigger.isInsert )//|| Trigger.isUpdate
        {
            for(IUF__c IUF : Trigger.New)
            {
                ClientAccount_Set.add(IUF.Client_Account__c);
            }
            Map<string,Client_Account__c> map_ClientAccount = new Map<string,Client_Account__c>([Select id,Name,FIU_Outstanding__c,IUF_Reserve_Retained__c,Interest_Due__c,UL_Fee_Due__c,Interest_Due_Since__c,UL_Fee_Due_Since__c from Client_Account__c where id in: ClientAccount_Set]);
            
            if(Trigger.isInsert)
            {
                FIU_Report__c FR;
                for(IUF__c IUF : Trigger.New)
                {
                    if(IUF.Type__c == 'Manual')
                    {
                        if(IUF.Interest_Due_Recovered__c != 0.0 || IUF.UL_Fee_Due_Recovered__c != 0.0)//IUF.IUF_Retained__c != 0.0 || IUF.Interest_Due_Recovered__c != 0.0 || IUF.UL_Fee_Due_Recovered__c != 0.0
                        {
                            Decimal InterestDue = 0,ULFeeDue = 0;
                            if(map_ClientAccount != NULL &&  map_ClientAccount.get(IUF.Client_Account__c) != NULL)
                            {
                                if(map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c != NULL)
                                    InterestDue = map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c;
                                if(map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c != NULL)
                                    ULFeeDue = map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c;
								InterestDue = InterestDue.setScale(2);
                                ULFeeDue = ULFeeDue.setScale(2);
                                system.debug('InterestDue-> '+ InterestDue);system.debug('ULFeeDue-> '+ ULFeeDue);
                                if(InterestDue > 0)
                                {
                                    if(IUF.Interest_Due_Recovered__c <= InterestDue)
                                    {
                                        if(IUF.Interest_Due_Recovered__c == InterestDue)
                                        {
                                            map_ClientAccount.get(IUF.Client_Account__c).Interest_Due_Since__c = NULL;
                                            map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c = 0;
                                        }
                                        else
                                        {
                                            map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c -= IUF.Interest_Due_Recovered__c;
                                        }
                                    }
                                    else
                                    {
                                        IUF.Interest_Due_Recovered__c.addError('You can not give more than Client-Account Interest Fee Due.');
                                    }
                                    if(ULFeeDue > 0)
                                    {
                                        if(IUF.UL_Fee_Due_Recovered__c <= ULFeeDue)
                                        {
                                            if(IUF.UL_Fee_Due_Recovered__c == ULFeeDue)
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due_Since__c = NULL;
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c = 0;
                                            }
                                            else
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c -= IUF.UL_Fee_Due_Recovered__c;
                                            }
                                        }
                                        else
                                        {
                                            IUF.UL_Fee_Due_Recovered__c.addError('You can not give more than Client-Account UL Fee Due.');
                                        }
                                    }
                                }
                                else
                                {
                                    if(ULFeeDue > 0)
                                    {
                                        if(IUF.UL_Fee_Due_Recovered__c <= ULFeeDue)
                                        {
                                            if(IUF.UL_Fee_Due_Recovered__c == ULFeeDue)
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due_Since__c = NULL;
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c = 0;
                                            }
                                            else
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c -= IUF.UL_Fee_Due_Recovered__c;
                                            }
                                        }
                                        else
                                        {
                                            IUF.UL_Fee_Due_Recovered__c.addError('You can not give more than Client-Account UL Fee Due.');
                                        }
                                    }
                                }
                            }
                            
                            FR = new FIU_Report__c();
                            FR.Transaction_Name__c = 'Manual IUF Entry';
                            FR.Transaction_ID__c = IUF.Name;
                            FR.Date__c = IUF.Date__c;
                            //     FR.Payments__c = 0.0;
                            Double TotalIUF = IUF.Interest_Due_Recovered__c + IUF.UL_Fee_Due_Recovered__c;//+ IUF.IUF_Retained__c;
                            FR.Funding__c = TotalIUF;
                            FR.Reference__c = IUF.id;
                            FR.Client_Account__c = IUF.Client_Account__c;
                            if(map_ClientAccount != NULL &&  map_ClientAccount.get(IUF.Client_Account__c) != NULL)
                            {system.debug('--> '+ map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c);
                       /*      if(IUF.IUF_Retained__c != Trigger.oldMap.get(IUF.Id).IUF_Retained__c)//|| IUF.Interest_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).Interest_Due_Recovered__c || IUF.UL_Fee_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c
                             {
                                 Double Change_in_IUF = 0.0;
                                 if(IUF.IUF_Retained__c != Trigger.oldMap.get(IUF.Id).IUF_Retained__c)
                                     Change_in_IUF = Change_in_IUF + Trigger.oldMap.get(IUF.Id).IUF_Retained__c;
                                 if(IUF.Interest_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).Interest_Due_Recovered__c)
                                     Change_in_IUF = Change_in_IUF + Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c;
                                 if(IUF.UL_Fee_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c)
                                     Change_in_IUF = Change_in_IUF + Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c; 
                                 
                                 FR.Opening_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c - Change_in_IUF;
                                 FR.Closing_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c - Change_in_IUF + TotalIUF;
                             }
                             else
                             { */
                                 FR.Opening_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c - TotalIUF; //- Trigger.oldMap.get(IUF.Id).IUF_Retained__c;
                                 FR.Closing_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c;
                         //    }
                         //   }
                                FIU_List.add(FR);
                             }
                        }
                    }
                }
            }
          /*  if(Trigger.isUpdate)
            {
                set<string> Set_IUFids = new set<String>();
                for(IUF__c IUF : Trigger.New)
                {
                    if(IUF.Type__c == 'Manual')
                        Set_IUFids.add(IUF.Id);
                }
                try{
                    Delete[Select id from FIU_Report__c where Reference__c in : Set_IUFids];
                }catch(Exception e){system.debug('Exception==> '+ e);}
                for(IUF__c IUF : Trigger.New)
                {
                    if(IUF.Type__c == 'Manual')
                    {
                        if(IUF.Interest_Due_Recovered__c != 0.0 || IUF.UL_Fee_Due_Recovered__c != 0.0)//IUF.IUF_Retained__c != 0.0 || 
                        {
                            
                            Decimal InterestDue = 0,ULFeeDue = 0;
                            if(map_ClientAccount != NULL &&  map_ClientAccount.get(IUF.Client_Account__c) != NULL)
                            {
                                if(map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c != NULL)
                                    InterestDue = map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c;
                                if(map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c != NULL)
                                    ULFeeDue = map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c;
								InterestDue = InterestDue.setScale(2);
                                ULFeeDue = ULFeeDue.setScale(2);
                                system.debug('InterestDue-> '+ InterestDue);system.debug('ULFeeDue-> '+ ULFeeDue);
                                if(InterestDue > 0)
                                {
                                    if(IUF.Interest_Due_Recovered__c <= InterestDue)
                                    {
                                        if(IUF.Interest_Due_Recovered__c == InterestDue)
                                        {
                                            map_ClientAccount.get(IUF.Client_Account__c).Interest_Due_Since__c = NULL;
                                            map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c = 0;
                                        }
                                        else
                                        {
                                            map_ClientAccount.get(IUF.Client_Account__c).Interest_Due__c -= IUF.Interest_Due_Recovered__c;
                                        }
                                    }
                                    else
                                    {
                                        IUF.Interest_Due_Recovered__c.addError('You can not give more than Client-Account Interest Fee Due.');
                                    }
                                    if(ULFeeDue > 0)
                                    {
                                        if(IUF.UL_Fee_Due_Recovered__c <= ULFeeDue)
                                        {
                                            if(IUF.UL_Fee_Due_Recovered__c == ULFeeDue)
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due_Since__c = NULL;
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c = 0;
                                            }
                                            else
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c -= IUF.UL_Fee_Due_Recovered__c;
                                            }
                                        }
                                        else
                                        {
                                            IUF.UL_Fee_Due_Recovered__c.addError('You can not give more than Client-Account UL Fee Due.');
                                        }
                                    }
                                }
                                else
                                {
                                    if(ULFeeDue > 0)
                                    {
                                        if(IUF.UL_Fee_Due_Recovered__c <= ULFeeDue)
                                        {
                                            if(IUF.UL_Fee_Due_Recovered__c == ULFeeDue)
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due_Since__c = NULL;
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c = 0;
                                            }
                                            else
                                            {
                                                map_ClientAccount.get(IUF.Client_Account__c).UL_Fee_Due__c -= IUF.UL_Fee_Due_Recovered__c;
                                            }
                                        }
                                        else
                                        {
                                            IUF.UL_Fee_Due_Recovered__c.addError('You can not give more than Client-Account UL Fee Due.');
                                        }
                                    }
                                }
                            }
                            
                            FIU_Report__c FR = new FIU_Report__c();
                            FR.Transaction_Name__c = 'Manual IUF Entry';
                            FR.Transaction_ID__c = IUF.Name;
                            FR.Date__c = IUF.Date__c;
                          //     FR.Payments__c = 0.0;
                            Double TotalIUF = IUF.Interest_Due_Recovered__c + IUF.UL_Fee_Due_Recovered__c;// + IUF.IUF_Retained__c;
                            FR.Funding__c = TotalIUF;
                            FR.Reference__c = IUF.id;
                            FR.Client_Account__c = IUF.Client_Account__c;
                            if(map_ClientAccount != NULL &&  map_ClientAccount.get(IUF.Client_Account__c) != NULL)
                            {system.debug('--> '+ map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c);
                             if(IUF.IUF_Retained__c != Trigger.oldMap.get(IUF.Id).IUF_Retained__c )//|| IUF.Interest_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).Interest_Due_Recovered__c || IUF.UL_Fee_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c
                             {
                                 Double Change_in_IUF = 0.0;
                                 if(IUF.IUF_Retained__c != Trigger.oldMap.get(IUF.Id).IUF_Retained__c)
                                     Change_in_IUF = Change_in_IUF + Trigger.oldMap.get(IUF.Id).IUF_Retained__c;
                              //   if(IUF.Interest_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).Interest_Due_Recovered__c)
                              //       Change_in_IUF = Change_in_IUF + Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c;
                             //    if(IUF.UL_Fee_Due_Recovered__c != Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c)
                              //       Change_in_IUF = Change_in_IUF + Trigger.oldMap.get(IUF.Id).UL_Fee_Due_Recovered__c;
                                 
                                 FR.Opening_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c - Change_in_IUF;
                                 FR.Closing_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c - Change_in_IUF + TotalIUF;
                             }
                             else
                             {
                                 FR.Opening_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c - TotalIUF; //- Trigger.oldMap.get(IUF.Id).IUF_Retained__c;
                                 FR.Closing_FIU_Balance__c = map_ClientAccount.get(IUF.Client_Account__c).FIU_Outstanding__c;
                             }
                            }
                            FIU_List.add(FR);
                        }
                    }
                }
            }*/
            if(FIU_List.size() > 0)
            {
                insert FIU_List;
                update map_ClientAccount.values();
            }
        }
        if(Trigger.isDelete)
        {
            set<string> Set_IUFids = new set<String>();
            for(IUF__c IUF : Trigger.Old)
            {
                Set_IUFids.add(IUF.Id);
            }
            try{
                Delete[Select id from FIU_Report__c where Reference__c in : Set_IUFids];
            }catch(Exception e){system.debug('Exception==> '+ e);}
        }
    }
}