/**
 * Test class for the class APIVersionsRestCall.
 *
 * Should give 100% of code coverage
 */
@isTest
public class APIVersionsRestCall_Test {

    /**
     * Valid HTTPResponse and correct JSON.
     * Mock the APIVersionsRestCallMock then set an correct JSON string.
     * Test if APIVersionsRestCall.getLatestAvailableAPIVersions return correct value.
     */
    @isTest static void testAPIVersionsRestCall() {
        // Set mock callout class
        APIVersionsRestCallMock apiVersionsRestCallMock = new APIVersionsRestCallMock();
        Test.setMock(HttpCalloutMock.class, apiVersionsRestCallMock);
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'APIVersionsRestCallTestCorrectJSON' LIMIT 1];
        String json = sr.Body.toString();

        response.setBody(json);
        response.setStatusCode(200);
        apiVersionsRestCallMock.setResponse(response);

        Test.startTest();
        // This causes a fake response to be sent
        Integer lastestAPIVersion = APIVersionsRestCall.getLatestAvailableAPIVersions('http://my.fake.url');
        Test.stopTest();

        System.assertEquals(33, lastestAPIVersion, 'The expected value is 33 but it actually '+lastestAPIVersion);
    }

    /**
     * Wrong JSON response.
     * Mock the APIVersionsRestCallMock then set an wrong (uncorrect structure) JSON string.
     * Test if APIVersionsRestCall.getLatestAvailableAPIVersions return correct value.
     */
    @isTest static void testAPIVersionsRestCallWrongJSON() {
        // Set mock callout class
        APIVersionsRestCallMock apiVersionsRestCallMock = new APIVersionsRestCallMock();
        Test.setMock(HttpCalloutMock.class, apiVersionsRestCallMock);
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'APIVersionRestCallTestWrongJSON' LIMIT 1];
        String json = sr.Body.toString();

        response.setBody(json);
        response.setStatusCode(200);
        apiVersionsRestCallMock.setResponse(response);

        Test.startTest();
        Integer lastestAPIVersion = APIVersionsRestCall.getLatestAvailableAPIVersions('http://my.fake.url');
        Test.stopTest();

        System.assertEquals(-1, lastestAPIVersion, 'The expected value is -1 but it actually '+lastestAPIVersion);
    }

    /**
     * Empty answer.
     * Mock the APIVersionsRestCallMock then set an empty JSON string.
     * Test if APIVersionsRestCall.getLatestAvailableAPIVersions return correct value.
     */
    @isTest static void testAPIVersionsRestCallEmptyJSON() {
        // Set mock callout class
        APIVersionsRestCallMock apiVersionsRestCallMock = new APIVersionsRestCallMock();
        Test.setMock(HttpCalloutMock.class, apiVersionsRestCallMock);
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String json = '';

        response.setBody(json);
        response.setStatusCode(200);
        apiVersionsRestCallMock.setResponse(response);

        Test.startTest();
        Integer lastestAPIVersion = APIVersionsRestCall.getLatestAvailableAPIVersions('http://my.fake.url');
        Test.stopTest();

        System.assertEquals(-1, lastestAPIVersion, 'The expected value is *1 but it actually '+lastestAPIVersion);
    }


    /**
     * Wrong status code (not 200).
     * Mock the APIVersionsRestCallMock then set a code different from 200 (succeeded).
     * Test if APIVersionsRestCall.getLatestAvailableAPIVersions return correct value.
     */
    @isTest static void testAPIVersionsRestCallWrongStatus() {
        // Set mock callout class
        APIVersionsRestCallMock apiVersionsRestCallMock = new APIVersionsRestCallMock();
        Test.setMock(HttpCalloutMock.class, apiVersionsRestCallMock);
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String json = '';

        response.setBody(json);
        response.setStatusCode(404);
        apiVersionsRestCallMock.setResponse(response);

        Test.startTest();
        Integer lastestAPIVersion = APIVersionsRestCall.getLatestAvailableAPIVersions('http://my.fake.url');
        Test.stopTest();

        System.assertEquals(-1, lastestAPIVersion, 'The expected value is *1 but it actually '+lastestAPIVersion);
    }
}