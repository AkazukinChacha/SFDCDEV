/**
 * Class to handle JSON retrieved from https://yourInstance.salesforce.com/services/data/
 *
 * The JSON structure must be like this (example)
 * [
 *  {
 *      "version" : "20.0",
 *      "label" : "Winter '11",
 *      "url" : "/services/data/v20.0"
 *  },
 *  {
 *      "version" : "21.0",
 *      "label" : "Spring '11",
 *      "url" : "/services/data/v21.0"
 *  },
 *  ...
 *  {
 *      "version" : "26.0",
 *      "label" : "Winter '13",
 *      "url" : "/services/data/v26.0"
 *  }
 * ]
 */
public class eAPIVersions {

    /**
     * Class to handle JSON retrieved from https://yourInstance.salesforce.com/services/data/
     * It represent an entry in the array
     */
    public class AvailableAPIVersion {
        public String label;
        public String url;
        public String version;
    }

    /**
     * Parse the given JSON string and return a list of AvailableAPIVersion.
     *
     * @param jsonString the JSON string to parse
     * @return a list of AvailableAPIVersion
     */
    public static List<AvailableAPIVersion> parse(String jsonString) {
        List<AvailableAPIVersion> apiVersions = (List<AvailableAPIVersion>) JSON.deserialize(jsonString, List<AvailableAPIVersion>.class);
        return apiVersions;
    }
}