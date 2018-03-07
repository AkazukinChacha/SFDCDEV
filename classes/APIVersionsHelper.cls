/**
 * This class consists of static methods that operate on JSON strings retrieve from the https://yourInstance.salesforce.com/services/data/ REST API and updating methods.
 *
 * The URL https://yourInstance.salesforce.com/services/data/ lists summary information about each Salesforce version of 'yourInstance' instance currently available, including the version, label, and a link to each version's root.
 */
public class APIVersionsHelper {

    /**
     * Get the higher (latest) API version based on given JSON string
     *
     * @param json JSON String from the URL 'https://yourInstance.salesforce.com/services/data/'
     * @return latest API version found or -1 if nothing founded in the string
     */
    public static Integer getLatestAvailableAPIVersions(String json) {
        Integer result = -1;

        try {
            List<APIVersions.AvailableAPIVersion> versions = APIVersions.parse(json);
            if (versions != null && versions.size() > 0) {
                List<IntComparable> versionList = new List<IntComparable>();

                for (Integer i = 0; i < versions.size(); i++) {
                    APIVersions.AvailableAPIVersion apiVersion = versions.get(i);
                    if (versions != null) {
                        String version = versions.get(i).version;
                        if (version != null) {
                            try {
                                Integer versionInt = Integer.valueOf(version);
                                versionList.add(new IntComparable(versionInt));
                            } catch (System.TypeException e) {
                                // Invalid number format, nothing to do
                            }
                        }
                    }
                }

                if (versionList.size() > 0) {
                    IntComparable.order = 'DESC';
                    versionList.sort();
                    result = versionList.get(0).intValue;
                }
            }
        } catch (System.JSONException e) {
            // Nothing to do, just put a trace in debug
            System.debug('APIVersionsHelper.getLatestAvailableAPIVersions : '+ e.getMessage());
        }

        return result;
    }

    /**
     * Update the given list of Salesforce_Instance__c with the lastest API version found.
     *
     * @param records list of Salesforce_Instance__c to check and update if needed.
     * @param suffix String to append at the Salesforce_Instance__c.Server_Url__c to get the list of the available API versions on this Salesforce instance.
     */
    public static void updateSalesforceInstances(List<Salesforce_Instance__c> records) {
        List<Salesforce_Instance__c> toBeUpdatedSalesforceInstanceList = new List<Salesforce_Instance__c>();
        for (Salesforce_Instance__c salesforceInstance: records) {
            String url = salesforceInstance.Server_Url__c;
            Integer latestAPIVersion = APIVersionsRestCall.getLatestAvailableAPIVersions(url);
            // Correct answer ?
            if (latestAPIVersion > 0) {
                // Update only if higher version
                if (latestAPIVersion > salesforceInstance.API_Version__c) {
                    salesforceInstance.API_Version__c = latestAPIVersion;
                    toBeUpdatedSalesforceInstanceList.add(salesforceInstance);
                }
            }
        }
        update toBeUpdatedSalesforceInstanceList;
    }
}