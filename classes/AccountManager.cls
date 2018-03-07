@RestResource(urlMapping='/Accounts/<Account_ID>/contacts')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        // Add your code
        String accountID = request.requestURI.substring(request.requestURI.lastIndexOf('/Accounts/')+10);

		accountID= accountID.substringBefore('/');

         Account result =  [SELECT ID,Name, (SELECT Contact.FirstName, Contact.LastName FROM Account.Contacts) FROM Account
                       WHERE Id = :accountID];
        

		return result;
    }
}