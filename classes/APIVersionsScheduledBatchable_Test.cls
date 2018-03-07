/**
 * Test class for the class APIVersionsScheduledBatchable.
 *
 * Should give 100% of code coverage
 */
@isTest
public class APIVersionsScheduledBatchable_Test {

    /**
     * Test valid with job not run.
     */
    @isTest static void testAPIVersionsScheduledBatchable() {
        Test.startTest();

        APIVersionsScheduledBatchable scheduledBatchable = new APIVersionsScheduledBatchable();
        String chron = '0 0 2 * * ?';
        String jobid = system.schedule('Test API Version Check', chron, scheduledBatchable);

        // Get the information from the CronTrigger API object
        CronTrigger ct = [Select Id, CronExpression, TimesTriggered, State, NextFireTime from CronTrigger where id = :jobId];
        // Verify the expressions are the same
        System.assertEquals('0 0 2 * * ?', ct.CronExpression, 'The expected CronExpression is 0 0 2 * * ? but is actually ' + ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered, 'The job should not be runned.');
        // Verify job is waiting
        System.assertEquals('WAITING', ct.State, 'The expected State is WAITING but is ' + ct.State);
        // Verify the next time the job will run
        Datetime tomorrow = Datetime.now().addDays(1);
        Datetime tomorrowAtMidnight = Datetime.newInstanceGmt(tomorrow.year(), tomorrow.month(), tomorrow.day(), 0, 0, 0);
        System.assertEquals(tomorrowAtMidnight, ct.NextFireTime, 'The next time for the job to run must be ' + tomorrowAtMidnight + ' but is ' + ct.NextFireTime);

        Test.stopTest();
    }
}