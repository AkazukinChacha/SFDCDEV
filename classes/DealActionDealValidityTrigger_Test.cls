/**
 * Test class for the DealActionDealValidityTrigger.
 *
 * Should give 100% of code coverage
 */
@IsTest(SeeAllData=false)
private class DealActionDealValidityTrigger_Test {

    /**
     * Test an update of the deal with an invalid valid through date and one deal action to empty.
     */
    static testMethod void testUpdateWithInvalidDateAndRemainOpenDealAction() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_EMPTY);
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        Test.startTest();
        try {
            deal.Valid_Through__c = System.now().addMonths(-1);
            update deal;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action) , 'The error message must contain "' + Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update of the deal with an invalid valid through date and one deal action to Accepted.
     */
    static testMethod void testUpdateWithInvalidDateAndRemainAcceptedDealAction() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_ACCEPTED);
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        Test.startTest();
        try {
            deal.Valid_Through__c = System.now().addMonths(-1);
            update deal;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action) , 'The error message must contain "' + Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

    /**
     * Test an update of the deal with an invalid valid through date and one deal action to Rejected.
     */
    static testMethod void testUpdateWithInvalidDateAndRemainRejectedDealAction() {
        Contact contact = new Contact(LastName = 'Dupont');
        Deal__c deal = new Deal__c(Acceptances__c = 0, Rejections__c = 0, Available_Deals__c = 100, Max_Acceptances__c = 100);

        insert contact;
        insert deal;

        Deal_Action__c dealAction = new Deal_Action__c(Action__c = DealActionConstants.STATUS_REJECTED);
        dealAction.Contact__c = contact.Id;
        dealAction.Deal__c = deal.Id;
        insert dealAction;

        Test.startTest();
        try {
            deal.Valid_Through__c = System.now().addMonths(-1);
            update deal;
            System.assert(false, 'An exception should have been thrown by the trigger but was not.');
        } catch (Exception e) {
            System.Assert(e.getMessage().contains(Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action) , 'The error message must contain "' + Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action + '" but is "' + e.getMessage() + '"');
        }

        Test.stopTest();
    }

}