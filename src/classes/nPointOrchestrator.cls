global class nPointOrchestrator {
    global static nPointDataSet[] startSyncRequest(String verb, String endpoint, Integer timeout, String certificateName, String requestBody, Map<String,String> headers, Boolean throwOnNon200) {
                                                                     
        String resp = nPointSend.PerformHttpRequest(verb, endpoint, timeout, certificateName, requestBody, headers, throwOnNon200);
        nPointDataSet[] superDataSet = nPointHandleResponse.handleResp(resp);

        return superDataSet;
    }
}