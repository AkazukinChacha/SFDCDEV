/**
 * Trigger on delete a Contact.
 *
 * When a contact is delete, four fields need to be updated on the related deals.
 */
trigger DealActionContactDelUndelTrigger on Contact (before delete, after undelete ) {

    boolean deleted = Trigger.isDelete;
    Map<Id, Contact> contactMap;
    if (deleted) {
        contactMap = Trigger.oldMap;
    } else {
        contactMap = Trigger.newMap;
    }

    Map<Id, Deal_Action__c> dealActionsMap = new Map<Id, Deal_Action__c>([
            Select Action__c, Deal__c
            from Deal_Action__c
            where Deal_Action__c.Contact__c = :contactMap.keySet()
    ]);

    Map<DealActionTriggerEnum, List<Id>> dealActionEnumDealIdMap = new Map<DealActionTriggerEnum, List<Id>>();
    Set<Id> totalDealtSet = new Set<Id>();
    // Retrieve contact and deal only if the Action field changed
    for (Id dealActionId : dealActionsMap.keySet()) {
        // check if changes applied
        Deal_Action__c dealAction = dealActionsMap.get(dealActionId);
        DealActionTriggerEnum dealActionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(null, dealAction.Action__c, deleted);

        // Action field has changed!
        if (dealActionTriggerEnum != null) {
            List<Id> dealList = dealActionEnumDealIdMap.get(dealActionTriggerEnum);
            if (dealList == null) {
                dealList = new List<Id>();
                dealActionEnumDealIdMap.put(dealActionTriggerEnum, dealList);
            }
            Id dealId = dealAction.Deal__c;
            dealList.add(dealId);
            totalDealtSet.add(dealId);
        }
    }

    // Retrieve related deal.
    Map<Id, Deal__c> relatedDeal = new Map<Id, Deal__c>([Select Acceptances__c, Rejections__c, Max_Acceptances__c, Available_Deals__c from Deal__c where Id = :totalDealtSet]);
    Map<DealActionTriggerEnum, List<Deal__c>> dealActionMap = new Map<DealActionTriggerEnum, List<Deal__c>>();
    for (DealActionTriggerEnum dealActionTriggerEnum: dealActionEnumDealIdMap.keySet()) {
        List<Id> dealIdList = dealActionEnumDealIdMap.get(dealActionTriggerEnum);
        for (Id dealId: dealIdList) {
            Deal__c deal = relatedDeal.get(dealId);
            List<Deal__c> dealListInMap = dealActionMap.get(dealActionTriggerEnum);
            if (dealListInMap == null) {
                dealListInMap = new List<Deal__c>();
                dealActionMap.put(dealActionTriggerEnum, dealListInMap);
            }
            dealListInMap.add(deal);
        }
    }

    List<Deal__c> toBeUpdatedDealList = DealActionTriggerHandler.getUpdatedDealList(dealActionMap);

    if (toBeUpdatedDealList.size() > 0) {
        try {
            update toBeUpdatedDealList;
        } catch (DmlException e) {
            System.debug(System.LoggingLevel.ERROR, e.getMessage());
        }
    }
}