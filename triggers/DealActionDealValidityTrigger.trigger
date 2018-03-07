/**
 * Trigger on update a Deal (Deal__c).
 *
 * When a deal is updated we must be sure that no active Deal Action is related to.
 * If an active Deal Action is related to, will throw an exception
 */
trigger DealActionDealValidityTrigger on Deal__c (before update) {

    Map<Id, Deal__c> dealIdMap = new Map<Id, Deal__c>();
    // never do a call in a loop!
    for (Deal__c deal: Trigger.new) {
        if (deal.Valid_Through__c < System.now()) {
            //  Check the valid through date
            dealIdMap.put(deal.id, deal);
        }
    }

    List<Deal_Action__c> dealActionList = [
            Select Id, Deal__c
            from Deal_Action__c
            where Deal_Action__c.Deal__c = :dealIdMap.keySet()
    ];

    for (Deal_Action__c dealAction: dealActionList) {
        if (dealActionList.size() > 0) {
            Deal__c deal = dealIdMap.get(dealAction.Deal__c);
            deal.addError(Label.Can_Not_Update_Deal_With_Invalid_Date_And_Related_Deal_Action);
        }
    }
}