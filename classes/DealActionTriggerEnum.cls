/**
 * Enum action for the DealActionUpsertTrigger, DealActionDeleteTrigger and DealActionTriggerHandler.
 *
 * each enum represent an operation.
 */
public enum DealActionTriggerEnum {

    /**
     * Action of Deal_Action__c changed from Accepted to Rejected.
     */
    CHANGED_FROM_ACCEPTED_TO_REJECTED,
    /**
     * Action of Deal_Action__c changed from Rejected to Accepted.
     */
    CHANGED_FROM_REJECTED_TO_ACCEPTED,
    /**
     * Action of Deal_Action__c changed from empty value to Rejected.
     */
    CHANGED_FROM_EMPTY_TO_REJECTED,
    /**
     * Action of Deal_Action__c changed from empty value to Accepted.
     */
    CHANGED_FROM_EMPTY_TO_ACCEPTED,
    /**
     * Action of Deal_Action__c changed from Rejected value to empty.
     */
    CHANGED_FROM_REJECTED_TO_EMPTY,
    /**
     * Action of Deal_Action__c changed from Accepted value to empty.
     */
    CHANGED_FROM_ACCEPTED_TO_EMPTY,
      /**
     * Action of Deal_Action__c with Accepted deleted.
     */
    DELETED_FROM_ACCEPTED,
    /**
     * Action of Deal_Action__c with Rejected deleted.
     */
    DELETED_FROM_REJECTED
}