/**
 * Test class for the DealViewerExtension.
 *
 * Should give 100% of code coverage
 */
@isTest(seeAllData=false)
private class DealViewerExtension_Test {

    private static Contact CONTACT_FOR_TEST;
    private static Deal__c DEAL_FOR_TEST;

    static void init() {
        CONTACT_FOR_TEST = new Contact(LastName = 'Dupont');
        DEAL_FOR_TEST = new Deal__c(Available_Deals__c = 1000, Valid_Through__c = (System.Now().addMonths(2)));

        insert CONTACT_FOR_TEST;
        insert DEAL_FOR_TEST;
    }

    private static List<Deal_Action__c> getActionDeals(Integer nbOfDeals, String actionValue) {
        List<Deal_Action__c> result = new List<Deal_Action__c>();
        for (Integer i = 0; i < nbOfDeals; i++) {
            Deal_Action__c dealAction = new Deal_Action__c(Contact__c = CONTACT_FOR_TEST.id, Deal__c = DEAL_FOR_TEST.id, Action__c = actionValue);
            result.add(dealAction);
        }

        return result;
    }

    /**
     * Test if last/next page is enabled if more than 5 items exist.
     */
    static testMethod void testNextLastPageExist() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(10, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        System.assert(controller.setController.getHasNext(), 'Controller have 20 items so a it must have a next/last page.');
    }

    /**
     * Test if last/next page is disabled if less than 5 items exist.
     */
    static testMethod void testNextLastPageNotExist() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(5, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        System.assert(!controller.setController.getHasNext(), 'Controller have 5 items so a it must not have a next/last page.');
        Test.stopTest();
    }

    /**
     * Test if first/previous page is disabled if less than 5 items exist.
     */
    static testMethod void testPreviousFirstPageNotExist() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(5, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        System.assert(!controller.setController.getHasPrevious(), 'Controller have 5 items so a it must not have a first/previous page.');
        Test.stopTest();
    }

    /**
     * Test if first/previous page is disabled if less than 20 items exist and we are on the first page.
     */
    static testMethod void testPreviousFirstPageNotExistOnFirstPage() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(20, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        System.assert(!controller.setController.getHasPrevious(), 'Controller have 20 items so a it must not have a first/previous page as we are on the first page.');
        Test.stopTest();
    }

    /**
     * Test if first/previous page is enabled if less than 20 items exist and we are on the last page.
     */
    static testMethod void testPreviousFirstPageNotExistOnLastPage() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(20, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);
        controller.setController.last();

