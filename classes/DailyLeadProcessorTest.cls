/**
 * Created by charlottew on 3/22/2017.
 */

@isTest
private class DailyLeadProcessorTest {

    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testScheduledJob() {
        List<Lead> testLeadList = new List<Lead>();
        for (Integer i = 0; i <200 ; i++) {
            Lead newLead = new Lead(LastName='Dupont' + i, Company='Test');
            testLeadList.add(newLead);
        }
        insert testLeadList;
        

        // Get the IDs of the lead we just inserted
        Map<Id, Lead> leadMap = new Map<Id, Lead>(testLeadList);
        List<Id> leadIdList = new List<Id>(leadMap.keySet());

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new DailyLeadProcessor());
        // Verify the scheduled job has not run yet.
        List<Lead> lt = [
                SELECT Id
                FROM Lead
                WHERE id IN :leadIdList and LeadSource = 'Dreamforce'
        ];
        System.assertEquals(0, lt.size(), 'Leads exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();

        // Now that the scheduled job has executed,
        // check that our tasks were created
        lt = [
                SELECT Id
                FROM Lead
                WHERE id IN :leadIdList and LeadSource = 'Dreamforce'
        ];
        System.assertEquals(leadIdList.size(),
                lt.size(),
                'Leads were not updated');

    }
}