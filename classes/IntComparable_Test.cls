/**
 * Test class for the class APIVersionsRestCall.
 *
 * Should give 100% of code coverage
 */
@isTest
public class IntComparable_Test {

    /**
     * Test ASC order.
     */
    @isTest static void ascSort() {
        IntComparable[] details = new IntComparable[0];
        for(Integer i = 0; i < 4; i++) {
            details.add(new IntComparable(Crypto.getRandomInteger()));
        }
        details.sort();
        for(Integer i = 0; i < 3; i++) {
            System.assert(details[i].intValue < details[i+1].intValue);
        }
    }

    /**
     * Test ASC order with same values.
     */
    @isTest static void ascSortWithSameValues() {
        IntComparable[] details = new IntComparable[0];
        for(Integer i = 0; i < 4; i++) {
            details.add(new IntComparable(1));
        }
        details.sort();
        for(Integer i = 0; i < 3; i++) {
            System.assert(details[i].intValue == details[i+1].intValue);
        }
    }

    /**
     * Test DESC order.
     */
    @isTest static void descSort() {
        IntComparable[] details = new IntComparable[0];
        for(Integer i = 0; i < 4; i++) {
            details.add(new IntComparable(Crypto.getRandomInteger()));
        }
        IntComparable.order = 'DESC';
        details.sort();
        for(Integer i = 0; i < 3; i++) {
            System.assert(details[i].intValue > details[i+1].intValue);
        }
    }

     /**
     * Test DESC order with same values.
     */
    @isTest static void descSortWithSameValues() {
        IntComparable[] details = new IntComparable[0];
        for(Integer i = 0; i < 4; i++) {
            details.add(new IntComparable(1));
        }
        IntComparable.order = 'DESC';
        details.sort();
        for(Integer i = 0; i < 3; i++) {
            System.assert(details[i].intValue == details[i+1].intValue);
        }
    }
}