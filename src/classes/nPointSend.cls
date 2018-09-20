public class nPointSend {
    public static String PerformHttpRequest(String verb, String endpoint, Integer timeout, String certificateName, String requestBody, Map<String,String> headers, Boolean throwOnNon200){
        try
        {
            // Instantiate a new http object
            Http h = new Http();
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            
            /*if(headers != null && headers.size()>0){
                for(String key : headers.keySet()) {
                    ACCTFNDUtility.UpdateOrAddHeader(req,key,headers.get(key));
                }
            }*/
            
            //default ncino header
            //ACCTFNDUtility.UpdateOrAddHeader(req,'User-Agent', 'Mozilla/4.0 (compatible; MSIE 6.0; MS Web Services Client Protocol 1.1.4322.573; nCino)');
            
            // 	List<string> requestHeadersFlattenedForDebug = new List<string>();
            // 	for(String key : headers.keySet()) {
            //     	    requestHeadersFlattenedForDebug.add(key + ' = ' + headers.get(key));
            // 		}
            
            // 	system.debug('REQUEST-headers='+String.join(requestHeadersFlattenedForDebug,';'));
            //         system.debug('REQUEST-requestBody='+EncodingUtil.base64Encode(Blob.valueOf(requestBody)));
            
            //if a custom timeout to be used, add it here
            if(timeout>0){
                req.setTimeout(timeout * 1000); //timeout after 60 seconds
            }//else default
            
            req.setEndpoint(endpoint);
            
            //if a certificate is intended to be used, add it here (the name should probably be in the plugin configuration)
            if(!String.isBlank(certificateName)){
                //if(!Test.isRunningTest()){
                req.setClientCertificateName(certificateName);
                //}
            }
            
            if(!String.isBlank(verb)){
                req.setMethod(verb);
                if(verb.toUpperCase()=='POST' || verb.toUpperCase()=='PUT' || verb.toUpperCase()=='PATCH'){
                    req.setBody(requestBody);
                }
            }
            // Send the request, and return a response
            HttpResponse resp = null;
            String responseBody = null;
            Integer statusCode = 0;
            List<string> receivedHeaders = new List<string>();
            String[] headerkeys = null;
            
            // try{
            resp = h.send(req);
            // Get the response body
            responseBody = resp.getBody();
            statusCode = resp.getStatusCode();
            //get the list of header names (keys)
            headerkeys = resp.getHeaderKeys(); 
            // }catch(Exception e){
            //     throw new ACCTFNDOrchestratorCommunicationRetryException(e.getMessage());
            // }
            
            //create an object to store your header key-value pairs
            //iterate through they keys, and populate your map
            for(string s : headerkeys){
                receivedHeaders.add(s + ' = ' + resp.getHeader(s));
            }
            
            // system.debug('RESPONSE-statusCode='+statusCode);
            // system.debug('RESPONSE-receivedHeaders='+String.join(receivedHeaders,';'));
            // system.debug('RESPONSE-responseBody='+EncodingUtil.base64Encode(Blob.valueOf(responseBody)));
            
            
            //consider making the expected status code a configuration property
            if(!String.valueOf(statusCode).startsWithIgnoreCase('2') && throwOnNon200){
                //throw new ACCTFNDUtilityException(String.format('Received invalid response from vendor. [Status Code: {0}, Headers: {1}, Body: {2}]', new String[]{ String.valueOf(statusCode), String.join(receivedHeaders,';'), responseBody }));
            }
            
            // Do not do anything but send it back
            return responseBody;
            
        }
        catch(Exception e){
            //system.debug('RESPONSE-encodedErrorMessage='+EncodingUtil.base64Encode(Blob.valueOf(e.getMessage())));
            throw e;
            //throw new ACCTFNDUtilityException(String.format('Failed to sucessfully communicate to provider. [Error: {0}, Line Number: {1}]', new String[]{ e.getMessage(), String.valueOf(e.getLineNumber()) }));
        }
    }
}