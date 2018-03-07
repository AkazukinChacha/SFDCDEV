public class AccountHandler {

    public static Account insertNewAccount(String accountName) {
        Account result = null;
        if (!''.equals(accountName)) {
            Account newAccount = new Account(Name=accountName);
        
        	Database.SaveResult resultS = Database.insert(newAccount);
            if (resultS.isSuccess()) {
                result = newAccount;
            }

        }
                        
		return result;        
    }
}