/**
 * Trigger on insert or update a Deal Action (Deal_Action__c).
 *
 * When a deal action is created or updated we must be sure that deal is available.
 * If the related deal have no more available or is not valid anymore, will throw an exception
 */
trigger DealActionBeforeUpsertTrigger on Deal_Action__c (before insert, before update) {

    // Map each deal id with related deal action
    Map<Id, Deal_Action__c> dealIdDealActionObjectMap = new Map<Id, Deal_Action__c>();
    for (Deal_Action__c dealAction: Trigger.new) {
        Id dealId = dealAction.Deal__c;
        if (dealId != null) {
            dealIdDealActionObjectMap.put(dealId, dealAction);
        }
    }

    // retrieve all related deals
    Set<Id> dealIdSet = dealIdDealActionObjectMap.keySet();
    List<Deal__c> relatedDealsList = [
            Select Available_Deals__c, Valid_Through__c
            from Deal__c
            where Deal__c.Id = :dealIdSet
    ];

    // For each applicable deal
    for (Deal__c deal: relatedDealsList) {
        if (deal != null) {
            Deal_Action__c dealAction = dealIdDealActionObjectMap.get(deal.Id);
            if (dealAction.Action__c == null || dealAction.Action__c == DealActionConstants.STATUS_ACCEPTED) {
                // Exist available deal ?
                if (deal.Available_Deals__c <= 0) {
                    // Can not use this deal, so throw an exception
                    dealAction.addError(Label.No_More_Available_Deal);
                }
            }

            // Is the deal still valid ?
            if (deal.Valid_Through__c < System.now()) {
                // Can not use this deal, so throw an exception
                dealAction.addError(Label.Deal_Not_Valid_Anymore);
            }
        }
    }
}