/**
 * Test class for the DealActionTriggerHandler.
 *
 * Should give 100% of code coverage
 */
@IsTest(SeeAllData=false)
private class DealActionTriggerHandler_Test {

    private static Contact CONTACT_FOR_TEST;
    private static Deal__c DEAL_FOR_TEST;
    private static List<Contact> CONTACTLIST_FOR_TEST;
    private static List<Deal__c> DEALLIST_FOR_TEST;

    static void init() {
        CONTACT_FOR_TEST = new Contact(LastName = 'Dupont', Deals_Accepted__c = 1, Deals_Rejected__c = 1);
        DEAL_FOR_TEST = new Deal__c(Acceptances__c = 1, Rejections__c = 1, Max_Acceptances__c = 100);

        CONTACTLIST_FOR_TEST = new List<Contact>();
        CONTACTLIST_FOR_TEST.add(CONTACT_FOR_TEST);
        DEALLIST_FOR_TEST = new List<Deal__c>();
        DEALLIST_FOR_TEST.add(DEAL_FOR_TEST);
    }

    static void initWithNull() {
        CONTACT_FOR_TEST = new Contact(LastName = 'Dupont');
        DEAL_FOR_TEST = new Deal__c();

        CONTACTLIST_FOR_TEST = new List<Contact>();
        CONTACTLIST_FOR_TEST.add(CONTACT_FOR_TEST);
        DEALLIST_FOR_TEST = new List<Deal__c>();
        DEALLIST_FOR_TEST.add(DEAL_FOR_TEST);
    }