        System.assert(controller.setController.getHasPrevious(), 'Controller have 20 items so a it must have a first/previous page as we are on the last page.');
        Test.stopTest();
    }

    /**
     * Test if last/next page is disabled if less than 20 items exist and we are on the last page.
     */
    static testMethod void testNextLastPageNotExistOnLastPage() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(20, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);
        controller.setController.last();

        System.assert(!controller.setController.getHasNext(), 'Controller have 20 items so a it must not have a last/next page as we are on the last page.');
        Test.stopTest();
    }

    /**
     * Test if last/next page and first/previous are enabled if less than 20 items exist and we are on the last page.
     */
    static testMethod void testNextLastPreviousFirstPageNotExistOnMiddlePage() {
        init();

        List<Deal_Action__c> dealActionsList = getActionDeals(20, DealActionConstants.STATUS_EMPTY);
        insert dealActionsList;
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);
        controller.setController.next();

        System.assert(controller.setController.getHasNext(), 'Controller have 20 items so a it must not have a last/next page as we are on the middle page.');
        System.assert(controller.setController.getHasPrevious(), 'Controller have 20 items so a it must not have a first/previous as we are on the middle page.');
        Test.stopTest();
    }

    /**
     * Test done button show contact view.
     */
    static testMethod void testDonePage() {
        init();

        Test.startTest();
        //Create the controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        PageReference expectedPR = new ApexPages.StandardController(CONTACT_FOR_TEST).view();
        System.assertNotEquals(null, expectedPR, 'The excepted PageReference can not be null.');
        PageReference controllerDonePage = controller.done();
        System.assertNotEquals(null, controllerDonePage, 'The PageReference returned by the done() method of the controller can not be null.');

        System.assertEquals(expectedPR.getUrl(), controller.done().getUrl(), 'The PageReference returned by the done() method of the controller must be the expected page.');

        Test.stopTest();
    }

    /**
     * Test the total of acceptance. We put 5 'Accepted' and 5 'Rejected' so the total acceptance must be 0.5.
     */
    static testMethod void testTotalAcceptance() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(5, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(5, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;
        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        System.assertEquals(0.5, controller.totalAcceptance, 'As we put 5 "Accepted" Deal Action and 5 "Rejected" Deal Action, the result must be 0.5 but found ' + controller.totalAcceptance + '.');
        Test.stopTest();
    }

    /**
     * Test getRelatedDealActions().
     * We put 5 'Accepted' and 14 'Rejected' so the total of the list must be 5 items because only 5 elements is display at a time.
     */
    static testMethod void testRelatedDealActions() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(5, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(14, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        Test.stopTest();
    }

    /**
     * Test getRelatedDealActions(), count "Accepted" and "Rejected".
     * We put 2 "Accepted" and 2 "Rejected" so the total of the list must be 4 items.
     * It must exist 2 "Accepted" and 2 "Rejected" in the list retrieve by getRelatedDealActions()
     */
    static testMethod void testRelatedDealActionsCount() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(2, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(2, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(4, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 4 items but found ' + relatedDealActions.size() + '.');

        List<Deal_Action__c> acceptedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> rejectedDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            }
        }

        System.assertEquals(2, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 2, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(2, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 2 but found ' + rejectedDealActionList.size() + '.');

        Test.stopTest();
    }

    /**
     * Test accept() with an existing "Rejected" Deal Actions.
     * We put 1 empty Deal Action, 2 "Accepted" Deal Actions and 2 "Rejected" Deal Actions then call accept() method with an existing "Rejected" Deal Actions.
     */
    static testMethod void testAcceptWithRejectDealActions() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(2, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(2, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(1, DealActionConstants.STATUS_EMPTY);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        List<Deal_Action__c> acceptedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> rejectedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(2, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 2, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(2, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 2 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, emptyDealActionList.size(), 'The number of empty Deal Action must be 1 but found ' + emptyDealActionList.size() + '.');
        System.assertEquals(1, controller.currentDealsAvailable, 'The number of current available Deal Action must be 1, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(0, controller.currentReviewed, 'The number of current reviewed Deal Action must be 0, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(2, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 2, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(2, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 2, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.5, controller.totalAcceptance, 'As we put 2 "Accepted" Deal Action and 2 "Rejected" Deal Action, the result must be 0.5 but found ' + controller.totalAcceptance + '.');

        // call the accept method
        Test.setCurrentPage(Page.DealViewer);
        ApexPages.currentPage().getParameters().put('actionNumber', rejectedDealActionList.get(0).Name);
        controller.accept();

        // Check new values
        relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        acceptedDealActionList = new List<Deal_Action__c>();
        rejectedDealActionList = new List<Deal_Action__c>();
        emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(3, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 3, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(1, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 1 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, emptyDealActionList.size(), 'The number of empty Deal Action must be 1 but found ' + emptyDealActionList.size() + '.');
        System.assertEquals(1, controller.currentDealsAvailable, 'The number of current available Deal Action must be 1, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(1, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 1, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(1, controller.currentReviewed, 'The number of current reviewed Deal Action must be 1, but found ' + controller.currentReviewed + '.');
        System.assertEquals(1, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 1, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(3, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 3, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(1, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 1, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.75, controller.totalAcceptance, 'As we put 3 "Accepted" Deal Action and 1 "Rejected" Deal Action, the result must be 0.75 but found ' + controller.totalAcceptance + '.');

        Test.stopTest();
    }

    /**
     * Test reject() with an existing "Accepted" Deal Actions.
     * We put 1 empty Deal Action, 2 "Accepted" Deal Actions and 2 "Rejected" Deal Actions then call reject() method with an existing "Accepted" Deal Actions.
     */
    static testMethod void testRejectWithAcceptedDealActions() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(2, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(2, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(1, DealActionConstants.STATUS_EMPTY);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        List<Deal_Action__c> acceptedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> rejectedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(2, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 2, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(2, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 2 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, emptyDealActionList.size(), 'The number of empty Deal Action must be 1 but found ' + emptyDealActionList.size() + '.');
        System.assertEquals(1, controller.currentDealsAvailable, 'The number of current available Deal Action must be 1, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(0, controller.currentReviewed, 'The number of current reviewed Deal Action must be 0, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(2, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 2, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(2, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 2, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.5, controller.totalAcceptance, 'As we put 2 "Accepted" Deal Action and 2 "Rejected" Deal Action, the result must be 0.5 but found ' + controller.totalAcceptance + '.');

        // call the accept method
        Test.setCurrentPage(Page.DealViewer);
        ApexPages.currentPage().getParameters().put('actionNumber', acceptedDealActionList.get(0).Name);
        controller.reject();

        // Check new values
        relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        acceptedDealActionList = new List<Deal_Action__c>();
        rejectedDealActionList = new List<Deal_Action__c>();
        emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(1, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 1, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(3, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 3 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, emptyDealActionList.size(), 'The number of empty Deal Action must be 1 but found ' + emptyDealActionList.size() + '.');
        System.assertEquals(1, controller.currentDealsAvailable, 'The number of current available Deal Action must be 0, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(1, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 1, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(1, controller.currentReviewed, 'The number of current reviewed Deal Action must be 1, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(1, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 1, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(3, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 3, but found ' + controller.totalDealsRejected + '.');
        System.assertEquals(0.25, controller.totalAcceptance, 'As we have 1 "Accepted" Deal Action and 3 "Rejected" Deal Action, the result must be 0.25 but found ' + controller.totalAcceptance + '.');

        Test.stopTest();
    }

    /**
     * Test accept() with an empty Deal Actions.
     * We put 1 empty Deal Action, 2 "Accepted" Deal Actions and 2 "Rejected" Deal Actions then call accept() method with an empty Deal Actions.
     */
    static testMethod void testAcceptWithEmptyDealActions() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(2, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(2, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(1, DealActionConstants.STATUS_EMPTY);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        List<Deal_Action__c> acceptedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> rejectedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(2, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 2, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(2, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 2 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, emptyDealActionList.size(), 'The number of empty Deal Action must be 1 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, controller.currentDealsAvailable, 'The number of current available Deal Action must be 1, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(0, controller.currentReviewed, 'The number of current reviewed Deal Action must be 0, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(2, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 2, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(2, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 2, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.5, controller.totalAcceptance, 'As we put 2 "Accepted" Deal Action and 2 "Rejected" Deal Action, the result must be 0.5 but found ' + controller.totalAcceptance + '.');

        // call the accept method
        Test.setCurrentPage(Page.DealViewer);
        ApexPages.currentPage().getParameters().put('actionNumber', emptyDealActionList.get(0).Name);
        controller.accept();

        // Check new values
        relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        acceptedDealActionList = new List<Deal_Action__c>();
        rejectedDealActionList = new List<Deal_Action__c>();
        emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(3, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 3, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(2, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 2 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(0, emptyDealActionList.size(), 'The number of empty Deal Action must be 0 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(0, controller.currentDealsAvailable, 'The number of current available Deal Action must be 0, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(1, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 1, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(1, controller.currentReviewed, 'The number of current reviewed Deal Action must be 1, but found ' + controller.currentReviewed + '.');
        System.assertEquals(1, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 1, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(3, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 3, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(2, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 2, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.6, controller.totalAcceptance, 'As we put 3 "Accepted" Deal Action and 2 "Rejected" Deal Action, the result must be 0.6 but found ' + controller.totalAcceptance + '.');

        Test.stopTest();
    }

    /**
     * Test reject() with an empty Deal Actions.
     * We put 1 empty Deal Action, 2 "Accepted" Deal Actions and 2 "Rejected" Deal Actions then call reject() method with an empty Deal Actions.
     */
    static testMethod void testRejectWithEmptyDealActions() {
        init();

        List<Deal_Action__c> totalToInsert = new List<Deal_Action__c>();
        List<Deal_Action__c> dealActionsList = getActionDeals(2, DealActionConstants.STATUS_ACCEPTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(2, DealActionConstants.STATUS_REJECTED);
        totalToInsert.addAll(dealActionsList);
        dealActionsList = getActionDeals(1, DealActionConstants.STATUS_EMPTY);
        totalToInsert.addAll(dealActionsList);

        Test.startTest();
        insert totalToInsert;

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        List<Deal_Action__c> acceptedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> rejectedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(2, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 2, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(2, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 2 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(1, emptyDealActionList.size(), 'The number of empty Deal Action must be 2 but found ' + emptyDealActionList.size() + '.');
        System.assertEquals(1, controller.currentDealsAvailable, 'The number of current available Deal Action must be 1, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(0, controller.currentReviewed, 'The number of current reviewed Deal Action must be 0, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(2, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 2, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(2, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 2, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.5, controller.totalAcceptance, 'As we put 2 "Accepted" Deal Action and 2 "Rejected" Deal Action, the result must be 0.5 but found ' + controller.totalAcceptance + '.');

        // call the accept method
        Test.setCurrentPage(Page.DealViewer);
        ApexPages.currentPage().getParameters().put('actionNumber', emptyDealActionList.get(0).Name);
        controller.reject();

        // Check new values
        relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(5, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        acceptedDealActionList = new List<Deal_Action__c>();
        rejectedDealActionList = new List<Deal_Action__c>();
        emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(2, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 2, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(3, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 3 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(0, emptyDealActionList.size(), 'The number of "Rejected" Deal Action must be 3 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(0, controller.currentDealsAvailable, 'The number of current available Deal Action must be 0, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(1, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 1, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(1, controller.currentReviewed, 'The number of current reviewed Deal Action must be 1, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(2, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 2, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(3, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 3, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0.4, controller.totalAcceptance, 'As we put 1 "Accepted" Deal Action and 2 "Rejected" Deal Action, the result must be 0.4 but found ' + controller.totalAcceptance + '.');

        Test.stopTest();
    }

    /**
     * Test total acceptance to 0.
     */
    static testMethod void testTotalAcceptanceToZero() {
        init();

        Test.startTest();

        ApexPages.StandardController standardController = new ApexPages.StandardController(CONTACT_FOR_TEST);
        DealViewerExtension controller = new DealViewerExtension(standardController);

        List<Deal_Action__c> relatedDealActions = controller.relatedDealActions;
        System.assertNotEquals(null, relatedDealActions, 'The getRelatedDealActions() result can not be null.');
        System.assertEquals(0, relatedDealActions.size(), 'The getRelatedDealActions() result must contains 5 items but found ' + relatedDealActions.size() + '.');

        List<Deal_Action__c> acceptedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> rejectedDealActionList = new List<Deal_Action__c>();
        List<Deal_Action__c> emptyDealActionList = new List<Deal_Action__c>();
        for (Deal_Action__c dealAction: relatedDealActions) {
            if (DealActionConstants.STATUS_ACCEPTED.equals(dealAction.Action__c)) {
                acceptedDealActionList.add(dealAction);
            } else if (DealActionConstants.STATUS_REJECTED.equals(dealAction.Action__c)) {
                rejectedDealActionList.add(dealAction);
            } else {
                emptyDealActionList.add(dealAction);
            }
        }

        System.assertEquals(0, acceptedDealActionList.size(), 'The number of "Accepted" Deal Action must be 0, but found ' + acceptedDealActionList.size() + '.');
        System.assertEquals(0, rejectedDealActionList.size(), 'The number of "Rejected" Deal Action must be 0 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(0, emptyDealActionList.size(), 'The number of "Rejected" Deal Action must be 0 but found ' + rejectedDealActionList.size() + '.');
        System.assertEquals(0, controller.currentDealsAvailable, 'The number of current available Deal Action must be 0, but found ' + controller.currentDealsAvailable + '.');
        System.assertEquals(0, controller.currentDealsAccepted, 'The number of current accepted Deal Action must be 0, but found ' + controller.currentDealsAccepted + '.');
        System.assertEquals(0, controller.currentDealsRejected, 'The number of current rejected Deal Action must be 0, but found ' + controller.currentDealsRejected + '.');
        System.assertEquals(0, controller.currentReviewed, 'The number of current reviewed Deal Action must be 0, but found ' + controller.currentReviewed + '.');
        System.assertEquals(0, controller.currentAcceptance, 'The number of current acceptance Deal Action must be 0, but found ' + controller.currentAcceptance + '.');
        System.assertEquals(0, controller.totalDealsAccepted, 'The number of total accepted Deal Action must be 0, but found ' + controller.totalDealsAccepted + '.');
        System.assertEquals(0, controller.totalDealsRejected, 'The number of total rejected Deal Action must be 0, but found ' +controller.totalDealsRejected + '.');
        System.assertEquals(0, controller.totalAcceptance, 'As we did not put any Deal Action, the result must be 0 but found ' + controller.totalAcceptance + '.');

        Test.stopTest();
    }
}