/**
 * This class make the callout request for the API version.
 */
public class APIVersionsRestCall {

    /**
     * Get the latest (higher) API version from the given Salesforce Instance URL.
     *
     * @param url base url of Salesforce instance.
     * @return latest version found, -1 if nothing found.
     */
    public static Integer getLatestAvailableAPIVersions(String url) {
        Integer result = -1;

        try {
            HttpResponse response = makeRequest(url);
            if (response.getStatusCode() == 200) {
                String json = response.getBody();
                result = APIVersionsHelper.getLatestAvailableAPIVersions(json);
            }
        }  catch (System.Exception e) {
            // Nothing to do, just put a trace in debug
            System.debug('APIVersionsRestCall.getLatestAvailableAPIVersions : '+ e.getMessage());
        }

        return result;
    }

    private static HttpResponse makeRequest(String url) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+APIVersionsConstants.SUFFIX);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        return response;
    }

}