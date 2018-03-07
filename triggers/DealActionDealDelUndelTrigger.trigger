/**
 * Trigger on delete or undelete a Deal(Deal__c).
 *
 * When a deal is delete, four fields need to be updated on the related contacts.
 */
trigger DealActionDealDelUndelTrigger on Deal__c (before delete, after undelete) {

    boolean deleted = Trigger.isDelete;
    Map<Id, Deal__c> dealMap;
    if (deleted) {
        dealMap = Trigger.oldMap;
    } else {
        dealMap = Trigger.newMap;
    }

    Map<Id, Deal_Action__c> dealActionMap = new Map<Id, Deal_Action__c>([
            Select Action__c, Contact__c
            from Deal_Action__c
            where Deal_Action__c.Deal__c in :dealMap.keySet()
    ]);

    Map<DealActionTriggerEnum, List<Id>> dealActionEnumContactIdMap = new Map<DealActionTriggerEnum, List<Id>>();
    Set<Id> totalContactSet = new Set<Id>();
    // Retrieve deal only if the Action field changed
    for (Deal_Action__c dealAction : dealActionMap.values()) {
        // check if changes applied
        DealActionTriggerEnum dealActionTriggerEnum = DealActionTriggerEnumHandler.getDealActionTriggerEnum(null, dealAction.Action__c, deleted);

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

    List<Contact> toBeUpdatedContactList = DealActionTriggerHandler.getUpdatedContactList(contactActionMap);

    if (toBeUpdatedContactList.size() > 0) {
        try {
            update toBeUpdatedContactList;
        } catch (DmlException e) {
            System.debug(System.LoggingLevel.ERROR, e.getMessage());
        }
    }
}