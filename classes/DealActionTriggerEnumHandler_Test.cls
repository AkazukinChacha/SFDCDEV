/**
 * Test class for the DealActionTriggerEnumHandler.
 *
 * Should give 100% of code coverage
 */
@IsTest(SeeAllData=false)
private class DealActionTriggerEnumHandler_Test {

    /**
     * Test deal action old value null, new value null & delete = false.
     */
    static testMethod void testOldNullToNewNullNodelete() {
        String oldValue = null;
        String newValue = null;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(null, actionTriggerEnum, 'As the old value is null, the new value is null and delete is false, a null value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value null, new value 'Accepted' & delete = false.
     */
    static testMethod void testOldNullToNewAcceptedNodelete() {
        String oldValue = null;
        String newValue = DealActionConstants.STATUS_ACCEPTED;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_ACCEPTED, actionTriggerEnum, 'As the old value is null, the new value is "Accepted" and delete is false, a CHANGED_FROM_EMPTY_TO_ACCEPTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value null, new value 'Rejected' & delete = false.
     */
    static testMethod void testOldNullToNewRejectedNotdelete() {
        String oldValue = null;
        String newValue = DealActionConstants.STATUS_REJECTED;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_REJECTED, actionTriggerEnum, 'As the old value is null, the new value is "Rejected" and delete is false, a CHANGED_FROM_EMPTY_TO_REJECTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Accepted', new value 'Accepted' & delete = false.
     */
    static testMethod void testOldAcceptedToNewAcceptedNotdelete() {
        String oldValue = DealActionConstants.STATUS_ACCEPTED;
        String newValue = DealActionConstants.STATUS_ACCEPTED;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(null, actionTriggerEnum, 'As the old value is "Accepted", the new value is "Accepted" and delete is false, a null value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Accepted', new value 'Rejected' & delete = false.
     */
    static testMethod void testOldAcceptedToNewRejectedNotdelete() {
        String oldValue = DealActionConstants.STATUS_ACCEPTED;
        String newValue = DealActionConstants.STATUS_REJECTED;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_REJECTED, actionTriggerEnum, 'As the old value is "Accepted", the new value is "Rejected" and delete is false, a CHANGED_FROM_ACCEPTED_TO_REJECTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Rejected', new value 'Rejected' & delete = false.
     */
    static testMethod void testOldRejectedToNewRejectedNotdelete() {
        String oldValue = DealActionConstants.STATUS_REJECTED;
        String newValue = DealActionConstants.STATUS_REJECTED;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(null, actionTriggerEnum, 'As the old value is "Rejected", the new value is "Rejected" and delete is false, a null value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Rejected', new value 'Accepted' & delete = false.
     */
    static testMethod void testOldRejectedToNewAcceptedNotdelete() {
        String oldValue = DealActionConstants.STATUS_REJECTED;
        String newValue = DealActionConstants.STATUS_ACCEPTED;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_ACCEPTED, actionTriggerEnum, 'As the old value is "Rejected", the new value is "Accepted" and delete is false, a CHANGED_FROM_REJECTED_TO_ACCEPTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value null, new value null & delete = true.
     */
    static testMethod void testOldNullToNewNullDelete() {
        String oldValue = null;
        String newValue = null;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(null, actionTriggerEnum, 'As the old value is null, the new value is null and delete is true, a null value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value null, new value 'Accepted' & delete = true.
     */
    static testMethod void testOldNullToNewAcceptedDelete() {
        String oldValue = null;
        String newValue = DealActionConstants.STATUS_ACCEPTED;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.DELETED_FROM_ACCEPTED, actionTriggerEnum, 'As the old value is null, the new value is "Accepted" and delete is true, a DELETED_FROM_ACCEPTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value null, new value 'Rejected' & delete = true.
     */
    static testMethod void testOldNullToNewRejectedDelete() {
        String oldValue = null;
        String newValue = DealActionConstants.STATUS_REJECTED;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.DELETED_FROM_REJECTED, actionTriggerEnum, 'As the old value is null, the new value is "Rejected" and delete is true, a DELETED_FROM_REJECTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Accepted', new value 'Accepted' & delete = false.
     */
    static testMethod void testOldAcceptedToNewAcceptedDelete() {
        String oldValue = DealActionConstants.STATUS_ACCEPTED;
        String newValue = DealActionConstants.STATUS_ACCEPTED;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.DELETED_FROM_ACCEPTED, actionTriggerEnum, 'As the old value is "Accepted", the new value is "Accepted" and delete is true, a DELETED_FROM_ACCEPTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Accepted', new value 'Rejected' & delete = true.
     */
    static testMethod void testOldAcceptedToNewRejectedDelete() {
        String oldValue = DealActionConstants.STATUS_ACCEPTED;
        String newValue = DealActionConstants.STATUS_REJECTED;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.DELETED_FROM_REJECTED, actionTriggerEnum, 'As the old value is "Accepted", the new value is "Rejected" and delete is true, a DELETED_FROM_REJECTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Rejected', new value 'Rejected' & delete = true.
     */
    static testMethod void testOldRejectedToNewRejectedDelete() {
        String oldValue = DealActionConstants.STATUS_REJECTED;
        String newValue = DealActionConstants.STATUS_REJECTED;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.DELETED_FROM_REJECTED, actionTriggerEnum, 'As the old value is "Rejected", the new value is "Rejected" and delete is true, a DELETED_FROM_REJECTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Rejected', new value 'Accepted' & delete = true.
     */
    static testMethod void testOldRejectedToNewAcceptedDelete() {
        String oldValue = DealActionConstants.STATUS_REJECTED;
        String newValue = DealActionConstants.STATUS_ACCEPTED;
        boolean deleteValue = true;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.DELETED_FROM_ACCEPTED, actionTriggerEnum, 'As the old value is "Rejected", the new value is "Accepted" and delete is true, a DELETED_FROM_ACCEPTED value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Accepted', new value empty & delete = false.
     */
    static testMethod void testOldAcceptedToNewEmptyNotDelete() {
        String oldValue = DealActionConstants.STATUS_ACCEPTED;
        String newValue = null;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_EMPTY, actionTriggerEnum, 'As the old value is "Accepted", the new value is empty and delete is false, a CHANGED_FROM_ACCEPTED_TO_EMPTY value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }

    /**
     * Test deal action old value 'Rejected', new value empty & delete = false.
     */
    static testMethod void testOldRejectedToNewEmptyNotDelete() {
        String oldValue = DealActionConstants.STATUS_REJECTED;
        String newValue = null;
        boolean deleteValue = false;

        Test.startTest();
        DealActionTriggerEnum actionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldValue, newValue, deleteValue);
        System.assertEquals(DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_EMPTY, actionTriggerEnum, 'As the old value is "Rejected", the new value is empty and delete is false, a CHANGED_FROM_REJECTED_TO_EMPTY value was excepted instead of ' + actionTriggerEnum);
        Test.stopTest();
    }
}