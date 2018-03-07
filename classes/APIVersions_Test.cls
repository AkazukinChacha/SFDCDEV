/**
 * Test class for the class AvailableAPIVersions.
 *
 * Should give 100% of code coverage
 */
@IsTest
public class APIVersions_Test {

    /**
     * Parse a valid JSON string.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void parseValidJSON() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"url\" : \"/services/data/v39.0\",' +
                '  \"version\" : \"39.0\"' +
                '} ]';
        List<APIVersions.AvailableAPIVersion> versions = APIVersions.parse(json);
        System.assert(versions != null);
        System.assertEquals(versions.size(), 1);
        System.assertEquals(versions.get(0).label, 'Spring \'17');
        System.assertEquals(versions.get(0).url, '/services/data/v39.0');
        System.assertEquals(versions.get(0).version, '39.0');
    }

    /**
     * Parse a JSON string with invalid values.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void parseInvalidJSONValue() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"url\" : \"/services/data/v39.0\",' +
                '  \"version\" : 39.0' +
                '} ]';
        List<APIVersions.AvailableAPIVersion> versions = APIVersions.parse(json);
        System.assert(versions != null);
        System.assertEquals(versions.size(), 1);
        System.assertEquals(versions.get(0).label, 'Spring \'17');
        System.assertEquals(versions.get(0).url, '/services/data/v39.0');
        System.assertEquals(versions.get(0).version, '39.0');
    }

    /**
     * Parse a JSON string with invalid names.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void parseInvalidJSONName() {
        String json = '[ {' +
                '  \"riri\" : \"Spring \'17\",' +
                '  \"fifi\" : \"/services/data/v39.0\",' +
                '  \"loulou\" : \"39.0\"' +
                '} ]';
        List<APIVersions.AvailableAPIVersion> versions = APIVersions.parse(json);
        System.assert(versions != null);
        System.assertEquals(versions.size(), 1);
        System.assertEquals(versions.get(0).label, null);
        System.assertEquals(versions.get(0).url, null);
        System.assertEquals(versions.get(0).version, null);
    }

    /**
     * Parse a JSON string with partial name & values.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void parsePartialValidJSON() {
        String json = '[ {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"version\" : \"39.0\"' +
                '} ]';
        List<APIVersions.AvailableAPIVersion> versions = APIVersions.parse(json);
        System.assert(versions != null);
        System.assertEquals(versions.size(), 1);
        System.assertEquals(versions.get(0).label, 'Spring \'17');
        System.assertEquals(versions.get(0).url, null);
        System.assertEquals(versions.get(0).version, '39.0');
    }

    /**
     * Parse a JSON string withan invalid structure.
     *
     * @see AvailableAPIVersions for the structure of the JSON
     */
    static testMethod void parseInvalidJSONStructure() {
        String json = ' {' +
                '  \"label\" : \"Spring \'17\",' +
                '  \"version\" : \"39.0\"' +
                '} ';

        try {
            List<APIVersions.AvailableAPIVersion> versions = APIVersions.parse(json);
        } catch (System.JSONException e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Malformed JSON') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
}