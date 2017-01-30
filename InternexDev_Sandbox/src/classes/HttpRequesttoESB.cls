global class HttpRequesttoESB {
    // Pass in the endpoint to be used using the string url
    
    webservice static String getContent(String url,String Method,String BasicAuth,string Objct,string whr,string RealmID,String ConsumerKey,string ConsumerSecret,String OauthToken,String AccessTokenSecret,string ClientID,string PortalClientID,string ClientName) {
         try{   
        // Instantiate a new http object
            Http h = new Http();
            string Querystring = 'select * from '+Objct + whr;
            system.debug('Query String ==> '+ Querystring);
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            	xmlW.writeStartElement(null,'Request',null);    
            
                    xmlW.writeStartElement(null, 'ClientId', null);
                    xmlW.writeCharacters('internex');
                    xmlW.writeEndElement();
             
					xmlW.writeStartElement(null, 'ClientID', null);
                    xmlW.writeCharacters(ClientID);
                    xmlW.writeEndElement();
             
             		xmlW.writeStartElement(null, 'ClientName', null);
                    xmlW.writeCharacters(ClientName);
                    xmlW.writeEndElement();
             
             		xmlW.writeStartElement(null, 'PortalClientID', null);
                    xmlW.writeCharacters(PortalClientID);
                    xmlW.writeEndElement();
             
                    xmlW.writeStartElement(null, 'Realm', null);
                    xmlW.writeCharacters(RealmID);
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'ConsumerKey', null);
                    xmlW.writeCharacters(ConsumerKey);
                    xmlW.writeEndElement();
        
        			xmlW.writeStartElement(null, 'ConsumerSecret', null);
                    xmlW.writeCharacters(ConsumerSecret);
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'OauthToken', null);
                    xmlW.writeCharacters(OauthToken);
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'AccessTokenSecret', null);
                    xmlW.writeCharacters(AccessTokenSecret);
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'Action', null);
                    xmlW.writeCharacters('query');
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'Object', null);
                    xmlW.writeCharacters(Objct);
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'QueryString', null);
                    xmlW.writeCharacters(Querystring);
                    xmlW.writeEndElement();
                    
                    xmlW.writeStartElement(null, 'ObjectId', null);
                    xmlW.writeCharacters('');
                    xmlW.writeEndElement();

             		xmlW.writeStartElement(null, 'Method', null);
                    xmlW.writeCharacters('GET');
                    xmlW.writeEndElement();
            
            	xmlW.writeEndElement();
            xmlW.writeEndDocument();
            
            String xmlStringxmlRes = xmlW.getXmlString();
            EncodingUtil.urlEncode(xmlStringxmlRes, 'UTF-8');
            System.debug('The XML :'+xmlStringxmlRes);
            
            // Instantiate a new HTTP request, specify the method as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setMethod(Method);
            req.setEndpoint(url);
            Blob headerValue = Blob.valueOf(BasicAuth);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type','text/plain;charset=UTF-8');
            req.setBody(xmlStringxmlRes);
            req.setTimeout(20000);
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            /*   
Dom.Document doc = res.getBodyDocument();
//Retrieve the root element for this document.
Dom.XMLNode address = doc.getRootElement();
// Alternatively, loop through the child elements.
// This prints out all the elements of the address
for(Dom.XMLNode child : address.getChildElements()) {
System.debug(child.getText());
} */
       
            return res.getBody();
        }catch(System.CalloutException e)
        {
            system.debug('callout excpetion ' + e);
            return null;
        }
    }
}