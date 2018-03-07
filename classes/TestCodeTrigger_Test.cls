/**
 * Created by charlottew on 4/27/2017.
 */

@IsTest
private class TestCodeTrigger_Test {
    static testMethod void testBehavior() {
        List<Opportunity> toInsert = new List<Opportunity>();
        for (Integer i = 0; i < 150; i++) {
            Opportunity o = new Opportunity(Name='Test', StageName='Open', CloseDate=System.today());
            toInsert.add(o);
        }

        insert toInsert;
    }
}