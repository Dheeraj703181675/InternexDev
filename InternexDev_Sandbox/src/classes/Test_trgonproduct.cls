@istest
public class Test_trgonproduct
{
    
    static testmethod void Test_trgonProduct()
    {
        Product__c product = new Product__c();
        product.Name= 'Anki' ;
        
        insert product;
        
        product.Name = 'Anki';
        update product;
        
         //Product__c product2 = new Product__c();
        //product2.Name= 'Anki' ;
        
       // insert product2; 
        
        
    }
    
    
     static testmethod void Test_trgonProduct2()
    {
        
        
        Product__c product1 = new Product__c();
        product1.Name= 'Loan' ;
        
        insert product1;
        product1.Name='Line of Credit';
        update product1;
        
    }

}