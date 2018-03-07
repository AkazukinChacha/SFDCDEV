public class ContactSearch {
    public static List<Contact> searchForContacts(String param, String mailingPostalCode) {
        Contact[] result = [SELECT Contact.ID, Contact.Name FROM Contact WHERE (LastName = :param AND MailingPostalCode = :mailingPostalCode)];
        
        return result;
    }
}