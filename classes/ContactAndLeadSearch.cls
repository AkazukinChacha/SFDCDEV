public class ContactAndLeadSearch {

    public static List<List<SObject>> searchContactsAndLeads(String param) {
    	List<List<SObject>> result = [FIND :param IN NAME FIELDS RETURNING Lead(FirstName, LastName), Contact(FirstName, LastName)];
        
        return result;
    }
}