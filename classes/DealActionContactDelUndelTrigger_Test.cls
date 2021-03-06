/**
 * Test class for the DealActionContactDelUndelTrigger.
 *
 * Should give 100% of code coverage
 */
@isTest(seeAllData=false)
private class DealActionContactDelUndelTrigger_Test {

    private static Contact CONTACT_FOR_TEST;
    private static Deal__c DEAL_FOR_TEST;

    /**
     * Initialize the contact and the deal for the tests.
     */
    public static void init() {
        CONTACT_FOR_TEST = new Contact(LastName = 'Dupont');
        DEAL_FOR_TEST = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100, Valid_Through__c = System.now().addMonths(1));

        insert CONTACT_FOR_TEST;
        insert DEAL_FOR_TEST;
    }

    /**
     * Initialize contacts and deals for the tests of limits.
     */
    public static void initWithLimits() {
        List<Contact> contactToInsertList = new List<Contact>();
        for (Integer i = 0; i < 2000; i++) {
            CONTACT_FOR_TEST = new Contact(LastName = 'Dupont');
            contactToInsertList.add(CONTACT_FOR_TEST);
        }
        insert contactToInsertList;

        List<Deal__c> dealToInsertList = new List<Deal__c>();
        for (Integer i = 0; i < 2000; i++) {
            DEAL_FOR_TEST = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100, Valid_Through__c = System.now().addMonths(1));
            dealToInsertList.add(DEAL_FOR_TEST);
        }

        insert dealToInsertList;
    }

    /**
     * Test a delete of the contact with an 'Rejected' action value.
     */
    static testMethod void testDeleteContactRejectedAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has "Rejected" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action inserted has "Rejected" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action inserted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }

    /**
     * Test a Undelete of the contact with an 'Rejected' action value.
     */
    static testMethod void testUnDeleteContactRejectedAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has "Rejected" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action inserted has "Rejected" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action inserted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        undelete CONTACT_FOR_TEST;
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after undelete
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action undeleted has "Rejected" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action undeleted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }


    /**
     * Test a delete of the contact with an 'Accepted' action value.
     */
    static testMethod void testDeleteContactAcceptedAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_ACCEPTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        System.debug('DEAL FOR TEST ID = ' + DEAL_FOR_TEST.Id);
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action inserted has "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action inserted has "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newDeal.Rejections__c + '" was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has "Accepted" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has "Accepted" action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }

    /**
     * Test a Undelete of the contact with an 'Accepted' action value.
     */
    static testMethod void testUnDeleteContactAcceptedAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_ACCEPTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action inserted has "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action inserted has "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newDeal.Rejections__c + '" was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has "Accepted" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has "Accepted" action value ' + newDeal.Rejections__c + ' was found.');

        undelete CONTACT_FOR_TEST;
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after undelete
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action undeleted has "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action undeleted has "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action undeleted has "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has "Accepted" action value "' + newDeal.Rejections__c + '" was found.');

        Test.stopTest();
    }

    /**
     * Test a delete of the contact with an empty action value.
     */
    static testMethod void testDeleteContactEmptyAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_EMPTY);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action inserted has empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action inserted has empty action value "' + newDeal.Rejections__c + '" was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has empty action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has empty action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }

    /**
     * Test a Undelete of the contact with an empty action value.
     */
    static testMethod void testUnDeleteContactEmptyAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_EMPTY);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action inserted has empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newDeal.Rejections__c + '" was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has empty action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has empty action value ' + newDeal.Rejections__c + ' was found.');

        undelete CONTACT_FOR_TEST;
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after undelete
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action undeleted has empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action undeleted has empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has empty action value "' + newDeal.Rejections__c + '" was found.');

        Test.stopTest();
    }

    /**
     * Test for limits of query.
     */
    static testMethod void testDeleteContactQueryLimits() {
        initWithLimits();

        Test.startTest();

        List<Deal_Action__c> dealActionList = new List<Deal_Action__c>();
        for (Integer i = 0; i < 2000; i++) {
            Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
            dealAction.Contact__c = CONTACT_FOR_TEST.Id;
            dealAction.Deal__c = DEAL_FOR_TEST.Id;
            dealActionList.add(dealAction);
        }
        insert dealActionList;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after insert
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has "Rejected" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(2000, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action inserted has "Rejected" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(2000, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action inserted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        delete CONTACT_FOR_TEST;
        // Check information after delete
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }
}