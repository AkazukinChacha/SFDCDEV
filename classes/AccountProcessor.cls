/**
 * Created by charlottew on 3/21/2017.
 */

global class AccountProcessor {

    @Future
    public static void countContacts(List<Id> accountIdList) {
        List<Account> accountToUpdateList = new List<Account>();
        for (Integer i = 0; i < accountIdList.size(); i++) {
            Id currentId = accountIdList.get(i);
            Account account = [Select Id,Number_of_Contacts__c from Account where Id = :currentId];
            List<Contact> contactList = [Select Id from Contact where AccountId= :currentId];
            account.Number_of_Contacts__c = contactList.size();
            accountToUpdateList.add(account);
        }

        update accountToUpdateList;
    }
}