@isTest
private class TestVerifyDate {
    @isTest static void testDate1EqualDate2() {
        Date date1 = Date.today();
        Date date2 = Date.today();

        Date pri = VerifyDate.CheckDates(date1, date2);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(date2, pri);
    }
    
    @isTest static void testDate1BeforeDate2Less30() {
        Date date1 = Date.today();
        Date date2 = Date.today().addDays(2);

        Date pri = VerifyDate.CheckDates(date1, date2);

        System.assertEquals(date2, pri);
    }
    
    @isTest static void testDate1BeforeDate2More30() {
        Date date1 = Date.today();
        Date date2 = Date.today().addDays(+32);

        Date pri = VerifyDate.CheckDates(date1, date2);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, pri);    
    }
    
    @isTest static void testDate1BeforeDate2Equal30() {
        Date date1 = Date.today();
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date date2 = Date.newInstance(date1.year(), date1.month(), totalDays);

        Date pri = VerifyDate.CheckDates(date1, date2);
        Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(date2, pri);
    }
    
    @isTest static void testDate1AfterDate2() {
        Date date1 = Date.today();
        Date date2 = Date.today().addDays(-2);

        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date pri = VerifyDate.CheckDates(date1, date2);
        Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, pri);
    }
}