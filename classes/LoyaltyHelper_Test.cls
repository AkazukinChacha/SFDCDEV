/**
 * Created by charlottew on 5/16/2017.
 */
@IsTest(SeeAllData=false)
private class LoyaltyHelper_Test {
    static testMethod void testBehavior() {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];

        List<User> userList = new List<User>();
        Map<String, Id> emailMap = new Map<String, Id>();
        for (Integer i = 0; i < 10; i++) {
            String email = 'test' + i + '@myemail.com';
            User pu = getPortalUser(PortalType.PowerPartner, null, true, email);
            userList.add(pu);
            emailMap.put(email, pu.ContactId);
        }

        insert userList;

        Test.startTest();
        List<String> listStrings = new List<String>(emailMap.keySet());
        Map<String, Id> userMap = LoyaltyHelper.checkIfUsersExists(listStrings);

        System.assert(userMap != null, 'Map can not be null');
        System.assert(userMap.size() == 10);
        for (String username: userMap.keySet()) {
            Id userId = userMap.get(username);
            System.assert(emailMap.containsKey(username));
            Id contactId = emailMap.get(username);
            System.assertEquals(userId, contactId);
        }

        Test.stopTest();
    }

    static testMethod void testBehavior2() {
        List<String> emailList = new List<String>();

        Test.startTest();

        Map<String, Id> userMap = LoyaltyHelper.checkIfUsersExists(emailList);

        System.debug('TEST: ' + userMap.get('tetststst'));

        System.assert(userMap != null, 'Map can not be null');
        System.assert(userMap.size() == 0);

        Test.stopTest();
    }

    enum PortalType {
        CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess
    }


    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert, String testemail) {

        /* Make sure the running user has a role otherwise an exception
           will be thrown. */
        if (userWithRole == null) {

            if (UserInfo.getUserRoleId() == null) {

                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);

                userWithRole = new User(alias = 'hasrole', email = 'userwithrole@roletest1.com', userroleid = r.id,
                        emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                        localesidkey = 'en_US', profileid = UserInfo.getProfileId(),
                        timezonesidkey = 'America/Los_Angeles', username = testemail + 'c');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }

            System.assert(userWithRole.userRoleId  != null,
                    'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        Account a;
        Contact c;
        System.runAs(userWithRole) {

            a = new Account(name = 'TEST ACCOUNT');
            Database.insert(a);

            c = new Contact(AccountId = a.id, lastname = 'lastname');
            Database.insert(c);

        }

        /* Get any profile for the given type.*/
        Profile p = [
                select id
                from profile
                where usertype = :portalType.name()
                limit 1
        ];

        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                alias = 'cspu', lastname = 'lastname', contactId = c.id);

        return pu;
    }

}