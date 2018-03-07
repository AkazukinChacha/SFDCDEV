/**
 * Created by charlottew on 3/22/2017.
 */

public class AddPrimaryContact implements Queueable {

    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        List<Account> accountList = [Select Id from Account where BillingState= :this.state LIMIT 200];
        List<Contact> contactToInsert = new List<Contact>();
        for (Account account: accountList) {
            Contact newContact = this.contact.clone();
            newContact.AccountId = account.Id;
            contactToInsert.add(newContact);
        }

        insert contactToInsert;
    }
}