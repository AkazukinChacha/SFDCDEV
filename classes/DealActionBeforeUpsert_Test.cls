/**
 * Test class for the DealActionBeforeUpsert.
 *
 * Should give 100% of code coverage
 */
@IsTest(SeeAllData=false)
private class DealActionBeforeUpsert_Test {

    /**
     * Test a create with an 'Accepted' action value and no more available deals.
     */
    static testMethod void testInsertAcceptedNoMoreAvailable() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 0, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Accepted');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;

        Test.startTest();
        try {
            insert dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.No_More_Available_Deal) , 'The error message must contain "' + Label.No_More_Available_Deal + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test a create with an 'Rejected' action value and no more available deals.
     */
    static testMethod void testInsertRejectedNoMoreAvailable() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 0, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;

        Test.startTest();
        try {
            insert dealAction;
        } catch (Exception e) {
            System.assert(false, 'An exception should not have been thrown by the trigger but was not.');
        }

        Test.stopTest();
    }

    /**
     * Test a create with an empty action value and no more available deals.
     */
    static testMethod void testInsertEmptyNoMoreAvailable() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 0, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = '');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;

        Test.startTest();
        try {
            insert dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.No_More_Available_Deal) , 'The error message must contain "' + Label.No_More_Available_Deal + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update with an 'Accepted' action value and no more available deals.
     */
    static testMethod void testUpdateAcceptedNoMoreAvailable() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 0, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        dealAction.Action__c = 'Accepted';

        Test.startTest();
        try {
            update dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.No_More_Available_Deal) , 'The error message must contain "' + Label.No_More_Available_Deal + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update with an 'Rejected' action value and no more available deals.
     */
    static testMethod void testUpdateRejectedNoMoreAvailable() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 0, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        dealAction.Action__c = 'Rejected';

        Test.startTest();
        try {
            update dealAction;
        } catch (Exception e) {
            System.assert(false, 'An exception should not have been thrown by the trigger but was not.');
        }

        Test.stopTest();
    }

    /**
     * Test an update with an empty action value and no more available deals.
     */
    static testMethod void testUpdateEmptyNoMoreAvailable() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 0, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        dealAction.Action__c = '';

        Test.startTest();
        try {
            update dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.No_More_Available_Deal) , 'The error message must contain "' + Label.No_More_Available_Deal + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test a create with an 'Accepted' action value and invalid valid trough date.
     */
    static testMethod void testInsertAcceptedInvalidValidThrough() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100, Valid_Through__c = System.now().addMonths(-1));

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Accepted');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;

        Test.startTest();
        try {
            insert dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Deal_Not_Valid_Anymore) , 'The error message must contain "' + Label.Deal_Not_Valid_Anymore + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test a create with an 'Rejected' action value and invalid valid trough date.
     */
    static testMethod void testInsertRejectedInvalidValidThrough() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100, Valid_Through__c = System.now().addMonths(-1));

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;

        Test.startTest();
        try {
            insert dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Deal_Not_Valid_Anymore) , 'The error message must contain "' + Label.Deal_Not_Valid_Anymore + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test a create with an empty action value and invalid valid trough date.
     */
    static testMethod void testInsertEmptyInvalidValidThrough() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100, Valid_Through__c = System.now().addMonths(-1));

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = '');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;

        Test.startTest();
        try {
            insert dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Deal_Not_Valid_Anymore) , 'The error message must contain "' + Label.Deal_Not_Valid_Anymore + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update with an 'Accepted' action value and invalid valid trough date.
     */
    static testMethod void testUpdateAcceptedInvalidValidThrough() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        deal.Valid_Through__c = System.now().addMonths(-1);
        update deal;

        dealAction.Action__c = 'Accepted';

        Test.startTest();
        try {
            update dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Deal_Not_Valid_Anymore) , 'The error message must contain "' + Label.Deal_Not_Valid_Anymore + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update with an 'Rejected' action value and invalid valid trough date.
     */
    static testMethod void testUpdateRejectedInvalidValidThrough() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        deal.Valid_Through__c = System.now().addMonths(-1);
        update deal;

        dealAction.Action__c = 'Rejected';

        Test.startTest();
        try {
            update dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Deal_Not_Valid_Anymore) , 'The error message must contain "' + Label.Deal_Not_Valid_Anymore + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update with an empty action value and invalid valid trough date.
     */
    static testMethod void testUpdateEmptyInvalidValidThrough() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = 'Rejected');
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        deal.Valid_Through__c = System.now().addMonths(-1);
        update deal;

        dealAction.Action__c = '';

        Test.startTest();
        try {
            update dealAction;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Deal_Not_Valid_Anymore) , 'The error message must contain "' + Label.Deal_Not_Valid_Anymore + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }
}