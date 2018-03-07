public class StringArrayTest {
     
       
    public static List<String> generateStringArray(Integer i) {
		List<String> result = new List<String>();
    	for (Integer j=0; j< i; j++) {
    		String test = 'Test '+String.ValueOf(j);
    		result.add(test);
    	}
    	
    	return result;
    }
    
}