/**
 * Trigger on insert, update or undelete a Deal Action (Deal_Action__c).
 *
 * When a deal action is created or updated, four fields need to be updated on the related contact and deal.
 * This happens on after insert or update to be sure that Deal Action is currently created or updated and maintain coherence of the fields.
 */
trigger DealActionUpsertUndeleteTrigger on Deal_Action__c (after insert, after update, after undelete) {

    Map<DealActionTriggerEnum, List<Id>> dealActionEnumContactIdMap = new Map<DealActionTriggerEnum, List<Id>>();
    Set<Id> totalContactSet = new Set<Id>();
    Map<DealActionTriggerEnum, List<Id>> dealActionEnumDealIdMap = new Map<DealActionTriggerEnum, List<Id>>();
    Set<Id> totalDealtSet = new Set<Id>();
    // Retrieve contact and deal only if the Action field changed
    for (Id dealActionId : Trigger.newMap.keySet()) {
        // check if changes applied
        DealActionTriggerEnum dealActionTriggerEnum = null;
        Deal_Action__c dealAction = Trigger.newMap.get(dealActionId);
        if (Trigger.isInsert || Trigger.isUndelete) {
            dealActionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(null, dealAction.Action__c, false);
        } else if (Trigger.isUpdate) {
            Deal_Action__c oldDealAction = Trigger.oldMap.get(dealActionId);
            dealActionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(oldDealAction.Action__c, dealAction.Action__c, false);
        }

        // Action field has changed!
        if (dealActionTriggerEnum != null) {
            List<Id> contactList = dealActionEnumContactIdMap.get(dealActionTriggerEnum);
            if (contactList == null) {
                contactList = new List<Id>();
                dealActionEnumContactIdMap.put(dealActionTriggerEnum, contactList);
            }
            Id contactId = dealAction.Contact__c;
            contactList.add(contactId);
            totalContactSet.add(contactId);

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

    // Retrieve related contact.
    Map<Id, Contact> relatedContact = new Map<Id, Contact>([Select Id, Deals_Accepted__c, Deals_Rejected__c from Contact where Id = :totalContactSet]);
    Map<DealActionTriggerEnum, List<Contact>> contactActionMap = new Map<DealActionTriggerEnum, List<Contact>>();
    for (DealActionTriggerEnum dealActionTriggerEnum: dealActionEnumContactIdMap.keySet()) {
        List<Id> contactIdList = dealActionEnumContactIdMap.get(dealActionTriggerEnum);
        for (Id contactId: contactIdList) {
            Contact contact = relatedContact.get(contactId);
            List<Contact> contactListInMap = contactActionMap.get(dealActionTriggerEnum);
            if (contactListInMap == null) {
                contactListInMap = new List<Contact>();
                contactActionMap.put(dealActionTriggerEnum, contactListInMap);
            }
            contactListInMap.add(contact);
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

    List<Contact> toBeUpdatedContactList = DealActionTriggerHandler.getUpdatedContactList(contactActionMap);
    List<Deal__c> toBeUpdatedDealList = DealActionTriggerHandler.getUpdatedDealList(dealActionMap);

    if (toBeUpdatedContactList.size() > 0) {
        try {
            update toBeUpdatedContactList;
        } catch (DmlException e) {
            System.debug(System.LoggingLevel.ERROR, e.getMessage());
        }
    }
    if (toBeUpdatedDealList.size() > 0) {
        try {
            update toBeUpdatedDealList;
        } catch (DmlException e) {
            System.debug(System.LoggingLevel.ERROR, e.getMessage());
        }
    }
}