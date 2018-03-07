/**
 * Created by charlottew on 3/21/2017.
 */

@IsTest
private class AccountProcessorTest {

    @isTest static void testCountContacts() {
        Account newAccount = new Account(Name = 'Test Account');

        insert newAccount;
        Contact newContact = new Contact(LastName = 'Test Contact');
        newContact.AccountId = newAccount.Id;
        insert newContact;

        System.assertEquals(newAccount.Number_of_Contacts__c, null);
        List<Id> accountListIds = new List<Id>();
        accountListIds.add(newAccount.Id);
        Test.startTest();
        AccountProcessor.countContacts(accountListIds);
        Test.stopTest();
        System.debug('Test= '+newAccount.Number_of_Contacts__c);
        Account account = [Select Id,Number_of_Contacts__c from Account where Id = :newAccount.Id];
        System.assertEquals(account.Number_of_Contacts__c, 1);
    }
}