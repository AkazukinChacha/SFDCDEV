/**
 * Created by charlottew on 3/22/2017.
 */

@isTest
private class LeadProcessorTest {

    @testSetup
    static void setup() {
        List<Lead> leadList = new List<Lead>();
        // insert 10 leads
        for (Integer i = 0; i < 10; i++) {
            leadList.add(new Lead(LastName = 'Lead ' + i, FirstName='little', Company = 'Test'));
        }
        insert leadList;
    }

    static testmethod void test() {
        Test.startTest();
        LeadProcessor leadProcessor = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcessor);
        Test.stopTest();

// after the testing stops, assert records were updated properly
        List<Lead> leadList = [Select LeadSource from Lead];
        for (Lead lead: leadList) {
            System.assertEquals(lead.LeadSource, 'Dreamforce');
        }
    }

}