    /**
     * Test updated contact list for delete from 'Rejected'.
     */
    static testMethod void testUpdatedContactListFromRejectedAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.DELETED_FROM_REJECTED, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action deleted has "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action delected has "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for delete from 'Rejected'.
     */
    static testMethod void testUpdatedDealListFromRejectedAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.DELETED_FROM_REJECTED, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action deleted has "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action deleted has "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for delete from 'Accepted'.
     */
    static testMethod void testUpdatedContactListFromAcceptedAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.DELETED_FROM_ACCEPTED, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action deleted has "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action delected has "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for delete from 'Accepted'.
     */
    static testMethod void testUpdatedDealListFromAcceptedAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.DELETED_FROM_ACCEPTED, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action deleted has "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action deleted has "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for changed from empty to 'Accepted'.
     */
    static testMethod void testUpdatedContactListFromEmptyToAcceptedAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_ACCEPTED, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(2, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 2 as the deal action updated changed from empty to "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action updated changed from empty to "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for changed from 'Accepted' to empty value.
     */
    static testMethod void testUpdatedContactListFromAcceptedToEmptyAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_EMPTY, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated changed from "Accepted" to empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(1, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action updated changed from "Accepted" to empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for changed from 'Rejected' to empty value.
     */
    static testMethod void testUpdatedContactListFromRejectedToEmptyAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_EMPTY, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated changed from "Rejected" to empty action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 1 as the deal action updated changed from "Rejected" to empty action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for changed from empty to 'Accepted'.
     */
    static testMethod void testUpdatedDealListFromEmptyToAcceptedAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_ACCEPTED, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(2, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 2 as the deal action updated changed from empty to "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action updated changed from empty to "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for changed from empty to 'Rejected'.
     */
    static testMethod void testUpdatedContactListFromEmptyToRejectedAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_REJECTED, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(1, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 1 as the deal action updated changed from empty to "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(2, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 2 as the deal action updated changed from empty to "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for changed from empty to 'Rejected'.
     */
    static testMethod void testUpdatedDealListFromEmptyToRejectedAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_REJECTED, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action updated changed from empty to "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(2, newDeal.Rejections__c, 'Rejections__c are supposed to be 2 as the deal action updated changed from empty to "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for changed from 'Accepted' to 'Rejected'.
     */
    static testMethod void testUpdatedContactListFromAcceptedToRejectedAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_REJECTED, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(0, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated changed from "Accepted" to "Rejected" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(2, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 2 as the deal action updated changed from "Accepted" to "Rejected" action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for changed from 'Accepted' to 'Rejected'.
     */
    static testMethod void testUpdatedDealListFromAcceptedToRejectedAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_REJECTED, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated changed from "Accepted" to "Rejected" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(2, newDeal.Rejections__c, 'Rejections__c are supposed to be 2 as the deal action updated changed from "Accepted" to "Rejected" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated contact list for changed from 'Rejected' to 'Accepted'.
     */
    static testMethod void testUpdatedContactListFromRejectedToAcceptedAction() {
        init();

        Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
        contactsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_ACCEPTED, CONTACTLIST_FOR_TEST);

        Test.startTest();
        List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
        Contact newContact = updatedContactsList.get(0);

        System.assertEquals(2, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 2 as the deal action updated changed from "Rejected" to "Accepted" action value "' + newContact.Deals_Accepted__c + '" was found.');
        System.assertEquals(0, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated changed from "Rejected" to "Accepted" action value "' + newContact.Deals_Rejected__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for changed from 'Rejected' to 'Accepted'.
     */
    static testMethod void testUpdatedDealListFromRejectedToAccepteddAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_ACCEPTED, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(2, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 2 as the deal action updated changed from "Rejected" to "Accepted" action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated changed from "Rejected" to "Accepted" action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for changed from 'Accepted' to empty value.
     */
    static testMethod void testUpdatedDealListFromAcceptedToEmptydAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_EMPTY, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(0, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated changed from "Accepted" to empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(1, newDeal.Rejections__c, 'Rejections__c are supposed to be 1 as the deal action updated changed from "Accepted" to empty action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test updated deal list for changed from 'Rejected' to empty value.
     */
    static testMethod void testUpdatedDealListFromRejectedToEmptydAction() {
        init();

        Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
        dealsByActionTriggerEnumsMap.put(DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_EMPTY, DEALLIST_FOR_TEST);

        Test.startTest();
        List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
        System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
        Deal__c newDeal = updatedDealsList.get(0);

        System.assertEquals(1, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 1 as the deal action updated changed from "Rejected" to empty action value "' + newDeal.Acceptances__c + '" was found.');
        System.assertEquals(0, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated changed from "Rejected" to empty action value "' + newDeal.Rejections__c + '" was found.');
        Test.stopTest();
    }

    /**
     * Test if null values in deal fields are correctly handled.
     */
    static testMethod void testNullValuesInDeal() {
        Test.startTest();

        for (DealActionTriggerEnum dealActionTriggerEnum: DealActionTriggerEnum.values()) {
            initWithNull();
            Map<DealActionTriggerEnum, List<Deal__c>> dealsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
            dealsByActionTriggerEnumsMap.put(dealActionTriggerEnum, DEALLIST_FOR_TEST);
            List<Deal__c> updatedDealsList = DealActionTriggerHandler.getUpdatedDealList(dealsByActionTriggerEnumsMap);
            System.assertEquals(1, updatedDealsList.size(), 'The deal to be updated list must be size of 1 but "' + updatedDealsList.size() + '" was found.');
            Deal__c newDeal = updatedDealsList.get(0);
            System.assertNotEquals(null, newDeal.Acceptances__c, 'Acceptances__c are supposed to be 0 as the deal action updated with key "' + + '" and null values' + newDeal.Acceptances__c + '" was found.');
            System.assertNotEquals(null, newDeal.Rejections__c, 'Rejections__c are supposed to be 0 as the deal action updated with key "' + + '" and null values' + newDeal.Rejections__c + '" was found.');
            System.assertNotEquals(null, newDeal.Available_Deals__c, 'Available_Deals__c are supposed to be 0 as the deal action updated with key "' + + '" and null values' + newDeal.Available_Deals__c + '" was found.');
            System.assertNotEquals(null, newDeal.Max_Acceptances__c, 'Max_Acceptances__c are supposed to be 0 as the deal action updated with key "' + + '" and null values' + newDeal.Max_Acceptances__c + '" was found.');
        }

        Test.stopTest();
    }

    /**
     * Test if null values in contact fields are correctly handled.
     */
    static testMethod void testNullValuesInContact() {
        Test.startTest();

        for (DealActionTriggerEnum dealActionTriggerEnum: DealActionTriggerEnum.values()) {
            initWithNull();
            Map<DealActionTriggerEnum, List<Contact>> contactsByActionTriggerEnumsMap = new Map<DealActionTriggerEnum, List<Contact>>();
            contactsByActionTriggerEnumsMap.put(dealActionTriggerEnum, CONTACTLIST_FOR_TEST);
            List<Contact> updatedContactsList = DealActionTriggerHandler.getUpdatedContactList(contactsByActionTriggerEnumsMap);
            System.assertEquals(1, updatedContactsList.size(), 'The contact to be updated list must be size of 1 but "' + updatedContactsList.size() + '" was found.');
            Contact newContact = updatedContactsList.get(0);
            System.assertNotEquals(null, newContact.Deals_Accepted__c, 'Deals_Accepted__c are supposed to be 0 as the deal action updated with key "' + + '" and null values' + newContact.Deals_Accepted__c + '" was found.');
            System.assertNotEquals(null, newContact.Deals_Rejected__c, 'Deals_Rejected__c are supposed to be 0 as the deal action updated with key "' + + '" and null values' + newContact.Deals_Rejected__c + '" was found.');
        }

        Test.stopTest();
    }
}