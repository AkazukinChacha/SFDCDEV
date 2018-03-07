trigger testconvertdelete on Lead (before delete, after delete) {
    System.debug('CONVERT LEAD TRIGGER ON DELETE--------------------------------------------------------------------------------------------------');
}