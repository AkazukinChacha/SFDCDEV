/**
 * Class mocking a HTTPRequest.
 *
 * Used by the APIVersionsRestCall_Test
 */
@isTest
global class APIVersionsRestCallMock implements HttpCalloutMock {

    HttpResponse response = new HttpResponse();

    /**
     * Set the HTTPResponse that will be return with the respond method.
     *
     * @param response HTTPResponse to set.
     */
    public void setResponse(HttpResponse response) {
        this.response = response ;
    }

    /**
     * Get the HTTPResponse that has been set with the setResponse method.
     *
     * @param request sended request
     * @return response HTTPResponse to set.
     */
    public HttpResponse respond(HttpRequest request) {
        return this.response;
    }
}