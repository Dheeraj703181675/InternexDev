@isTest
public class TestHttpRequesttoESB {
	public static testmethod void testrequesttoQB()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
           // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
       String actualValue = HttpRequesttoESB.getContent('http://api.salesforce.com/foo/bar', 'GET', 'BasicAuth', 'Objct', 'whr', 'RealmID', 'ConsumerKey', 'ConsumerSecret', 'OauthToken', 'AccessTokenSecret', 'ClientID', 'PortalClientID','ClientName');
        
        // Verify response received contains fake values
  //      String contentType = res.getHeader('Content-Type');
  //      System.assert(contentType == 'application/json');
   //     String actualValue = res.getBody();
   		system.debug('==> '+ actualValue);     
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
       // System.assertEquals(200, res.getStatusCode());
    }
}