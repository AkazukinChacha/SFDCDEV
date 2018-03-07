/**
 * Handler of the DealActionTrigger.
 *
 * Consists of static methods handling the business logic of the DealActionUpsertTrigger and DealActionDeleteTrigger.
 */
public with sharing class DealActionTriggerHandler {

    /**
     * Return a list of updated contact to be updated.
     * Take the value of the map, the List<Contact>, then update the Deals_Accepted__c and Deals_Rejected__c according to the key of the map.
     *
     * @param contactActionMap key is either 'Accepted' or 'Rejected', values is the list of contact to be updated.
     * @return list of contact updated. This list is not saved before the return.
     */
    public static List<Contact> getUpdatedContactList(Map<DealActionTriggerEnum, List<Contact>> contactActionMap) {
        List<Contact> tmpContactList = new List<Contact>();
        for (DealActionTriggerEnum action: contactActionMap.keySet()) {
            if (DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_REJECTED == action) {
                List<Contact> contactList = updateContactRejectedDeal(contactActionMap.get(action), true);
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_ACCEPTED == action) {
                List<Contact> contactList = updateContactAcceptedDeal(contactActionMap.get(action), true);
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_ACCEPTED == action) {
                List<Contact> contactList = updateContactAcceptedDeal(contactActionMap.get(action), false);
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_REJECTED == action) {
                List<Contact> contactList = updateContactRejectedDeal(contactActionMap.get(action), false);
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_EMPTY == action) {
                List<Contact> contactList = updateContactDeletedAcceptedDeal(contactActionMap.get(action));
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_EMPTY == action) {
                List<Contact> contactList = updateContactDeletedRejectedDeal(contactActionMap.get(action));
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.DELETED_FROM_ACCEPTED == action) {
                List<Contact> contactList = updateContactDeletedAcceptedDeal(contactActionMap.get(action));
                tmpContactList.addAll(contactList);
            } else if (DealActionTriggerEnum.DELETED_FROM_REJECTED == action) {
                List<Contact> contactList = updateContactDeletedRejectedDeal(contactActionMap.get(action));
                tmpContactList.addAll(contactList);
            }
        }

        // Remove duplicates, we can not use Set to remove duplicates as the duplicate in the Set is based on the Hash, hash calculated on SObject values.
        List<Contact> result = removeContactsDuplicate(tmpContactList);

        return result;
    }

    /**
     * Return a list of updated Deal__c to be updated.
     * Take the value of the map, the List<Deal__c>, then update the Acceptances__c and Rejections__c according to the key of the map.
     * @Warning: Deal in the lists in the given map must contain those fields: Available_Deals__c, Rejections__c, Available_Deals__c and Max_Acceptances__c !
     *
     * @param dealActionMap key is either 'Accepted' or 'Rejected', values is the list of Deal__c to be updated.
     * @return list of Deal__c updated. This list is not saved before the return.
     */
    public static List<Deal__c> getUpdatedDealList(Map<DealActionTriggerEnum, List<Deal__c>> dealActionMap) {
        List<Deal__c> tmpDealsList = new List<Deal__c>();

        for (DealActionTriggerEnum action: dealActionMap.keySet()) {
            if (DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_REJECTED == action) {
                List<Deal__c> dealList = updateDealRejectedDeal(dealActionMap.get(action), true);
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_ACCEPTED == action) {
                List<Deal__c> dealList = updateDealAcceptedDeal(dealActionMap.get(action), true);
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_EMPTY == action) {
                List<Deal__c> dealList = updateDealDeletedAcceptedDeal(dealActionMap.get(action));
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_EMPTY == action) {
                List<Deal__c> dealList = updateDealDeletedRejectedDeal(dealActionMap.get(action));
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_ACCEPTED == action) {
                List<Deal__c> dealList = updateDealAcceptedDeal(dealActionMap.get(action), false);
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_REJECTED == action) {
                List<Deal__c> dealList = updateDealRejectedDeal(dealActionMap.get(action), false);
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.DELETED_FROM_ACCEPTED == action) {
                List<Deal__c> dealList = updateDealDeletedAcceptedDeal(dealActionMap.get(action));
                tmpDealsList.addAll(dealList);
            } else if (DealActionTriggerEnum.DELETED_FROM_REJECTED == action) {
                List<Deal__c> dealList = updateDealDeletedRejectedDeal(dealActionMap.get(action));
                tmpDealsList.addAll(dealList);
            }
        }

        // Remove duplicates, we can not use Set to remove duplicates as the duplicate in the Set is based on the Hash, hash calculated on SObject values.
        List<Deal__c> result = removeDealsDuplicate(tmpDealsList);

        return result;
    }

    private static List<Contact> removeContactsDuplicate(List<Contact> contactsList) {
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        for (Contact contact: contactsList) {
            contactMap.put(contact.Id, contact);
        }

        return contactMap.values();
    }

    private static List<Deal__c> removeDealsDuplicate(List<Deal__c> dealsList) {
        Map<Id, Deal__c> dealMap = new Map<Id, Deal__c>();
        for (Deal__c deal: dealsList) {
            dealMap.put(deal.Id, deal);
        }

        return dealMap.values();
    }

    private static List<Deal__c> updateDealAcceptedDeal(List<Deal__c> dealList, Boolean reverse) {
        List<Deal__c> result = new List<Deal__c>();

        for (Deal__c deal: dealList) {
            // Avoid Null pointer exception
            deal = checkDeal(deal);
            deal.Acceptances__c = deal.Acceptances__c + 1;
            // reverse the process ?
            if (reverse) {
                deal.Rejections__c = deal.Rejections__c - 1;
            } else {
                deal.Available_Deals__c = deal.Available_Deals__c - 1;
            }

            result.add(deal);
        }

        return result;
    }

    private static List<Deal__c> updateDealRejectedDeal(List<Deal__c> dealList, Boolean reverse) {
        List<Deal__c> result = new List<Deal__c>();

        for (Deal__c deal: dealList) {
            // avoid null pointer exception
            deal = checkDeal(deal);
            deal.Rejections__c = deal.Rejections__c + 1;
            // reverse the process ?
            if (reverse) {
                deal.Acceptances__c = deal.Acceptances__c - 1;
            } else {
                deal.Available_Deals__c = deal.Available_Deals__c - 1 ;
            }

            result.add(deal);
        }

        return result;
    }

    private static List<Deal__c> updateDealDeletedAcceptedDeal(List<Deal__c> dealList) {
        List<Deal__c> result = new List<Deal__c>();

        for (Deal__c deal: dealList) {
            // Avoid Null pointer exception
            deal = checkDeal(deal);
            deal.Acceptances__c = deal.Acceptances__c - 1;
            deal.Max_Acceptances__c = 0;
            deal.Available_Deals__c = deal.Available_Deals__c + 1;

            result.add(deal);
        }

        return result;
    }

    private static List<Deal__c> updateDealDeletedRejectedDeal(List<Deal__c> dealList) {
        List<Deal__c> result = new List<Deal__c>();

        for (Deal__c deal: dealList) {
            // Avoid Null pointer exception
            deal = checkDeal(deal);
            deal.Rejections__c = deal.Rejections__c - 1;
            deal.Available_Deals__c = deal.Available_Deals__c + 1;

            result.add(deal);
        }

        return result;
    }

    private static List<Contact> updateContactAcceptedDeal(List<Contact> contactList, Boolean reverse) {
        List<Contact> result = new List<Contact>();

        for (Contact contact: contactList) {
            // Avoid Null pointer exception
            checkContact(contact);
            contact.Deals_Accepted__c = contact.Deals_Accepted__c + 1;
            // reverse the process ?
            if (reverse) {
                contact.Deals_Rejected__c = contact.Deals_Rejected__c - 1;
            }

            result.add(contact);
        }

        return result;
    }

    private static List<Contact> updateContactRejectedDeal(List<Contact> contactList, Boolean reverse) {
        List<Contact> result = new List<Contact>();

        for (Contact contact: contactList) {
            // Avoid Null pointer exception
            checkContact(contact);
            contact.Deals_Rejected__c = contact.Deals_Rejected__c + 1;
            // reverse the process ?
            if (reverse) {
                contact.Deals_Accepted__c = contact.Deals_Accepted__c - 1;
            }

            result.add(contact);
        }

        return result;
    }

    private static List<Contact> updateContactDeletedAcceptedDeal(List<Contact> contactList) {
        List<Contact> result = new List<Contact>();

        for (Contact contact: contactList) {
            // Avoid Null pointer exception
            checkContact(contact);
            contact.Deals_Accepted__c = contact.Deals_Accepted__c - 1;

            result.add(contact);
        }

        return result;
    }

    private static List<Contact> updateContactDeletedRejectedDeal(List<Contact> contactList) {
        List<Contact> result = new List<Contact>();

        for (Contact contact: contactList) {
            // Avoid Null pointer exception
            checkContact(contact);
            contact.Deals_Rejected__c = contact.Deals_Rejected__c - 1;

            result.add(contact);
        }

        return result;
    }

    private static Contact checkContact(Contact contact) {
        contact.Deals_Accepted__c = contact.Deals_Accepted__c == null ? 0 : contact.Deals_Accepted__c;
        contact.Deals_Rejected__c = contact.Deals_Rejected__c == null ? 0 : contact.Deals_Rejected__c;

        return contact;
    }

    private static Deal__c checkDeal(Deal__c deal) {
        deal.Acceptances__c = deal.Acceptances__c == null ? 0 : deal.Acceptances__c;
        deal.Rejections__c = deal.Rejections__c == null ? 0 : deal.Rejections__c;
        deal.Available_Deals__c = deal.Available_Deals__c == null ? 0 : deal.Available_Deals__c;
        deal.Max_Acceptances__c = deal.Max_Acceptances__c == null ? 0 : deal.Max_Acceptances__c - deal.Acceptances__c;

        return deal;
    }
}