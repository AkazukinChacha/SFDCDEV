trigger TestCodeTrigger on Opportunity (after insert) {
    List<Account> customers = new List<Account>();
    For (Opportunity o: trigger.new)
    {
        Account a = [SELECT Id FROM Account WHERE Id = :o.Id];
        customers.add(a);
    }
    Database.update(customers, false);
}