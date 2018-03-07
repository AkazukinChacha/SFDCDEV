/**
 * Created by charlottew on 5/16/2017.
 */

public with sharing class LoyaltyHelper {

    /**
     * Check if the given emails are related to User.<br>
     * <ul>
     *     <li>No DML statements</li>
     *     <li>1 SOQL</li>
     *     <li>No SOSL</li>
     *     <li>No external callouts</li>
     * </ul>
     * @param email user email<br>
     * @return Map<String, Id> of the related users if exist.<br>
     *     <ul>
     *         <li>Key is the email.</li>
     *         <li>Value is the ContactId of the related User</li>
     *     </ul><br>
     * Map does not contains entry if user is null or ContactId of user is null.<br>
     * @see Req nr: 2016-1860 (Proj: 2016-146 CRM action codes)
     */
    public static Map<String, Id> checkIfUsersExists(List<String> emailList) {
        Map<String, Id> result = new Map<String, Id>();
        try {
            Map<Id, User> userMap = new Map<Id, User>([Select Id, Username, ContactId from User where Username in :emailList]);

            for (User u : userMap.values()) {
                Id contactId = u.ContactId;
                if (contactId != null) {
                    String username = u.Username;
                    result.put(username, contactId);
                }
            }
        } catch (QueryException e) {    // right exception
            // Nothing to do
        }

        return result;
    }
}