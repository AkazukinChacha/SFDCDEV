public class NewCaseListController {

    public List<Case> getNewCases() {
        List<Case> result = [Select ID, CaseNumber from Case where status='New'];
        return result;
    }
}