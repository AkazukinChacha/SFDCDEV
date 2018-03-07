trigger OrderEventTrigger on Order_Event__e (after insert) {
  // List to hold all tasks to be created.
    List<Task> tasks = new List<Task>();
    
    // Get user Id for task owner
    User user = [SELECT Id FROM User WHERE Username = 'charlotte.welle@absi.be' LIMIT 1];
       
    // Iterate through each notification.
    for (Order_Event__e event : Trigger.New) {
        if (event.Has_Shipped__c == true) {
            // Create Task to dispatch new team.
            Task newTask = new Task();
            newTask.Priority = 'Medium';
            newTask.Status = 'New';
            newTask.Subject = 'Follow up on shipped order ' + event.Order_Number__c;
            newTask.OwnerId = user.Id;
            tasks.add(newTask);
        }
   }
    
    // Insert all tasks corresponding to events received.
    insert tasks;
}