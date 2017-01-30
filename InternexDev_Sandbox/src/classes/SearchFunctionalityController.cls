/*
 * Copyright (c) 2012-2013 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */

/*
 * Usage : #Used to search and select invoices for particular account with different criteria, 
            like selecting Due Date of Invoice from Date Ranges and Invoice balance with different operators.  
 */
public with sharing class SearchFunctionalityController{

    public list<TxLabelListWithAttributesSearch> searchListLabel{get;set;}
   
    public list<String> searchListName{get;set;}
    public list<String> searchListFieldType{get;set;}  
    public list<SearchFilterConfig__c> SearchFields;
       
    public String reRenderStr{get;set;}
    public String sectionTitle{get;set;}
    
    public String globalfilter{get;set;}
    public akritiv__Temp_Object_Holder__c TempKey12{get;set;}
    
    //public sObject obj1{get;set;}
    public List<Selectoption> DateRange{get;set;}
    public List<Selectoption> Operator{get;set;}
    public List<Selectoption> FormType{get;set;}
   
    public String Value1;
    public String Value2;
    
    public Map<String,list<SelectOption>> picklistMap{get;set;}
    public String pickedVal{get;set;}
    public boolean buyerUser; 
    public List<Selectoption> CFormReq{get;set;}
    public List<Selectoption> booleanPicklist{get;set;}
    public String accId; 

    
    
   /* public SObject obj;
    public void setobj(SObject o){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjName);//From the Object Api name retrieving the SObject
        obj = targetType.newSObject();    
    }
    public SObject getobj(){
        return obj;
    }*/
   
   
    public String ObjectName;   

    public void setobjectName (String s) {
        ObjectName = s;
        getSearch();
    }
    
    public String getobjectName() {
            return ObjectName;
    }
    
    public Map<String,String> customFieldDataTypeMap = new Map<String,String>();
    public Map<String,String> customFieldLabelMap = new Map<String,String>();
    public Static Map<String,String> customFieldValue1Map = new Map<String,String>();
    public Static Map<String,String> customFieldValue2Map = new Map<String,String>();
    public Static Map<String,String> SelectedOperatorMap = new Map<String,String>();
    public Static Map<String,String> SelectedFormTypeMap = new Map<String,String>();
   
    
    public SearchFunctionalityController(){
    DateRange = new List<Selectoption>();   
        DateRange.add(new selectOption('','Select Date Range'));
        DateRange.add(new selectOption('L30','Last 30 Days'));
        DateRange.add(new selectOption('L60','Last 60 Days'));
        DateRange.add(new selectOption('L90','Last 90 Days'));
        DateRange.add(new selectOption('N30','Next 30 Days'));
        DateRange.add(new selectOption('N60','Next 60 Days'));
        DateRange.add(new selectOption('N90','Next 90 Days'));   
          
        Operator = new List<Selectoption>(); 
         Operator.add(new selectOption('','Select Operator'));
       Operator.add( new Selectoption('=','Equal To'));
       Operator.add( new Selectoption('<>','Not Equal To'));
       Operator.add( new Selectoption('>','Greater Than '));
       Operator.add( new Selectoption('>=','Greater Than or Equals To '));
       Operator.add( new Selectoption('<','Less Than '));
       Operator.add( new Selectoption('<=','Less Than or Equals To '));
           
        FormType = new List<Selectoption>(); 
         FormType.add(new selectOption('','Select Form Type'));
         FormType.add( new Selectoption('C','C-Form'));
         FormType.add( new Selectoption('H','H-Form'));
         FormType.add( new Selectoption('I','I-Form'));
               
        CFormReq = new List<Selectoption>(); 
         CFormReq.add(new selectOption('All','All'));
         CFormReq.add( new Selectoption('Yes','Yes'));
         CFormReq.add( new Selectoption('No','No')); 
           
        booleanPicklist = new List<Selectoption>(); 
         booleanPicklist.add(new selectOption('','--None--'));
         booleanPicklist.add( new Selectoption('True','Yes'));
         booleanPicklist.add( new Selectoption('False','No'));
                
    }
     
    public void getSearch(){
        try{
        Schema.SObjectType targetType;
        Sobject Object_name;
        String sobjApi = objectName;
        System.debug('==objectName====='+objectName);
        if(objectName.contains(':')){
            sobjApi = objectName.split(':')[0].trim();
          targetType = Schema.getGlobalDescribe().get(sobjApi);//From the Object Api name retrieving the SObject
          Object_name = targetType.newSObject();
         }else{
            targetType = Schema.getGlobalDescribe().get(objectName);//From the Object Api name retrieving the SObject
        Object_name = targetType.newSObject(); 
         }
                       
        Schema.Sobjecttype objType = Object_name.getSObjectType();
        Schema.Describesobjectresult sobjRes = objType.getDescribe();
        //Schema.DescribeFieldResult fieldResult = objType.Status__c.getDescribe();
        Map<String, Schema.Sobjectfield> fieldMap = sobjRes.fields.getMap();
        List<String> sortSelectOption = new List<String>(fieldMap.keyset());
        system.debug('==================='+fieldMap);
        sortSelectOption.sort();
        String fieldType;
        String fieldName;
        String fieldLabel;
        for(String a : sortSelectOption){
            Schema.Sobjectfield field = fieldMap.get(a);
            fieldName = field.getDescribe().getName();
            fieldType = field.getDescribe().getType().name();
            fieldLabel = field.getDescribe().getLabel();
            //system.debug('=========fieldLabel =========='+fieldLabel );
            customFieldDataTypeMap.put(fieldName,fieldType);
            customFieldLabelMap.put(fieldName,fieldLabel);
        }
        
        Profile profile = [ SELECT Profile.Name FROM Profile where Id = :UserInfo.getProfileId() ];
        String profileName =  Profile.Name; 
        System.debug('==profileName =='+profileName);
        
        reRenderStr = '';
        
        searchListLabel = new list<TxLabelListWithAttributesSearch>();
        searchListName = new list<string>();
        searchListFieldType = new list<string>();
        SearchFields = new list<SearchFilterConfig__c>();
        
        SearchFields = [select name, SearchFields__c, reRenderBlock__c,sectionTitle__c,RestrictedFields__c from SearchFilterConfig__c Where name =: objectName];
        string Fields = '';
        if(SearchFields.size()>0){
            
            Fields= string.valueOf(SearchFields[0].SearchFields__c);
            reRenderStr = string.valueOf(SearchFields[0].reRenderBlock__c);
            sectionTitle = string.valueOf(SearchFields[0].sectionTitle__c);
            string restrictedFields =  string.valueOf(SearchFields[0].RestrictedFields__c);
            
            
            picklistMap = new Map<String,list<SelectOption>>(); 
            for(String nextFld : Fields.split(',')) {
                if(customFieldDataTypeMap.get(nextFld) == 'PICKLIST'){
                
                    System.debug('--nextFld---'+nextFld);
                  // Get the list of picklist values for this field.
                  list<Schema.PicklistEntry> values = fieldMap.get(nextFld).getDescribe().getPickListValues();
                    List<SelectOption> options = new List<SelectOption>();
                     
                    System.debug('--values ---'+values );
                 //   Schema.DescribeFieldResult fieldResult = sobjRes.status__c.getDescribe();
                 //  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
                     options.add(new SelectOption('','--None--'));
                    for( Schema.PicklistEntry f : values)
                    {
                         options.add(new SelectOption(f.getLabel(), f.getValue()));
                    }     
                    System.debug('--options---'+options);
                    picklistMap.put(nextFld ,options);
                }   
            }
            system.debug('-------picklistMap---->>>'+picklistMap );
            system.debug('-------restrictedFields ---->>>'+restrictedFields );
            Map<String,String> prfFieldName = new Map<String,String>();
            String[] resFields;
            if(restrictedFields != null && restrictedFields != ''){
                resFields = restrictedFields.split('\\)');
              for (String objFieldList:resFields){
                  system.debug('-------obj---->>>'+objFieldList);
                  objFieldList.remove(' ');
                  String[] prfname= objFieldList.split('\\(');
                  system.debug('-------prfname[1]---->>>'+prfname[1]);
                  system.debug('-------prfname[0]---->>>'+prfname[0]);
                 
                  system.debug('------- prfname[0].split---->>>'+ prfname[0].remove(':').trim());
                  
                  prfFieldName.put(prfname[0].remove(':').trim(),prfname[1].trim());
              }
              system.debug('-------prfFieldName---->>>'+prfFieldName);
            }
          //profileName = 'Supplier';
            boolean addfield;
            for(String nextField : Fields.split(',')) {
                addfield = true;
                if(prfFieldName.containsKey(profileName)){
                    system.debug('====prfFieldName.get(profileName)======'+prfFieldName.get(profileName));
                   for(String restrfld : prfFieldName.get(profileName).split(',')) {
                           if(nextField.trim() == restrfld.trim()){
                               //searchListName.add(nextField);
                               addfield = false;
                           }     
                    }
                    if(addfield == true){
                        searchListName.add(nextField);
                    }
                }else{
                    searchListName.add(nextField); 
                }
            }
            System.debug('&&&&&&&&&&&&&&&&&&&&&&'+searchListName);
            
         accId =  ApexPages.currentPage().getParameters().get('accId');
         list<account> ac = new  list<account>();
        if(accId != '' && accId != null)
      ac = [Select Name, accountNumber from Account where id =:accId];
            
           for(String srField : searchListName){
               if(srField == 'akritiv__Account__c'){
                    if(accId != null && accId != ''){
                        searchListLabel.add(new TxLabelListWithAttributesSearch(customFieldDataTypeMap.get(srField),'Account Name / Account Number',ac.get(0).Name,'',srField)); 
                    }else{  
                        searchListLabel.add(new TxLabelListWithAttributesSearch(customFieldDataTypeMap.get(srField),'Account Name / Account Number','','',srField));
                    }
               }else if(srField == 'C_Form_Required__c' || srField == 'TDS_Required__c'){
                    if(srField == 'C_Form_Required__c'){
                        searchListLabel.add(new TxLabelListWithAttributesSearch(customFieldDataTypeMap.get(srField),'Form Required','Yes','',srField)); 
                    }else{
                        searchListLabel.add(new TxLabelListWithAttributesSearch(customFieldDataTypeMap.get(srField),customFieldLabelMap.get(srField),'Yes','',srField)); 
                    }
                 }else if(srField == 'C_Form_Received__c'){
                  searchListLabel.add(new TxLabelListWithAttributesSearch(customFieldDataTypeMap.get(srField),'Form Received','','',srField)); 
                 }else{
                     searchListLabel.add(new TxLabelListWithAttributesSearch(customFieldDataTypeMap.get(srField),customFieldLabelMap.get(srField),'','',srField));
                 }           
          }
               System.debug('---searchListLabel----'+searchListLabel+'---searchListName----'+searchListName+'-----searchListFieldType------'+searchListFieldType);    
          }else{
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please configure Custom Setting Properly'));
        }
    }catch(exception e){
          System.debug('######==Error===='+e);
      }
  } 
    
     public string searchRes(){
         // TempKey12.akritiv__Key__c = '';
            globalfilter = ''; 
            System.debug('====sc.customFieldValue1Map in search methjod====='+customFieldValue1Map);
             
            System.debug('---searchListLabel----'+searchListLabel);
            Value1 = '';
            Value2 = '';
            String selOperator = '';
            String SelFormType = '';
            for(TxLabelListWithAttributesSearch objsearchListLabel :searchListLabel){
              Value1 = customFieldValue1Map.get(objsearchListLabel.fieldAPI);
                Value2 = customFieldValue2Map.get(objsearchListLabel.fieldAPI); 
                selOperator = SelectedOperatorMap.get(objsearchListLabel.fieldAPI);
                SelFormType = SelectedFormTypeMap.get(objsearchListLabel.fieldAPI);
                System.debug('======Value1======'+Value1);  
                System.debug('======Value2======'+Value2);
                System.debug('======objsearchListLabel======'+objsearchListLabel);           
                 System.debug('---selOperator ----'+selOperator );   
               
                 if(globalfilter != '' && ((Value1 != '' && Value1 != null) || (Value2 != '' && Value2 != null) ))
                  globalfilter = globalfilter + ' AND ';
                 
               
                 if(objsearchListLabel.fieldType == 'String' && Value1 != '' && Value1 != null){
                  Value1 = string.escapeSingleQuotes(Value1);

                                if((objsearchListLabel.fieldAPI == 'C_Form_Required__c' || objsearchListLabel.fieldAPI == 'TDS_Required__c') ){
                                     if(Value1 == 'All'){
                                         Value1 = '';  
                                     }
                                     
                                     //========================Synchronising Forms C ,H and I forms=================================== 
                                     
                                     if(objsearchListLabel.fieldAPI == 'C_Form_Required__c'){
                                         if(SelFormType == null || SelFormType == ''){
                                             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter Form Type for '+objsearchListLabel.fieldLabel+' field'));
                                             return null;
                                         }
                                         if(SelFormType.equalsIgnoreCase('H')){
                                             objsearchListLabel.fieldAPI = 'H_Form_Required__c';
                                            
                                         }else if(SelFormType.equalsIgnoreCase('I')){
                                             objsearchListLabel.fieldAPI = 'I_Form_Required__c';
                                         }
                                     }    
                                     //===============================================================================================     
                                 }

                   if(Value1.contains(',')){
                       //Value1 = '(' + Value1 + ')';
                       String tempstr = '(';
                       for(String st : Value1.split(',')){
                           if(st != '' && st != null)
                           tempstr += '\'' + st.trim() + '\',';
                       }
                      tempstr = tempstr.Substring(0,tempstr.length()-1) + ')';
                       System.debug('=====tempstr ===='+tempstr );
                       
                        globalfilter = globalfilter + +objsearchListLabel.fieldAPI + ' IN ' + tempstr ;
                       System.debug('=====globalfilter in string===='+globalfilter );
                   }else{
                   
                       if(Value1.contains('%')){
                           globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' Like ' + '\'' + Value1.trim() + '\'';    
                       }else{
                           globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' Like ' + '\'%' + Value1.trim() + '%\'';
                       }
                   }
                  
              
               }else if(objsearchListLabel.fieldType == 'BOOLEAN' && Value1 != null && Value1 != ''){
                    //========================Synchronising Forms C ,H and I forms=================================== 
                         if(objsearchListLabel.fieldAPI == 'C_Form_Received__c'){
                             if(SelFormType == null || SelFormType == ''){
                                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter Form Type for '+objsearchListLabel.fieldLabel+' field'));
                                 return null;
                             }
                             if(SelFormType.equalsIgnoreCase('H')){
                                 objsearchListLabel.fieldAPI = 'H_Form_Received__c';
                                
                             }else if(SelFormType.equalsIgnoreCase('I')){
                                 objsearchListLabel.fieldAPI = 'I_Form_Received__c';
                             }
                         }
                   //===============================================================================================     
                   Value1 = string.escapeSingleQuotes(Value1);
                   if(Value1 == 'All'){
                       Value1 = '';  
                   }
                   if(Value1 != ''){
                       globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' = ' + Value1.trim();
                   }
                   
               }else if(objsearchListLabel.fieldType == 'DOUBLE' || objsearchListLabel.fieldType == 'CURRENCY'){
                   if(Value1 != '' && Value1 != null ){
                       boolean check1 = pattern.matches('[0-9.,-]+',Value1);
                       
                       if (check1 == false ) {
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter numeric value for '+objsearchListLabel.fieldLabel+' field'));
                           return null;
                       }
                       if(Value1.countMatches('.')>1){
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter only one \'.\' for '+objsearchListLabel.fieldLabel+' field'));
                           return null;
                       }
                       /*if(Value1.contains(',')){
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter value without \',\' for '+objsearchListLabel.fieldLabel+' field'));    
                           return null;
                       }*/
                       
                        Value1 = Value1.replace(',','').replace('USD ','');
                       system.debug('==Value1=='+Value1);
                      // double cur1 = double.valueOf(Value1);
                       //system.debug('==cur1 =='+cur1);
                       
                   /*    if(Value1.contains('.')){
                           String [] v1 = Value1.split('\\.');
                           system.debug('==v1[0]=='+v1);
                           if(v1[0].length() > 7){
                               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter valid length of value for '+objsearchListLabel.fieldLabel+' field'));
                                return null;
                           }
                       }else{
                           if(Value1.length() >7){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter valid length of value for '+objsearchListLabel.fieldLabel+' field'));
                                return null; 
                              
                           }
                       }    */
                       decimal cur1 = 0.0;
                       if(!Value1.contains('.')){
                           Value1 = Value1 + '.0';    
                       }
                        String [] v1 = Value1.split('\\.');
                           system.debug('==v1[0]=='+v1);
                           if(v1[0].length() > 24){
                               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter valid length of value for '+objsearchListLabel.fieldLabel+' field'));
                                return null;
                           }
                     
                      cur1 = decimal.valueOf(Value1);
                     // decimal cur1 = decimal.valueOf(Value1);
                       if(selOperator != '' && selOperator != null)
                           globalfilter = globalfilter + objsearchListLabel.fieldAPI+ ' ' + selOperator + ' ' + cur1 ; 
                       else{
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select operator for '+objsearchListLabel.fieldLabel+' field'));
                           return null;
                       }
                       
                       
                   }
                             
               }
               
              /* else if(objsearchListLabel.fieldType == 'CURRENCY'){
                  
                   if(Value1 != '' && Value2 != '' && Value1 != null && Value2 != null){
                       
                       boolean check1 = pattern.matches('[0-9]+',Value1);
                       boolean check2 = pattern.matches('[0-9]+',Value2);
                       if (check1 == false || check2 == false) {
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter numeric value for '+objsearchListLabel.fieldLabel+' field'));
                           
                           return null;
                       }
                       
                       double cur1 = double.valueOf(Value1);
                       double cur2 = double.valueOf(Value2);
                       if(cur1 > cur2 )
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Second value must be greater than first value for '+objsearchListLabel.fieldLabel+' field'));
                       else
                           globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' >= ' + cur1 + ' AND '+ objsearchListLabel.fieldAPI + ' <= '+ cur2; 
                   
                   }else if(Value1 != '' && Value1 != null){
                       boolean check1 = pattern.matches('[0-9]+',Value1);
                       if (check1 == false) {
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter numeric value for '+objsearchListLabel.fieldLabel+' field'));
                           
                           return null;
                       }
                       double cur1 = double.valueOf(Value1);
                       globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' >= ' + cur1;
                       
                   }else if(Value2 != '' && Value2 != null){
                       boolean check2 = pattern.matches('.[0-9].+',Value2);
                       if (check2 == false) {
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter numeric value for '+objsearchListLabel.fieldLabel+' field'));
                           
                           return null;
                       }
                   
                       double cur2 = double.valueOf(Value2);
                       globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' <= ' + cur2; 
                   }
                             
               } */
               else if(objsearchListLabel.fieldType == 'REFERENCE' && Value1 != '' && Value1 != null){
                   
                   String refField = (objsearchListLabel.fieldAPI).subString(0,(objsearchListLabel.fieldAPI).length()-1)+ 'r.Name';
                   Value1 = string.escapeSingleQuotes(Value1);
                 /*A  if(Value1.contains('%')){
                       globalfilter = globalfilter + refField  + ' Like ' + '\'' + Value1 + '\'';
                   }else{
                       globalfilter = globalfilter + refField  + ' Like ' + '\'%' + Value1 + '%\'';    
                   } */
                   
                   if(objsearchListLabel.fieldAPI == 'akritiv__Account__c'){
                       String refField1= '';
                       refField1 = (objsearchListLabel.fieldAPI).subString(0,(objsearchListLabel.fieldAPI).length()-1)+ 'r.AccountNumber';
                      
                       if(Value1.contains('%')){
                           globalfilter = globalfilter +'('+ refField  + ' Like ' + '\'' + Value1 + '\''  +  ' OR '+ refField1 + ' Like ' + '\'' + Value1 + '\')';
                       }else{
                           globalfilter = globalfilter +'('+ refField  + ' Like ' + '\'%' + Value1 + '%\''  +  ' OR '+ refField1 + ' Like ' + '\'%' + Value1 + '%\')';    
                       }    
                   }else{
                       if(Value1.contains('%')){
                           globalfilter = globalfilter + refField  + ' Like ' + '\'' + Value1 + '\'';
                       }else{
                           globalfilter = globalfilter + refField  + ' Like ' + '\'%' + Value1 + '%\'';    
                       }
                   }
               
             /*  }else if(objsearchListLabel.fieldType == 'PICKLIST' && obj1.get( objsearchListLabel.fieldAPI ) != null){
               
                  
                    System.debug('======PickList======'+obj1.get( objsearchListLabel.fieldAPI ));
                    globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' = ' + '\'' + obj1.get( objsearchListLabel.fieldAPI ) + '\'';*/
                 
               }else if(objsearchListLabel.fieldType == 'PICKLIST' && value1 != null && value1 != ''){
                   System.debug('======PickList======'+Value1);
                    globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' = ' + '\'' + value1 + '\'';
                    
               }else if(objsearchListLabel.fieldType == 'DATE'){
          String D1 = Value1;
                    String D2 = Value2;
                    System.debug('======Date1======'+Value1);
                    if(D1 != null && D1 != ''){
                        
                            String dateCheck = '^(0[1-9]|1[012]|[1-9])[-/ ]?(0[1-9]|[12][0-9]|3[01]|[1-9])[ -/]?(18|19|20|21)\\d{2}$';
                            boolean check1 = pattern.matches(dateCheck,D1);
                            system.debug('check1 ===='+check1 );
                            if(check1 == false){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Enter proper Date for '+objsearchListLabel.fieldLabel+' field')); 
                                return null;   
                            }
                    }
                    if(D2 != null && D2 != ''){
                            String dateCheck = '^(0[1-9]|1[012]|[1-9])[-/ ]?(0[1-9]|[12][0-9]|3[01]|[1-9])[ -/]?(18|19|20|21)\\d{2}$';
                            boolean check2 = pattern.matches(dateCheck,D2);
                            system.debug('check2 ===='+check2);
                            if(check2 == false){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Enter proper Date for '+objsearchListLabel.fieldLabel+' field')); 
                                return null;   
                            }
                    }
                    //Date Formation
                     String FromDate = '';
                     String ToDate = '';
                    
                    String DateDayFrom = '';
                    String DateMonthFrom = '';
                    String DateDayTo = '';
                    String DateMonthTo = '';

                    if(D1 != null && D1 != ''){
                        DateDayFrom = D1.split(' ').get(0).split('/').get(1);
                        DateMonthFrom = D1.split(' ').get(0).split('/').get(0);
                        String DateYearFrom = D1.split(' ').get(0).split('/').get(2);
                        
                        if(DateDayFrom.length()<2){
                            DateDayFrom = '0'+ DateDayFrom;
                        }    
                        if(DateMonthFrom.length()<2){
                            DateMonthFrom = '0'+ DateMonthFrom;
                        }
                        Integer numberDays = date.daysInMonth(integer.valueOf(DateYearFrom),integer.valueOf(DateMonthFrom));
                        System.debug('----numberDays ---'+numberDays );
                        
                        if(integer.valueOf(DateDayFrom) > numberDays){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter proper Date for '+objsearchListLabel.fieldLabel+' field.')); 
                            return null;    
                        }
                        FromDate =  D1.split(' ').get(0).split('/').get(2) + '-'  + DateMonthFrom  + '-' +DateDayFrom;
                        System.debug('===D1=='+D1);
                        System.debug('===FromDate =='+FromDate );
                    }
                    if(D2 != null && D2 != ''){
                        DateDayTo = D2.split(' ').get(0).split('/').get(1);
                        DateMonthTo = D2.split(' ').get(0).split('/').get(0);
                        String DateYearTo = D2.split(' ').get(0).split('/').get(2); 
                            
                        if(DateDayTo.length()<2){
                            DateDayTo = '0'+ DateDayTo;
                        }    
                        if(DateMonthTo.length()<2){
                            DateMonthTo = '0'+ DateMonthTo;
                        } 
                        
                        Integer numberDays = date.daysInMonth(integer.valueOf(DateYearTo),integer.valueOf(DateMonthTo));
                        System.debug('----numberDays ---'+numberDays );
                        
                        if(integer.valueOf(DateDayTo) > numberDays){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Enter proper Date for '+objsearchListLabel.fieldLabel+' field')); 
                            return null;    
                        }
                        
                        ToDate = D2.split(' ').get(0).split('/').get(2) + '-'  +DateMonthTo  + '-' +DateDayTo ;    
                    }
                    
                    if(FromDate != null && ToDate != null && FromDate != '' && ToDate != '')   
                        globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' >= ' + FromDate + ' AND '+ objsearchListLabel.fieldAPI + ' <= '+ ToDate; 
                    else if(FromDate != null && FromDate != '')
                        globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' >= ' + FromDate ; 
                    else if(ToDate != null && ToDate != '')
                        globalfilter = globalfilter + objsearchListLabel.fieldAPI + ' <= '+ ToDate;              
               }
           }
           System.debug('*******globalfilter ********'+globalfilter);
           if(Userinfo.getFirstName() != null && TempKey12 != null){
                TempKey12.akritiv__Key__c = Userinfo.getFirstName()+Datetime.now();
                
                TempKey12.akritiv__value__c = globalfilter;  
                //System.debug('*******TempKey12--component ********'+TempKey12); 
                upsert TempKey12;
            }
            return null;
       }
       
    public class TxLabelListWithAttributesSearch {
        transient public String txId {get; set; }
        public String fieldType {get; set; }
        public String fieldAPI {get; set; }   
        public String fieldLabel {get; set; }
        public String SelectedOperator1{get; set;}   
        public String SelectedForm{get;set;}  
        
          public String fieldValue1;
          
          public void setfieldValue1(String x){
             // SearchFunctionalityController sc = new SearchFunctionalityController();
              fieldValue1=x;
              
              SearchFunctionalityController.customFieldValue1Map.put(fieldAPI,fieldValue1);
              
              SearchFunctionalityController.SelectedOperatorMap.put(fieldAPI,SelectedOperator1);
               SearchFunctionalityController.SelectedFormTypeMap.put(fieldAPI,SelectedForm); 
              
              System.debug('====sc.customFieldValue1Map====='+SearchFunctionalityController.customFieldValue1Map);
             
              
          } 
           public String getfieldValue1() {
              return fieldValue1;
            } 
       
        public String fieldValue2;
          
          public void setfieldValue2(String x){
              SearchFunctionalityController sc = new SearchFunctionalityController();
              fieldValue2=x;
              SearchFunctionalityController.customFieldValue2Map.put(fieldAPI,fieldValue2);
              System.debug('====sc.customFieldValue2Map====='+SearchFunctionalityController.customFieldValue2Map);          
            } 
          public String getfieldValue2() {
              return fieldValue2;
         } 
        
        public TxLabelListWithAttributesSearch(){
        }  
        public TxLabelListWithAttributesSearch (String fieldType,String fieldLabel,String fieldValue1,String fieldValue2,String fieldAPI ){
            this.fieldType = fieldType;
            this.fieldLabel = fieldLabel;
            this.fieldValue1 = fieldValue1;            
            this.fieldValue2 = fieldValue2;                        
            this.fieldAPI = fieldAPI;                                    
        }
    }
    
     public static testMethod void  testStdDev1(){
        
        akritiv__Temp_Object_Holder__c temp = new akritiv__Temp_Object_Holder__c();
       
        temp.akritiv__Key__c = Userinfo.getFirstName()+Datetime.now();
        upsert temp;
        
        akritiv__Trigger_Configuration__c triggerConf = new akritiv__Trigger_Configuration__c();
                  triggerConf.akritiv__Update_Account_ContactLog_Details__c = false;
                  insert triggerConf;
        
        List<akritiv__Transaction__c> txInsert = new List<akritiv__Transaction__c>();
                  Account acc = new Account();
                   acc.Name = 'Test Account' + String.valueOf(Datetime.Now());
                   acc.akritiv__account_key__c = 'Test Account' + String.valueOf(Datetime.Now());
                   acc.Last_Auto_Dunning_Date__c = null;
                 	Acc.Funding_Limit__c = 1000;
                    Acc.Email__c = 'Test5@testing.com';
                    Acc.PAN_TAN__c = '123456780';
                    ACC.BillingState = 'NY';
                    ACC.BillingPostalCode = '99999';
                   acc.Sales_District__c = 'External';
                   insert acc; 
                   akritiv__Transaction__c tx = new akritiv__Transaction__c();
                   tx.Name = 'Inv-11121';
                   tx.akritiv__Account__c = acc.Id;
                   tx.akritiv__Balance__c = 2123;
                   tx.akritiv__Amount__c = 2133;
                   tx.akritiv__Due_Date__c = Date.Today() + 20;
                   tx.akritiv__Base_Balance__c = 5000;
                   txInsert.add(tx);
                   acc = new Account();
                   acc.Name = 'Test Account123' + String.valueOf(Datetime.Now());
                   acc.akritiv__account_key__c = 'Test Account123' + String.valueOf(Datetime.Now());
                   acc.Last_Auto_Dunning_Date__c = null;
                	Acc.Funding_Limit__c = 1000;
                    Acc.Email__c = 'Test1@testing.com';
                    Acc.PAN_TAN__c = '123456789';
                    ACC.BillingState = 'NY';
                    ACC.BillingPostalCode = '99999';
                   acc.Sales_District__c = 'External';
                   insert acc;
                   tx = new akritiv__Transaction__c();
                   tx.Name = 'Inv-11121123';
                   tx.akritiv__Account__c = acc.Id;
                   tx.akritiv__Balance__c = 2123;
                   tx.akritiv__Amount__c = 2133;
                   tx.akritiv__Due_Date__c = Date.Today() + 20;
                   tx.akritiv__Base_Balance__c = 5000;
                   txInsert.add(tx);
                   upsert txInsert;
     	system.assert(acc.PAN_TAN__c == '123456789');
         
        //akritiv__Transaction__c inv =  DataGenerator.invoiceInsert();
        //inv.gross_amount__c = 100;
        //Purchase_order__c po = DataGenerator.poInsert();
        //inv.PO__c = po.Id;
        //update inv;
     //  system.assertnotEquals(inv.Id,null);
       
        List<akritiv__Transaction__c> invlist = new List<akritiv__Transaction__c>();
        //invlist.add(inv);
        
       // akritiv__Temp_Object_Holder__c temp = DataGenerator.tempObjectInsert(invlist);
    
        String key = Userinfo.getUserName()+Datetime.now();
        akritiv__Temp_Object_Holder__c txIdsConfig = new akritiv__Temp_Object_Holder__c();
        txIdsConfig.akritiv__Key__c = key;
     
         SearchFilterConfig__c sf = new SearchFilterConfig__c();
         sf.Name = 'akritiv__Transaction__c';
         sf.reRenderBlock__c = 'pb2';
         sf.sectionTitle__c = 'Invoice Search';
         sf.SearchFields__c = 'Name,akritiv__Account__c,akritiv__Balance__c,akritiv__Create_Date__c,akritiv__Days_Past_Due__c,akritiv__Due_Date__c,C_Form_Required__c';
         sf.RestrictedFields__c = 'Akritiv User:(akritiv__Create_Date__c)';
         upsert sf;

         
        
          SearchFunctionalityController bac = new SearchFunctionalityController();
          TxLabelListWithAttributesSearch  txlab = new TxLabelListWithAttributesSearch ();
           String ObjName1;
           ObjName1 = 'akritiv__Transaction__c';
          // bac.globalfilter = 'test';
          // bac.Value2 = 'test';
          // bac.Value1 = 'test';
           bac.TempKey12 = new akritiv__Temp_Object_Holder__c();
          bac.setobjectName(ObjName1);
          bac.searchRes();

          ApexPages.currentPage().getParameters().put('accId',acc.id);

          bac = new SearchFunctionalityController();
          bac.setobjectName(ObjName1);
          txlab.fieldAPI= 'Name';
          txlab.setfieldValue1('test');
          txlab.getfieldValue1();
          
          txlab.fieldAPI= 'akritiv__Account__c';
          txlab.setfieldValue1('XYZ');
          txlab.getfieldValue1();
          
          txlab.fieldAPI= 'akritiv__Balance__c';
          txlab.SelectedOperator1 = '>';
          txlab.setfieldValue1('1');
          txlab.getfieldValue1();
          
          txlab.fieldAPI= 'akritiv__Create_Date__c';
          txlab.setfieldValue1('10/12/2012');
          txlab.getfieldValue1();
          txlab.setfieldValue2('12/12/2012');
          txlab.getfieldValue2();
          
          txlab.fieldAPI= 'LC_Stage__c';
          txlab.setfieldValue1('Original LC received');
          txlab.getfieldValue1();
         
         bac.searchRes();
         // SearchFunctionalityController.TxLabelListWithAttributesSearch.fieldAPI = 'Name';
          //bac.searchRes();
          bac.getobjectName();
       
     } 
    
}