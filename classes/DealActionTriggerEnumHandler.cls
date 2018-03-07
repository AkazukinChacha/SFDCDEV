/**
 * This class consist only on methods handling DealActionTriggerEnum.
 *
 * For instance, you can retrieve the correct DealActionTriggerEnum based on old action value and new action value.
 * You can then use it in the DealActionTriggerHandler for example.
 */
public class DealActionTriggerEnumHandler {

    /**
     * Get DealActionTriggerEnum based on given old action value, new action value and DML called.
     *
     * @param oldValue the old value of the Action
     * @param newValue the new value of the Action
     * @param deleted <code>true</code> if the database calling is delete or undelete
     * @return DealActionTriggerEnum base on given old action value and new action value.
     */
    public static DealActionTriggerEnum getDealActionTriggerEnum(String oldValue, String newValue, Boolean deleted) {
        DealActionTriggerEnum result = null;

        if (deleted) {
            if ('Accepted'.equals(newValue)) {
                result = DealActionTriggerEnum.DELETED_FROM_ACCEPTED;
            } else if ('Rejected'.equals(newValue)) {
                result = DealActionTriggerEnum.DELETED_FROM_REJECTED;
            }
        } else {
            // calling method update or create database call
            if (oldValue == null) {
                // was an empty value
                if ('Accepted'.equals(newValue)) {
                    result = DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_ACCEPTED;
                } else if ('Rejected'.equals(newValue)) {
                    result = DealActionTriggerEnum.CHANGED_FROM_EMPTY_TO_REJECTED;
                }
            } else {
                // was a non-empty value
                if (!oldvalue.equals(newValue)) {
                    // values changed
                    if ('Accepted'.equals(newValue)) {
                        result = DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_ACCEPTED;
                    } else if ('Rejected'.equals(newValue)) {
                        result = DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_REJECTED;
                    } else {
                        if ('Accepted'.equals(oldValue)) {
                            result = DealActionTriggerEnum.CHANGED_FROM_ACCEPTED_TO_EMPTY;
                        } else if ('Rejected'.equals(oldValue)) {
                            result = DealActionTriggerEnum.CHANGED_FROM_REJECTED_TO_EMPTY;
                        }
                    }
                }
            }
        }

        return result;
    }
}