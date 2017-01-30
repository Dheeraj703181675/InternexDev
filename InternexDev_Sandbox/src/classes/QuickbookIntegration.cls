public class QuickbookIntegration {
  /*  //  OAuth_Step1_getTempTokenAndRedirectToIntuit
    public Pagereference OAuth_Step1_getTempTokenAndRedirectToIntuit(){
        serviceObject__c serviceObject =serviceObject__c.getValues('Quickbook');
        String nonce = string.valueof(dateTime.now().getTime()/1000);
        string timestamp = string.valueof(dateTime.now().getTime()/1000);
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_callback', EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbookIntegration', 'UTF-8'));
        parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_version', '1.0');
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        req.setEndpoint(serviceObject.Request_Token_URL__c);
        req.setMethod('POST');
        String signature = generateSignature(req, serviceObject.Consumer_Secret__c, '', parameters);
        String body = 'oauth_callback=' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbookIntegration' + '&';
        body += 'oauth_consumer_key=' + serviceObject.Consumer_Key__c + '&';
        body += 'oauth_nonce=' + nonce + '&';
        body += 'oauth_signature_method=HMAC-SHA1&';
        body += 'oauth_timestamp=' + timestamp + '&';
        body += 'oauth_version=1.0&';
        body += 'oauth_signature=' + signature;
        req.setBody(body);
        Http http = new Http();
        res = http.send(req);
        for(string str : res.getHeaderKeys())
        {
            system.debug('==> '+ str);
        }
        system.debug('==> '+ res.getBodyDocument());
        String authToken = '';
        try {Map<String,String> responseItems =(Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);//getResponseNVP( req );
           //  Map<String, String> responseItems = (Map<String, String>)JSON.parse(res.getHeaderKeys());
            system.debug('==> '+responseItems.get('oauth_token_secret'));
             serviceObject.Temporary_Token_Secret__c = responseItems.get('oauth_token_secret');
             update serviceObject;
             authToken = responseItems.get('oauth_token');
            }catch(Exception e){System.debug(e.getMessage());}
        authToken = serviceObject.OAuth_Token__c;
        String redirectUrl = 'https://appcenter.intuit.com/Connect/Begin?oauth_token='+ authToken;
        pagereference redirect = new PageReference( redirectUrl );
        return redirect.setRedirect(true);
    }
    //    Function: OAuth_Step2_getFinalToken   
    String outputString = '';
    public pagereference OAuth_Step2_getFinalToken() {
        serviceObject__c serviceObject =serviceObject__c.getValues('Quickbook');
        
        String nonce = string.valueof(dateTime.now().getTime()/1000);
        String timestamp = string.valueof(dateTime.now().getTime()/1000);
        String tokenParm = apexpages.currentpage().getparameters().get('oauth_token');
        String tokenVerifier = apexpages.currentpage().getparameters().get('oauth_verifier');
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_callback', EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbookIntegration', 'UTF-8'));
        parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_token', tokenParm);
        parameters.put('oauth_verifier', tokenVerifier);
        parameters.put('oauth_version', '1.0');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(serviceObject.Request_Token_URL__c);//Access_Token_URL__c
        req.setMethod('POST');
        String signature = generateSignature(req, serviceObject.Consumer_Secret__c, serviceObject.Temporary_Token_Secret__c, parameters);
        String body = 'oauth_callback=' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbookIntegration' + '&';
        body += 'oauth_consumer_key=' + serviceObject.Consumer_Key__c + '&';
        body += 'oauth_nonce=' + nonce + '&';
        body += 'oauth_signature_method=HMAC-SHA1&';
        body += 'oauth_timestamp=' + timestamp + '&';
        body += 'oauth_version=1.0&';
        body += 'oauth_token=' + tokenParm + '&';
        body += 'oauth_verifier=' + tokenVerifier + '&';
        body += 'oauth_signature=' + signature;
        req.setBody(body);
        try{
            Map<String,String> responseItems = (Map<String,String>)JSON.deSerialize(req.getBody(),Map<String,String>.class);//getResponseNVP( req );
            outputString += JSON.serialize( responseItems );
            serviceObject.OAuth_Token__c = responseItems.get('oauth_token');
            serviceObject.OAuth_Token_Secret__c = responseItems.get('oauth_verifier');
            update serviceObject;
        } catch(Exception e){System.debug(e.getMessage());}
        String redirectUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbookIntegration';
        pagereference redirect = new PageReference( redirectUrl );
        redirect.setRedirect(true);
        return redirect;}
    //    Function: testAPICall   
    public string testAPICall() {
        String endpoint = 'https://sandbox-quickbooks.api.intuit.com/v3/company/123145693364057/customer/1?minorversion=4';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req = signRequest(req);
        HttpResponse res;
        res = http.send(req);
        system.debug('RESS==> '+res);
        String resParams = res.getBody();
        outputString +=resParams;
        return outputString;
    }
    
    //    Function: signRequest   
    
    public static HttpRequest signRequest(HttpRequest req) {
        serviceObject__c serviceObject =serviceObject__c.getValues('Quickbook');
        String nonce = string.valueof(dateTime.now().getTime()/1000);
        String timestamp = string.valueof(dateTime.now().getTime()/1000);
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_token', EncodingUtil.urlEncode(serviceObject.OAuth_Token__c, 'UTF-8'));
        parameters.put('oauth_version', '1.0');
        String signature = generateSignature(req, serviceObject.Consumer_Secret__c, serviceObject.OAuth_Token_Secret__c, parameters);
        String header = generateHeader(signature, parameters);
        req.setHeader('Authorization', header);
      //  req.setHeader('Accept','application/json');
        system.debug('REQ=> '+req);
        return req;
    }
    //    Function: generateHeader   
    private static String generateHeader(String signature, Map<String,String> parameters) {
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        return header + 'oauth_signature="' + signature + '"';
    }
    
    //    Function: generateSignature   
    
    public static String generateSignature(HttpRequest req, String consumerSecret, String tokenSecret, Map<String,String> parameters) {
        //  String s = createBaseString(req, parameters);
        //   String key = EncodingUtil.urlEncode(consumerSecret, 'UTF-8') + '&' + EncodingUtil.urlEncode(tokenSecret, 'UTF-8');
        //  Blob sig = Crypto.generateMac('HMAC-SHA1',Blob.valueOf(req),Blob.valueOf(key));
        return EncodingUtil.urlEncode( EncodingUtil.base64encode(Crypto.generateMac('HMAC-SHA1',Blob.valueOf(createBaseString(req, parameters)),Blob.valueOf(EncodingUtil.urlEncode(consumerSecret, 'UTF-8') + '&' + EncodingUtil.urlEncode(tokenSecret, 'UTF-8')))), 'UTF-8');
    }
    private static String createBaseString(HttpRequest req, Map<String,String> parameters) {
        Map<String,String> p = parameters.clone();
        if(req.getMethod().equalsIgnoreCase('post') && req.getBody()!=null &&
           req.getHeader('Content-Type')=='application/x-www-form-urlencoded') {
               p.putAll(getUrlParams(req.getBody()));
           }
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        if(n>-1) {
            p.putAll(getUrlParams(host.substring(n+1)));
            host = host.substring(0,n);
        }
    //    system.debug('==>host '+ host);
    //    system.debug('==>p '+ p);
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }
        system.debug('==>s '+ s);
        // According to OAuth spec, host string should be lowercased, but Google and LinkedIn
        // both expect that case is preserved.
        return req.getMethod().toUpperCase()+ '&' +
            EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
            EncodingUtil.urlEncode(s, 'UTF-8');
    }
    private static Map<String,String> getUrlParams(String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
                // RFC 5849 section 3.4.1.3.1 and 3.4.1.3.2 specify that parameter names 
                // and values are decoded then encoded before being sorted and concatenated
                // Section 3.6 specifies that space must be encoded as %20 and not +
                String encName = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[0], 'UTF-8'), 'UTF-8').replace('+','%20');
                String encValue = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[1], 'UTF-8'), 'UTF-8').replace('+','%20');
                System.debug('getUrlParams:  -> '+encName+','+encValue);
                res.put(encName,encValue);
            }
        }
        return res;
    }*/
   /* private static Map<String,String> getUrlParams(String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
                System.debug('getUrlParams: -> '+kv[0]+','+kv[1]);
                res.put(kv[0],kv[1]);
            }
        }
        return res;
    }*/
}