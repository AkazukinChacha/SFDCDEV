//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class Animals {

	public Animal animal;

	public class Animal {
		public Integer id;
		public String name;
		public String eats;
		public String says;
	}

	
	public static Animals parse(String json) {
		return (Animals) System.JSON.deserialize(json, Animals.class);
	}
}