@IsTest
private class AccountManagerTest {

    @isTest static void testGetCaseById() {
		Account newAccount = new Account(Name='Test Account');
        
        insert newAccount;
        Contact newContact = new Contact(LastName='Test Contact');
        newContact.AccountId = newAccount.Id;
        insert newContact;
        
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://eu11.salesforce.com/services/apexrest/Accounts/'+newAccount.Id+'/contacts/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals(newAccount.Id, thisAccount.ID);
        System.assertEquals('Test Account', thisAccount.Name);
    }
        

}