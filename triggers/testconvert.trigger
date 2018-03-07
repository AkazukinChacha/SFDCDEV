trigger testconvert on Lead (after update) {
    System.debug('LEAD CONVERTED --------------------------------------------------');
}