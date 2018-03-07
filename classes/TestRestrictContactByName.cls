@isTest
public class TestRestrictContactByName {
	@isTest static void testNameValidCreate() {
        Contact contact = new Contact(LastName='Charlotte');
        Test.startTest();
		Database.SaveResult result = Database.insert(contact, false);
          Test.stopTest();
        System.assert(result.isSuccess());
        
        delete contact;
    }
    @isTest static void testNameInvalidCreate() {
        Contact contact = new Contact(LastName='INVALIDNAME');
        Test.startTest();
		Database.SaveResult result = Database.insert(contact, false);
          Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "'+contact.LastName+'" is not allowed for DML', result.getErrors()[0].getMessage());
    }
     @isTest static void testNameValidUpdate() {
        Contact contact = new Contact(LastName='Charlotte');
        insert contact;
         
        contact.LastName = 'Cha';
         Test.startTest();
		Database.SaveResult result = Database.update(contact, false);
          Test.stopTest();
 		System.assert(result.isSuccess());
         delete contact;
    }
     @isTest static void testNameInvalidUpdate() {
        Contact contact = new Contact(LastName='Charlotte');
        insert contact;
         
         contact.LastName = 'INVALIDNAME';
         Test.startTest();
		Database.SaveResult result = Database.update(contact, false);
          Test.stopTest();
          System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "'+contact.LastName+'" is not allowed for DML', result.getErrors()[0].getMessage());
         delete contact;
    }
}