/**
 * Created by charlottew on 3/22/2017.
 */

global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> leadList = [Select LeadSource from Lead where LeadSource ='' LIMIT 200];
        List<Lead> updateLeadList = new List<Lead>();
        for (Lead lead: leadList) {
            lead.LeadSource = 'Dreamforce';
            updateLeadList.add(lead);
        }

        update updateLeadList;
    }
}