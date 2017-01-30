/*
 * Copyright (c) 2009-2010 Akritiv Technologies, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information
 * (Confidential Information) of Akritiv Technologies, Inc.  You shall not
 * disclose or use Confidential Information without the express written
 * agreement of Akritiv Technologies, Inc.
 */
/*
 * Usage: #to store the status of uploaded webcash file.
 */

public with sharing class WebCashUploadStatusController {
public String Lastdate{ get; set; }
    public Boolean isInProgress { get; set; }
    //public ID batchprocessid {get; set; }
    public AsyncApexJob aaj {get; set; }
    public Integer progress {get; set; }
    //public String globalDefault = 'Default';
    //public String custom = 'Custom';
    //public String selectedBatchJob {get; set; }

    //public String batchJobToRun {get; set; }
    //public String sourceSystem {get; set; }
    //public String batchNumber {get; set; }
    //public akritiv__BatchJobConfiguration_Singlec__c batchConfigObj {get; set; }
    //public Integer agingBatchSize {get; set; }
    //public Integer dataLoadBatchSize {get; set; }
    //public String aajStatus {get; set;}
    public String batchNo {get; set;}
    public String JobId{get; set;}
    public DateTime dtCreatedDate;
    public WebCash_Load_Batch__c objWebCashLoadBatch {get;set;}
    public List < WebCash_Load_Batch__c > wculst {get;set;}
    
  public WebCashUploadStatusController () {
        
            batchNo = ApexPages.currentPage().getParameters().get('batchNo');
            JobId= ApexPages.currentPage().getParameters().get('JobId');
            progress = 0;
            isInProgress = true;
            //String CreatedDate = '';//'2013-07-26T05:20:33.000Z';  
            //String JobId = '707e0000005P9fhAAC';
            
            System.Debug('** batchNo **'+batchNo);
            System.Debug('** JobId **'+JobId);
            
            objWebCashLoadBatch = [ select Name,
                                                Current_Job_Id__c,
                                                Current_Job_Message__c,
                                                Status__c
                                                from WebCash_Load_Batch__c
                                                where Name =: batchNo   ];
                      
            System.Debug('--webcash load batch record --'+objWebCashLoadBatch );                                          
                                                                
           wculst =   new List < WebCash_Load_Batch__c >();
           wculst.add(objWebCashLoadBatch );
       
     
    }
    
      public Pagereference refreshJobStatus() {        

       
            objWebCashLoadBatch = [ select Name,
                                                Current_Job_Id__c,
                                                Current_Job_Message__c,
                                                Status__c
                                                from WebCash_Load_Batch__c
                                                where Name =: batchNo   ];
            
            if(objWebCashLoadBatch != null && objWebCashLoadBatch.Status__c != null )
            {
                if(objWebCashLoadBatch.Status__c == 'Completed') 
                {
                 PageReference pageRef = new PageReference('/apex/webCashListViewPage?id='+ objWebCashLoadBatch.id);
                 pageRef.setRedirect(true);
                 return pageRef;
                }              
            }
        return null;
    }
}