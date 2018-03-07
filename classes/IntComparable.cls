/**
 * Class implementing comparable.
 * This class provide a public String named order that can be set to 'ASC' (default) or 'DESC' before calling the sort method.
 * 'ASC' will sort Integer in ascending order and 'DESC' will sort in descending order.
 */
global class IntComparable implements Comparable {

    /**
     * Internal use.
     */
    public Integer intValue;
    /**
     * Order for the sort. Can be 'ASC' or 'DESC'.
     */
    public static String order = 'ASC';

    /**
     * Constructor.
     *
     * @param integer value
     */
    public IntComparable(Integer val) {
        intValue = val;
    }

    /**
     * Internal use.
     * Implementation of Integer compareTo(Object param1); of Comparable interface.
     */
    public Integer compareTo(Object input) {
        Integer result;
        if (IntComparable.order == 'ASC') {
            result = compareASC(input);
        } else {
            result = compareDESC(input);
        }
        return result;
    }

    private Integer compareASC(Object input) {
        IntComparable intIn = (IntComparable) input;
        if (intValue < intIn.intValue) {
            return -1;
        } else if (intValue > intIn.intValue) {
            return 1;
        } else {
            return 0;
        }
    }

    private Integer compareDESC(Object input) {
        IntComparable intIn = (IntComparable) input;
        if (intValue < intIn.intValue) {
            return 1;
        } else if (intValue > intIn.intValue) {
            return -1;
        } else {
            return 0;
        }
    }
}