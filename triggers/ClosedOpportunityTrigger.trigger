//trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
//    List<Task> toBeCreatedTaskList = new List<Task>();
//
//    for (Opportunity o : Trigger.New) {
//        if (o.StageName == 'Closed Won') {
//        Task t = new Task(Subject='Follow Up Test Task');
//        t.WhatId = o.Id;
//        toBeCreatedTaskList.add(t);
//
//        }
//
//
//    }
//
//
//    if (toBeCreatedTaskList.size() > 0) {
//        insert toBeCreatedTaskList;
//    }
//}

trigger ClosedOpportunityTrigger on Opportunity (before insert) {

}