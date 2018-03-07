/**
 * Created by charlottew on 3/22/2017.
 */
@isTest
public class AddPrimaryContactTest {

    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        // add 50 child accounts
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(name='Test Account'+i, BillingState='CA'));
        }
        insert accounts;

        accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(name='Test Account'+i, BillingState='NY'));
        }
        insert accounts;
    }

    static testmethod void testQueueable() {
        // query for test data to pass to queueable class
        Contact contact = new Contact(FirstName='Henri', LastName='Dupont');

        // Create our Queueable instance
        AddPrimaryContact updater = new AddPrimaryContact(contact, 'CA');
        AddPrimaryContact updater2 = new AddPrimaryContact(contact, 'NY');
        // startTest/stopTest block to force async processes to run
        Test.startTest();
        System.enqueueJob(updater);
        System.enqueueJob(updater2);
        Test.stopTest();
        System.assertEquals(50, [Select count() from Contact where LastName='Dupont' and FirstName='Henri' and AccountId in (Select Id from Account where BillingState='CA')]);

    }
}