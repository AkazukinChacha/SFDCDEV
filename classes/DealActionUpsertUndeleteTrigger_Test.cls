/**
 * Test class for the DealActionUpsertUndeleteTrigger.
 *
 * Should give 100% of code coverage
 */
@isTest(seeAllData=false)
private class DealActionUpsertUndeleteTrigger_Test {

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
     * Test a create with an empty action value.
     */
    static testMethod void testCreateEmptyAction() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_EMPTY);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action inserted has empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action inserted has empty action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test a create with a 'Accepted' action value.
     */
    static testMethod void testCreateActionToAccepted() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_ACCEPTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action inserted has "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action inserted has "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action inserted has "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test a create with a 'Rejected' action value.
     */
    static testMethod void testCreateActionToRejected() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action inserted has "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action inserted has "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action inserted has "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action inserted has "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to empty and new value to empty.
     */
    static testMethod void testUpdateEmptyActionToEmpty() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_EMPTY);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_EMPTY;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated from empty to empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated from empty to empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated from empty to empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated from empty to empty action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to empty and new value to 'Accepted'.
     */
    static testMethod void testUpdateEmptyActionToAccepted() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = '');
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_ACCEPTED;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action updated from empty to "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated from empty to "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action updated from empty to "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated from empty to "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to empty and new value to 'Rejected'.
     */
    static testMethod void testUpdateEmptyActionToRejected() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_EMPTY);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_REJECTED;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated from empty to "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action updated from empty to "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated from empty to "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action updated from empty to "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to 'Accepted' and new value to 'Accepted'.
     */
    static testMethod void testUpdateAcceptedActionToAccepted() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_ACCEPTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_ACCEPTED;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action updated from "Accepted" to "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated from "Accepted" to "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action updated from "Accepted" to "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated from "Accepted" to "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to 'Accepted' and new value to 'Rejected'.
     */
    static testMethod void testUpdateAcceptedActionToRejected() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_ACCEPTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_REJECTED;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated from "Accepted" to "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated from "Accepted" to "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated from "Accepted" to "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated from "Accepted" to "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to 'Rejected' and new value to 'Accepted'.
     */
    static testMethod void testUpdateRejectedActionToAccepted() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_ACCEPTED;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated from "Rejected" to "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated from "Rejected" to "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated from "Rejected" to "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated from "Rejected" to "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test an update with old value to 'Rejected' and new value to 'Rejected'.
     */
    static testMethod void testUpdateRejectedActionToRejected() {
        init();

        Test.startTest();

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
        dealAction.Contact__c = CONTACT_FOR_TEST.Id;
        dealAction.Deal__c = DEAL_FOR_TEST.Id;
        insert dealAction;
        dealAction.Action__c = DealActionConstants.STATUS_REJECTED;
        update dealAction;

        Contact newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        Deal__c newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated from "Rejected" to "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action updated from "Rejected" to "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated from "Rejected" to "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action updated from "Rejected" to "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test a delete with an 'Rejected' action value.
     */
    static testMethod void testDeleteRejectedAction() {
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

        delete dealAction;
        // Check information after delete
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }

    /**
     * Test a Undelete with an 'Rejected' action value.
     */
    static testMethod void testUnDeleteRejectedAction() {
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

        delete dealAction;
        // Check information after delete
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action deleted has "Rejected" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action deleted has "Rejected" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has "Rejected" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has "Rejected" action value ' + newDeal.Rejections__c + ' was found.');

        undelete dealAction;
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
     * Test a delete with an 'Accepted' action value.
     */
    static testMethod void testDeleteAcceptedAction() {
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

        delete dealAction;
        // Check information after delete
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action undeleted has "Accepted" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action undeleted has "Accepted" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has "Accepted" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has "Accepted" action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }

    /**
     * Test a Undelete with an 'Accepted' action value.
     */
    static testMethod void testUnDeleteAcceptedAction() {
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

        delete dealAction;
        // Check information after delete
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action deleted has "Accepted" action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action deleted has "v" action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has "Accepted" action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has "Accepted" action value ' + newDeal.Rejections__c + ' was found.');

        undelete dealAction;
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
     * Test a delete with an empty action value.
     */
    static testMethod void testDeleteEmptyAction() {
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

        delete dealAction;
        // Check information after delete
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action undeleted has empty action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action undeleted has empty action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has empty action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has empty action value ' + newDeal.Rejections__c + ' was found.');

        Test.stopTest();
    }

    /**
     * Test a Undelete with an empty action value.
     */
    static testMethod void testUnDeleteEmptyAction() {
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

        delete dealAction;
        // Check information after delete
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action deleted has empty action value ' + newContact.Deals_Accepted__c + ' was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action deleted has empty action value ' + newContact.Deals_Rejected__c + ' was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has empty action value ' + newDeal.Acceptances__c + ' was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has empty action value ' + newDeal.Rejections__c + ' was found.');

        undelete dealAction;
        newContact = [Select Deals_Accepted__c, Deals_Rejected__c From Contact where Id = :CONTACT_FOR_TEST.Id];
        newDeal = [Select Acceptances__c, Rejections__c From Deal__c where Id = :DEAL_FOR_TEST.Id];
        // Check information after undelete
        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action undeleted has empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action undeleted has empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action undeleted has empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action undeleted has empty action value "' + newDeal.Rejections__c + '" was found.');

        Test.stopTest();
    }
}