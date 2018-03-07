@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        // Call the method that invokes a callout

		List<String> result = ParkLocator.country('');

        // Verify that a fake result is returned

        System.assertEquals(4, result.size()); 
    }

}