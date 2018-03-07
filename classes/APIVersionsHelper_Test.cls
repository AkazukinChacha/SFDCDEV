/**
 * Test class for the class AvailableAPIVersionsHelper.
 *
 * Should give 100% of code coverage
 */
@IsTest
public class APIVersionsHelper_Test {

    /**
     * Setup the test.
     * Insert 10 Salesforce_Instance__c
     */
    @testSetup
    static void setup() {
        List<Salesforce_Instance__C> salesforceInstanceList = new List<Salesforce_Instance__C>();
        // insert 10 Salesforce_Instance__c as the method will make callout
        for (Integer i = 0; i < 10; i++) {
            salesforceInstanceList.add(new Salesforce_Instance__C(API_Version__c = 28, Server_Url__c = 'https://my.fake.url'));
        }
        insert salesforceInstanceList;
    }

    /**
     * Get the lastest value from a single entry.
     * Check on a single entry in the JSON string.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsSingleEntry() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"url\" : \"/services/data/v39.0\",' +
                '  \"version\" : \"39.0\"' +
                '} ]';

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(39, version, 'The expected value is 39 but is ' + version);
    }

    /**
     * Get the lastest value from multiples entries.
     * Test with multiple entries in a correct JSON structure.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsMultipleEntries() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'APIVersionsRestCallTestCorrectJSON' LIMIT 1];
        String json = sr.Body.toString();

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(39, version, 'The expected value is 39 but is ' + version);
    }

    /**
     * Get the lastest value from an invalid JSON structure.
     * Test with multiple entries in a incorrect JSON structure.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsInvalidJSONStructure() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'APIVersionRestCallTestWrongJSON' LIMIT 1];
        String json = sr.Body.toString();

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(-1, version, 'The expected value is -1 but is ' + version);
    }

     /**
     * Get the lastest value from an empty JSON structure.
     * Test with an empty JSON structure '[]'
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsEmptyJSON() {
        String json = '[]';

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(-1, version, 'The expected value is -1 but is ' + version);
    }

     /**
     * Get the lastest value from an invalid JSON value.
     * Test with a valid JSON Structure but invalid values.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsInvalidJSONValue() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"url\" : \"/services/data/v39.0\",' +
                '  \"version\" : \"LATEST\"' +
                '} ]';

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(-1, version, 'The expected value is -1 but is ' + version);
    }

     /**
     * Get the lastest value from an empty JSON value.
     * Test with a valid JSON structure but empty value.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsEmptyJSONValue() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"url\" : \"/services/data/v39.0\",' +
                '  \"version\" : \"\"' +
                '} ]';

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(-1, version, 'The expected value is -1 but is ' + version);
    }

     /**
     * Get the lastest value from an missing JSON value.
     * Test with a partial valid JSON structure.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void getLatestAvailableAPIVersionsMissingJSONValue() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"url\" : \"/services/data/v39.0\",' +
                '} ]';

        Test.startTest();
        Integer version = APIVersionsHelper.getLatestAvailableAPIVersions(json);
        Test.stopTest();

        System.assertEquals(-1, version, 'The expected value is -1 but is ' + version);
    }

    /**
     * Test update of API Versions.
     * Simulate a REST call with a Mock.
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
        List<Salesforce_Instance__c> salesforceInstanceList = [Select API_Version__c, Server_Url__c from Salesforce_Instance__C];
        APIVersionsHelper.updateSalesforceInstances(salesforceInstanceList);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        salesforceInstanceList = [Select API_Version__c from Salesforce_Instance__C];
        for (Salesforce_Instance__c salesforceInstance: salesforceInstanceList) {
            System.assertEquals(33, salesforceInstance.API_Version__c, 'The expected value is 33 but is ' + salesforceInstance.API_Version__c);
        }
    }
}