/**
 * Created by charlottew on 8/8/2017.
 */

public with sharing class CampingController {
    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        
        Account result = [Select Name from Account where Id = :accountId];

        return result;
    }
}