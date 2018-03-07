/**
 * This class implement the Schedulable interface in the purpose of calling APIVersionsBatch.
 *
 * The executeBatch method will "restrict" the scope to the callout limits (10) as the APIVersionsBatch make callout.
 */
global class APIVersionsScheduledBatchable implements Schedulable {

    global void execute(SchedulableContext sc) {
        APIVersionsBatch batchable = new APIVersionsBatch();
        // Limit of 10 callout per batch
        Database.executeBatch(batchable, 10);
    }
}