/**
 * Created by charlottew on 3/22/2017.
 */

global class LeadProcessor implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('Select Id, LeadSource from Lead');
    }

    global void execute(Database.BatchableContext bc, List<Lead> records) {
        // process each batch of records
        List<Lead> leadList = new List<Lead>();
        for (Lead lead: records) {
            lead.LeadSource = 'Dreamforce';
            leadList.add(lead);
        }

        update leadList;
    }

    global void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}