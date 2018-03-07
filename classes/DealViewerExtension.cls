/**
 * Extension for the DealViewer visualforce page.
 */
public class DealViewerExtension {

    private final Contact contact;

    /**
     * Percent of deals reviewed that have been accepted in the current Deal Viewer session.
     */
    public Double currentAcceptance { get; set; }
    /**
     * Number of deals accepted during the current Deal Viewer session.
     */
    public Integer currentDealsAccepted { get; set; }
    /**
     * Number of deals rejected during the current Deal Viewer session.
     */
    public Integer currentDealsRejected { get; set; }
    /**
     *  Number of deals either accepted or rejected during the current Deal Viewer session.
     */
    public Integer currentReviewed { get; set; }
    /**
     *  Number of remaining available deals that have not yet been accepted or rejected by the contact.
     */
    public Integer currentDealsAvailable { get; set; }
    /**
     * Number of page in the deal list table.
     */
    public Long numberOfPages { get; set; }
    /**
     *  Percent of all deals ever reviewed by contact that have been accepted.
     */
    public Double totalAcceptance { get; set; }
    /**
     * Number of all deals ever that have been accepted by contact.
     */
    public Integer totalDealsAccepted { get; set; }
    /**
     * Number of all deals ever that have been rejected by contact.
     */
    public Integer totalDealsRejected { get; set; }

    /**
     * StandardSetController for the Deal Table.
     *
     * @return the standard set controller
     */
    public ApexPages.StandardSetController setController {
        get {
            if (setController == null) {
                setController = new ApexPages.StandardSetController(Database.getQueryLocator(
                [
                        Select Deal__r.Name, Deal__r.Available_Deals__c, Deal__r.Valid_Through__c, Name, Action__c
                        from Deal_Action__c
                        where Deal_Action__c.Contact__c = :this.contact.id
                        and Deal__c in (
                                Select Id
                                from Deal__c
                                where Deal__c.Available_Deals__c > 0
                                and Deal__c.Valid_Through__c >= :System.Now()
                        )
                        order by Deal_Action__c.Deal__r.Valid_Through__c ASC,
                                Deal_Action__c.Deal__r.Available_Deals__c DESC,
                                Deal_Action__c.Deal__r.Name ASC
                ]));

                setController.setPageSize(5);
                Integer noOfRecords = setController.getResultSize();
                this.numberOfPages = ((Decimal) noOfRecords / 5).round(System.RoundingMode.CEILING);
            }
            return setController;
        }
        set;
    }

    /**
     * Constructor.
     *
     * @param stdController standard controller of the DealViewer visualforce page.
     */
    public DealViewerExtension(ApexPages.StandardController stdController) {
        this.contact = (Contact) stdController.getRecord();

        this.currentAcceptance = 0;
        this.currentReviewed = 0;
        this.currentDealsAccepted = 0;
        this.currentDealsRejected = 0;
        this.currentDealsAvailable = 0;
        this.totalDealsAccepted = 0;
        this.totalDealsRejected = 0;

        AggregateResult[] aggregateResults = [
                SELECT count(Id) countedAction, Action__c
                FROM Deal_Action__c
                GROUP BY Deal_Action__c.Action__c
        ];
        Map<String, Integer> countActionMap = new Map<String, Integer>();
        for (AggregateResult aggregateResult : aggregateResults) {
            countActionMap.put((String) aggregateResult.get('Action__c'), (Integer) aggregateResult.get('countedAction'));
        }

        Integer count = countActionMap.get('Accepted');
        if (count != null) {
            this.totalDealsAccepted = count;
        }
        count = countActionMap.get('Rejected');
        if (count != null) {
            this.totalDealsRejected = count;
        }
        count = countActionMap.get(null);
        if (count != null) {
            this.currentDealsAvailable = count;
        }
        Integer total = this.totalDealsAccepted + this.totalDealsRejected;
        if (total > 0) {
            Double doubleTotalDealsAccepted = (Double) this.totalDealsAccepted;
            Double doubleTotalDealsRejected = (Double) this.totalDealsRejected;
            this.totalAcceptance = doubleTotalDealsAccepted / total;
        } else {
            this.totalAcceptance = 0;
        }
    }

    /**
     * Implementation of the "done" action in the DealViewer visualforce page.
     *
     * @return a page reference to the current contact view page.
     */
    public PageReference done() {
        PageReference pageReference = new ApexPages.StandardController(this.contact).view();

        return pageReference;
    }

    /**
     * Get the related Deal Actions.
     *
     * @return list of Deal Actions related to the current contact.
     */
    public List<Deal_Action__c> relatedDealActions {
        get {
            return (List<Deal_Action__c>) setController.getRecords();
        }
        set;
    }

    /**
     * Accept the selected deal.
     */
    public void accept() {
        Boolean changedFromEmptyToAccepted = changeActionStatus('Accepted', -1);
        if (changedFromEmptyToAccepted != null) {
            this.currentDealsAccepted++;
            this.totalDealsAccepted++;
            if (changedFromEmptyToAccepted) {
                this.currentDealsAvailable--;
            } else {
                this.totalDealsRejected--;
            }
            updateAcceptances();
        }
    }

    /**
     * Reject the selected deal.
     */
    public void reject() {
        Boolean changedFromEmptyToRejected = changeActionStatus('Rejected', 0);
        if (changedFromEmptyToRejected != null) {
            this.currentDealsRejected++;
            this.totalDealsRejected++;
            if (changedFromEmptyToRejected) {
                this.currentDealsAvailable--;
            } else {
                this.totalDealsAccepted--;
            }
            updateAcceptances();
        }
    }

    private void updateAcceptances() {
        // Update current acceptance
        if (this.currentReviewed != 0) {
            Double doubleCurrentReviewed = (Double) this.currentReviewed;
            Double doubleCurrentDealsAccepted = (Double) this.currentDealsAccepted;
            this.currentAcceptance = doubleCurrentDealsAccepted / doubleCurrentReviewed;
        }
        // Update total acceptance
        Integer total = this.totalDealsAccepted + this.totalDealsRejected;
        if (total != 0) {
            Double doubleTotalDealsAccepted = (Double) this.totalDealsAccepted;
            Double doubleTotalDealsRejected = (Double) this.totalDealsRejected;
            this.totalAcceptance = doubleTotalDealsAccepted / total;
        }
    }

    private Boolean changeActionStatus(String newStatus, Integer counter) {
        Boolean result = null;
        String actionNumber = ApexPages.CurrentPage().getParameters().get('actionNumber');
        if (actionNumber != null) {
            // Retrieve the select deal action
            Deal_Action__c dealAction = [Select Action__c,Deal__c from Deal_Action__c where Deal_Action__c.Name = :actionNumber];

            result = dealAction.Action__c == null;
            // Set to new status
            dealAction.Action__c = newStatus;

            // update deal availability
            Deal__c deal = [Select Available_Deals__c from Deal__c where Id = :dealAction.Deal__c];
            deal.Available_Deals__c = deal.Available_Deals__c + counter;

            try {
                update dealAction;
                this.currentReviewed++;

                // get the current page
                Integer currentPage = setController.getPageNumber();
                // reload controller
                setController.save();
                // put the correct page
                setController.setPageNumber(currentPage);
            } catch (Exception e) {
                // Page message
                ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.Error, Label.Error_Occur_Contact_Admin);
                ApexPages.addMessage(message);
            }
        }

        return result;
    }
}