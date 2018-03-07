public class RandomContactFactory {

    public static List<Contact> generateRandomContacts(Integer nbContactToGenerate, String lastNameContactGenerated) {
        List<Contact> result = new List<Contact>();
        
        for (Integer i=0; i < nbContactToGenerate; i++) {
            String firstName = 'Test '+ i;
            Contact newContact = new Contact(FirstName=firstName, LastName=lastNameContactGenerated);
            result.add(newContact);
        }
        
        return result;
    }
    
}