/**
 * Test class for the class APIVersionsBatch.
 *
 * Should give 100% of code coverage
 */
@isTest
private class APIVersionsBatch_Test {

    /**
     * Setup the test.
     * Insert 10 Salesforce_Instance__c
     */
    @testSetup
    static void setup() {
        List<Salesforce_Instance__C> salesforceInstanceList = new List<Salesforce_Instance__C>();
        // insert 10 Salesforce_Instance__C as the method will make callout
        for (Integer i = 0; i < 10; i++) {
            salesforceInstanceList.add(new Salesforce_Instance__C(API_Version__c = 28, Server_Url__c = 'https://my.fake.url'));
        }
        insert salesforceInstanceList;
    }

    /**
     * Test update of API Versions.
     * Mock an HTTP response with a correct JSON structure.
     * Test if all the Salesforce_Instance__c are updated to the lastest version found.
     */
    static testmethod void updateSalesforceInstances() {
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
        APIVersionsBatch apiVersionsBatch = new APIVersionsBatch();
        Id batchId = Database.executeBatch(apiVersionsBatch, 10);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        List<Salesforce_Instance__C> salesforceInstanceList = [Select API_Version__c from Salesforce_Instance__C];
        for (Salesforce_Instance__C salesforceInstance: salesforceInstanceList) {
            System.assertEquals(33, salesforceInstance.API_Version__c, 'The expected value is 33 but is ' + salesforceInstance.API_Version__c);
        }
    }
}