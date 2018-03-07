/**
 * Class implementing Database.Batchable<sObject>.
 *
 * Starting with query all salesforce instance object.
 * Then in the execution, will make a callout and update the API_Version__c to the lastest if needed.
 * As it make callout, be aware of the limit of 10 callouts.
 */
global class APIVersionsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('Select Name, API_Version__c, Server_Url__c from Salesforce_Instance__c');
    }

    global void execute(Database.BatchableContext bc, List<Salesforce_Instance__c> records) {
        APIVersionsHelper.updateSalesforceInstances(records);
    }

    global void finish(Database.BatchableContext bc) {
        // Nothing to do
    }
}