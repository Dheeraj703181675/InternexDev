Public class sendCalloutREST
{
  /*   @future (callout=true)
    public static void  Quickbookintegration{
        try{
            Httprequest request = new HttpRequest();
            Http http = new Http();
            
            request.setMethod('POST');
            request.setEndpoint('https://financialdatafeed.platform.intuit.com');
            request.setHeader('Content-Type', 'application/json');
            // Header info with remote server user name and password
            req.setHeader(‘X-Username’, ‘{!$Credential.UserName}’);
			req.setHeader(‘X-Password’, ‘{!$Credential.Password}’);
            req.setHeader(‘Authorization’, ‘OAuth {!$Credential.OAuthToken}’);
            //Check the client certificate
         //   request.setClientCertificateName('Sample-Rest-Self-Signed');
            // timeout in milliseconds       
            request.setTimeout(120000); 
            request.setBody(jsonString);          
            
            //Making call to external REST API
            HttpResponse response = http.send(request);  
            
            System.debug('responseBody: '+response.getBody());
        }catch(Exception e){
            System.debug('Error::'+e.getMessage());
        }
    }*/
    // Pass in the endpoint to be used using the string url
 /* public void getCalloutResponseContents() {
      
      HttpRequest req = new HttpRequest();
      req.setEndpoint('	https://financialdatafeed.platform.intuit.com');
      req.setMethod('GET');
      // Because we didn't set the endpoint as a named credential, 
      // our code has to specify:
      // - The required username and password to access the endpoint
      // - The header and header information
      
      String username = '{!$Credential.UserName}';
      String passwrd = '{!$Credential.Password}';
      
      Blob headerValue = Blob.valueOf(username + ':' + passwrd);
      String authorizationHeader = 'BASIC ' +
          EncodingUtil.base64Encode(headerValue);
      req.setHeader('Authorization', authorizationHeader);
      
      // Create a new http object to send the request object
      // A response object is generated as a result of the request  
      
      Http http = new Http();
      HTTPResponse res = http.send(req);
      System.debug(res.getBody());
  }*/
}